# Python Database Operations

## SQLite Basics

SQLite is a lightweight, serverless database built into Python.

### Connecting to Database

```python
import sqlite3

# Connect to database (creates if doesn't exist)
conn = sqlite3.connect('example.db')

# In-memory database (for testing)
conn = sqlite3.connect(':memory:')

# Create cursor for executing commands
cursor = conn.cursor()

# Always close connection when done
conn.close()

# Better: Use context manager (auto-closes)
with sqlite3.connect('example.db') as conn:
    cursor = conn.cursor()
    # Do database operations...
# Connection auto-commits and closes
```

### Creating Tables

```python
with sqlite3.connect('example.db') as conn:
    cursor = conn.cursor()
    
    # Create users table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            age INTEGER,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    
    # Create posts table with foreign key
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS posts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            title TEXT NOT NULL,
            content TEXT,
            FOREIGN KEY (user_id) REFERENCES users (id)
        )
    ''')
    
    conn.commit()
```

### Inserting Data

```python
with sqlite3.connect('example.db') as conn:
    cursor = conn.cursor()
    
    # Insert single row - ALWAYS use ? placeholders (prevents SQL injection)
    cursor.execute(
        'INSERT INTO users (name, email, age) VALUES (?, ?, ?)',
        ('Alice', 'alice@example.com', 30)
    )
    
    # Get the ID of last inserted row
    user_id = cursor.lastrowid
    print(f"Inserted user with ID: {user_id}")
    
    # Insert multiple rows
    users = [
        ('Bob', 'bob@example.com', 25),
        ('Charlie', 'charlie@example.com', 35),
        ('Diana', 'diana@example.com', 28)
    ]
    cursor.executemany(
        'INSERT INTO users (name, email, age) VALUES (?, ?, ?)',
        users
    )
    
    # Get number of affected rows
    print(f"Inserted {cursor.rowcount} users")
    
    conn.commit()  # Important: commit changes
```

### Querying Data

```python
with sqlite3.connect('example.db') as conn:
    cursor = conn.cursor()
    
    # Fetch all rows
    cursor.execute('SELECT * FROM users')
    all_users = cursor.fetchall()
    for user in all_users:
        print(user)  # Tuple: (1, 'Alice', 'alice@example.com', 30, '2024-01-15')
    
    # Fetch one row
    cursor.execute('SELECT * FROM users WHERE name = ?', ('Alice',))
    user = cursor.fetchone()
    print(user)
    
    # Fetch with limit
    cursor.execute('SELECT * FROM users LIMIT 5')
    users = cursor.fetchmany(5)
    
    # Get rows as dictionaries (easier to work with)
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM users')
    users = cursor.fetchall()
    for user in users:
        print(user['name'], user['email'])  # Access by column name
    
    # Iterate over large result sets (memory efficient)
    for row in cursor.execute('SELECT * FROM users'):
        print(row)
```

### Updating Data

```python
with sqlite3.connect('example.db') as conn:
    cursor = conn.cursor()
    
    # Update single row
    cursor.execute(
        'UPDATE users SET age = ? WHERE name = ?',
        (31, 'Alice')
    )
    print(f"Updated {cursor.rowcount} rows")
    
    # Update multiple rows
    cursor.execute(
        'UPDATE users SET age = age + 1 WHERE age < ?',
        (30,)
    )
    
    conn.commit()
```

### Deleting Data

```python
with sqlite3.connect('example.db') as conn:
    cursor = conn.cursor()
    
    # Delete specific row
    cursor.execute('DELETE FROM users WHERE name = ?', ('Bob',))
    
    # Delete with condition
    cursor.execute('DELETE FROM users WHERE age > ?', (60,))
    
    # Delete all rows (keep table structure)
    cursor.execute('DELETE FROM users')
    
    # Drop entire table
    cursor.execute('DROP TABLE IF EXISTS users')
    
    conn.commit()
```

## Database Class Pattern

Create a class to manage database operations.

```python
import sqlite3
from typing import List, Optional, Dict, Any

class Database:
    def __init__(self, db_path: str):
        self.db_path = db_path
        self.connection: Optional[sqlite3.Connection] = None
    
    def connect(self):
        """Establish database connection"""
        self.connection = sqlite3.connect(self.db_path)
        self.connection.row_factory = sqlite3.Row  # Return rows as dicts
        return self
    
    def close(self):
        """Close database connection"""
        if self.connection:
            self.connection.close()
    
    def __enter__(self):
        """Context manager entry"""
        return self.connect()
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        """Context manager exit"""
        self.close()
    
    def execute(self, query: str, params: tuple = ()) -> sqlite3.Cursor:
        """Execute a query"""
        cursor = self.connection.cursor()
        cursor.execute(query, params)
        self.connection.commit()
        return cursor
    
    def fetch_one(self, query: str, params: tuple = ()) -> Optional[Dict[str, Any]]:
        """Fetch single row as dictionary"""
        cursor = self.execute(query, params)
        row = cursor.fetchone()
        return dict(row) if row else None
    
    def fetch_all(self, query: str, params: tuple = ()) -> List[Dict[str, Any]]:
        """Fetch all rows as list of dictionaries"""
        cursor = self.execute(query, params)
        rows = cursor.fetchall()
        return [dict(row) for row in rows]
    
    def create_tables(self):
        """Initialize database schema"""
        self.execute('''
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                email TEXT UNIQUE NOT NULL,
                age INTEGER
            )
        ''')

# Usage
with Database('myapp.db') as db:
    db.create_tables()
    
    # Insert user
    db.execute(
        'INSERT INTO users (name, email, age) VALUES (?, ?, ?)',
        ('Alice', 'alice@example.com', 30)
    )
    
    # Fetch user
    user = db.fetch_one('SELECT * FROM users WHERE email = ?', ('alice@example.com',))
    print(user['name'])  # Alice
    
    # Fetch all users
    users = db.fetch_all('SELECT * FROM users WHERE age > ?', (25,))
    for user in users:
        print(user['name'], user['age'])
```

## ORM Pattern (Object-Relational Mapping)

Map database rows to Python objects.

```python
from dataclasses import dataclass
from typing import Optional, List
import sqlite3

@dataclass
class User:
    name: str
    email: str
    age: int
    id: Optional[int] = None
    
    @classmethod
    def from_row(cls, row: sqlite3.Row) -> 'User':
        """Create User from database row"""
        return cls(
            id=row['id'],
            name=row['name'],
            email=row['email'],
            age=row['age']
        )
    
    def to_dict(self) -> dict:
        """Convert to dictionary for database insertion"""
        return {
            'name': self.name,
            'email': self.email,
            'age': self.age
        }

class UserRepository:
    def __init__(self, db_path: str):
        self.db_path = db_path
    
    def _get_connection(self):
        conn = sqlite3.connect(self.db_path)
        conn.row_factory = sqlite3.Row
        return conn
    
    def create_table(self):
        with self._get_connection() as conn:
            conn.execute('''
                CREATE TABLE IF NOT EXISTS users (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    name TEXT NOT NULL,
                    email TEXT UNIQUE NOT NULL,
                    age INTEGER
                )
            ''')
    
    def create(self, user: User) -> User:
        """Insert new user and return with ID"""
        with self._get_connection() as conn:
            cursor = conn.execute(
                'INSERT INTO users (name, email, age) VALUES (?, ?, ?)',
                (user.name, user.email, user.age)
            )
            user.id = cursor.lastrowid
        return user
    
    def find_by_id(self, user_id: int) -> Optional[User]:
        """Find user by ID"""
        with self._get_connection() as conn:
            cursor = conn.execute('SELECT * FROM users WHERE id = ?', (user_id,))
            row = cursor.fetchone()
            return User.from_row(row) if row else None
    
    def find_by_email(self, email: str) -> Optional[User]:
        """Find user by email"""
        with self._get_connection() as conn:
            cursor = conn.execute('SELECT * FROM users WHERE email = ?', (email,))
            row = cursor.fetchone()
            return User.from_row(row) if row else None
    
    def find_all(self) -> List[User]:
        """Get all users"""
        with self._get_connection() as conn:
            cursor = conn.execute('SELECT * FROM users')
            return [User.from_row(row) for row in cursor.fetchall()]
    
    def update(self, user: User) -> bool:
        """Update existing user"""
        with self._get_connection() as conn:
            cursor = conn.execute(
                'UPDATE users SET name = ?, email = ?, age = ? WHERE id = ?',
                (user.name, user.email, user.age, user.id)
            )
            return cursor.rowcount > 0
    
    def delete(self, user_id: int) -> bool:
        """Delete user by ID"""
        with self._get_connection() as conn:
            cursor = conn.execute('DELETE FROM users WHERE id = ?', (user_id,))
            return cursor.rowcount > 0

# Usage
repo = UserRepository('myapp.db')
repo.create_table()

# Create user
user = User(name="Alice", email="alice@example.com", age=30)
user = repo.create(user)
print(f"Created user with ID: {user.id}")

# Find user
found_user = repo.find_by_id(user.id)
print(found_user.name)

# Update user
found_user.age = 31
repo.update(found_user)

# Get all users
all_users = repo.find_all()
for u in all_users:
    print(u.name, u.age)

# Delete user
repo.delete(user.id)
```

## Advanced Queries

### Joins

```python
with sqlite3.connect('example.db') as conn:
    cursor = conn.cursor()
    
    # INNER JOIN - get users with their posts
    cursor.execute('''
        SELECT users.name, users.email, posts.title, posts.content
        FROM users
        INNER JOIN posts ON users.id = posts.user_id
    ''')
    
    # LEFT JOIN - get all users, including those without posts
    cursor.execute('''
        SELECT users.name, COUNT(posts.id) as post_count
        FROM users
        LEFT JOIN posts ON users.id = posts.user_id
        GROUP BY users.id
    ''')
    
    for row in cursor.fetchall():
        print(row)
```

### Aggregation

```python
with sqlite3.connect('example.db') as conn:
    cursor = conn.cursor()
    
    # Count users
    cursor.execute('SELECT COUNT(*) FROM users')
    count = cursor.fetchone()[0]
    
    # Average age
    cursor.execute('SELECT AVG(age) FROM users')
    avg_age = cursor.fetchone()[0]
    
    # Group by with aggregation
    cursor.execute('''
        SELECT age, COUNT(*) as count
        FROM users
        GROUP BY age
        HAVING count > 1
        ORDER BY count DESC
    ''')
```

### Transactions

```python
with sqlite3.connect('example.db') as conn:
    cursor = conn.cursor()
    
    try:
        # Start transaction (implicit)
        cursor.execute('UPDATE users SET age = age + 1 WHERE id = ?', (1,))
        cursor.execute('INSERT INTO posts (user_id, title) VALUES (?, ?)', (1, 'New Post'))
        
        # Commit if both succeed
        conn.commit()
    except Exception as e:
        # Rollback if any operation fails
        conn.rollback()
        print(f"Transaction failed: {e}")
```

## Connection Pooling (For Concurrent Apps)

```python
from queue import Queue
from threading import Lock
import sqlite3

class ConnectionPool:
    def __init__(self, db_path: str, max_connections: int = 5):
        self.db_path = db_path
        self.pool = Queue(maxsize=max_connections)
        self.lock = Lock()
        
        # Pre-create connections
        for _ in range(max_connections):
            conn = sqlite3.connect(db_path, check_same_thread=False)
            conn.row_factory = sqlite3.Row
            self.pool.put(conn)
    
    def get_connection(self):
        """Get connection from pool"""
        return self.pool.get()
    
    def return_connection(self, conn):
        """Return connection to pool"""
        self.pool.put(conn)
    
    def close_all(self):
        """Close all connections"""
        while not self.pool.empty():
            conn = self.pool.get()
            conn.close()

# Usage
pool = ConnectionPool('myapp.db', max_connections=5)

def do_database_work():
    conn = pool.get_connection()
    try:
        cursor = conn.cursor()
        cursor.execute('SELECT * FROM users')
        # Process results...
    finally:
        pool.return_connection(conn)
```

## Best Practices

```python
# ✅ DO: Use parameterized queries (prevents SQL injection)
cursor.execute('SELECT * FROM users WHERE email = ?', (email,))

# ❌ DON'T: Use string formatting (SQL injection risk!)
cursor.execute(f'SELECT * FROM users WHERE email = "{email}"')

# ✅ DO: Use context managers
with sqlite3.connect('db.db') as conn:
    cursor = conn.cursor()
    # Auto-commits and closes

# ✅ DO: Use transactions for related operations
try:
    cursor.execute('UPDATE accounts SET balance = balance - 100 WHERE id = ?', (1,))
    cursor.execute('UPDATE accounts SET balance = balance + 100 WHERE id = ?', (2,))
    conn.commit()
except:
    conn.rollback()

# ✅ DO: Create indexes for frequently queried columns
cursor.execute('CREATE INDEX idx_email ON users (email)')

# ✅ DO: Close connections in production
conn.close()

# ✅ DO: Handle database errors
try:
    cursor.execute('INSERT INTO users (email) VALUES (?)', (email,))
except sqlite3.IntegrityError:
    print("Email already exists")
except sqlite3.OperationalError:
    print("Database error")
```

## Popular ORMs

For larger projects, consider using an ORM library:

### SQLAlchemy

```python
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

Base = declarative_base()

class User(Base):
    __tablename__ = 'users'
    
    id = Column(Integer, primary_key=True)
    name = Column(String, nullable=False)
    email = Column(String, unique=True, nullable=False)

engine = create_engine('sqlite:///example.db')
Base.metadata.create_all(engine)

Session = sessionmaker(bind=engine)
session = Session()

# Create
user = User(name='Alice', email='alice@example.com')
session.add(user)
session.commit()

# Query
users = session.query(User).filter(User.age > 25).all()
```

---

**Navigation:**
- [← Previous: Advanced Concepts](/?page=python/py-05-advanced)
- [→ Next: File Organization](/?page=python/py-07-file-organization)
- [↑ Back to Python Basics](/?page=python/py-01-basics)
- [🏠 Home](/?page=home)
