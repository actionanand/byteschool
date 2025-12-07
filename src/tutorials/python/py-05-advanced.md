# Python Advanced Concepts

## Context Managers (`with` statement)

Context managers handle setup and cleanup automatically.

### Built-in Context Managers

```python
# File handling - automatically closes file
with open('data.txt', 'r') as file:
    content = file.read()
    # Process content...
# File is automatically closed here

# Multiple context managers
with open('input.txt', 'r') as infile, open('output.txt', 'w') as outfile:
    content = infile.read()
    outfile.write(content.upper())

# Database connections
import sqlite3
with sqlite3.connect('database.db') as conn:
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM users')
    # Connection auto-commits and closes
```

### Creating Custom Context Managers

```python
# Method 1: Class-based
class DatabaseConnection:
    def __init__(self, db_name: str):
        self.db_name = db_name
        self.connection = None
    
    def __enter__(self):
        """Called when entering 'with' block"""
        print(f"Connecting to {self.db_name}")
        self.connection = f"Connected to {self.db_name}"
        return self.connection
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        """Called when exiting 'with' block"""
        print(f"Closing connection to {self.db_name}")
        self.connection = None
        return False  # Don't suppress exceptions

# Usage
with DatabaseConnection('mydb.db') as conn:
    print(f"Using: {conn}")
# Output:
# Connecting to mydb.db
# Using: Connected to mydb.db
# Closing connection to mydb.db

# Method 2: Using @contextmanager decorator
from contextlib import contextmanager

@contextmanager
def timer():
    import time
    start = time.time()
    try:
        yield  # Code in 'with' block runs here
    finally:
        end = time.time()
        print(f"Elapsed: {end - start:.2f} seconds")

# Usage
with timer():
    sum(range(1000000))
# Output: Elapsed: 0.03 seconds
```

## Generators

Generators produce values **lazily** (on-demand), saving memory.

### Generator Functions

```python
# Regular function - returns list (memory intensive)
def get_squares(n):
    result = []
    for i in range(n):
        result.append(i ** 2)
    return result

squares = get_squares(1000000)  # Creates 1M item list immediately

# Generator function - yields values one at a time
def get_squares_gen(n):
    for i in range(n):
        yield i ** 2  # Pauses here, resumes on next iteration

squares = get_squares_gen(1000000)  # Creates generator object (tiny)

# Iterate through generator
for square in squares:
    print(square)
    if square > 100:
        break  # Can stop early, rest never computed

# Generator expression (like list comprehension)
squares = (x**2 for x in range(1000000))  # Generator (lazy)
squares_list = [x**2 for x in range(1000000)]  # List (eager)
```

### Practical Generator Examples

```python
# Read large file line by line (memory efficient)
def read_large_file(file_path):
    with open(file_path) as file:
        for line in file:
            yield line.strip()

# Process CSV data
def parse_csv(file_path):
    with open(file_path) as file:
        header = next(file).strip().split(',')
        for line in file:
            values = line.strip().split(',')
            yield dict(zip(header, values))

# Infinite sequences
def fibonacci():
    a, b = 0, 1
    while True:
        yield a
        a, b = b, a + b

# Use with islice to limit
from itertools import islice
first_10 = list(islice(fibonacci(), 10))
```

## Advanced Decorators

### Decorators with Arguments

```python
def retry(max_attempts: int, delay: float = 1.0):
    """Decorator that retries function on failure"""
    def decorator(func):
        def wrapper(*args, **kwargs):
            import time
            for attempt in range(max_attempts):
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    if attempt == max_attempts - 1:
                        raise
                    print(f"Attempt {attempt + 1} failed: {e}")
                    time.sleep(delay)
        return wrapper
    return decorator

@retry(max_attempts=3, delay=0.5)
def fetch_data(url):
    # Simulated network request
    import random
    if random.random() < 0.7:
        raise ConnectionError("Network error")
    return "Data fetched"

# Preserving function metadata
from functools import wraps

def debug(func):
    @wraps(func)  # Preserves original function's name, docstring, etc.
    def wrapper(*args, **kwargs):
        print(f"Calling {func.__name__} with {args}, {kwargs}")
        result = func(*args, **kwargs)
        print(f"{func.__name__} returned {result}")
        return result
    return wrapper

@debug
def add(a, b):
    """Add two numbers"""
    return a + b

print(add.__name__)  # "add" (without @wraps would be "wrapper")
print(add.__doc__)   # "Add two numbers"
```

### Class Decorators

```python
def singleton(cls):
    """Ensure only one instance of class exists"""
    instances = {}
    def get_instance(*args, **kwargs):
        if cls not in instances:
            instances[cls] = cls(*args, **kwargs)
        return instances[cls]
    return get_instance

@singleton
class Database:
    def __init__(self):
        print("Database initialized")

db1 = Database()  # "Database initialized"
db2 = Database()  # No output - returns same instance
print(db1 is db2)  # True
```

## Type Hints - Advanced

```python
# Generic types
from typing import List, Dict, Tuple, Set, Optional, Union, Any

def process_data(
    items: List[str],
    config: Dict[str, Any],
    metadata: Optional[Tuple[int, str]] = None
) -> Union[List[str], None]:
    pass

# Generic classes
from typing import Generic, TypeVar

T = TypeVar('T')

class Stack(Generic[T]):
    def __init__(self):
        self._items: List[T] = []
    
    def push(self, item: T) -> None:
        self._items.append(item)
    
    def pop(self) -> T:
        return self._items.pop()

# Usage with type hints
int_stack: Stack[int] = Stack()
int_stack.push(1)
int_stack.push(2)

str_stack: Stack[str] = Stack()
str_stack.push("hello")

# Protocols (structural subtyping - Python 3.8+)
from typing import Protocol

class Drawable(Protocol):
    def draw(self) -> None:
        ...

def render(obj: Drawable) -> None:
    obj.draw()

class Circle:
    def draw(self) -> None:
        print("Drawing circle")

# Circle implements Drawable protocol (no inheritance needed!)
render(Circle())
```

## Performance Comparisons

### List vs Set vs Dict

```python
import time

# Membership testing
items_list = list(range(100000))
items_set = set(range(100000))
items_dict = {i: True for i in range(100000)}

# List - O(n) - slow for large lists
start = time.time()
99999 in items_list
print(f"List: {time.time() - start:.6f}s")

# Set - O(1) - very fast
start = time.time()
99999 in items_set
print(f"Set: {time.time() - start:.6f}s")

# Dict - O(1) - very fast
start = time.time()
99999 in items_dict
print(f"Dict: {time.time() - start:.6f}s")

# Output (approximate):
# List: 0.002000s
# Set: 0.000001s
# Dict: 0.000001s
```

**When to use what:**

| Data Structure | Use When | Time Complexity |
|----------------|----------|-----------------|
| **List** | Order matters, duplicates allowed | Access: O(1), Search: O(n), Insert: O(n) |
| **Set** | Unique items, fast membership tests | Access: N/A, Search: O(1), Insert: O(1) |
| **Dict** | Key-value pairs, fast lookups | Access: O(1), Search: O(1), Insert: O(1) |
| **Tuple** | Immutable sequence, hashable | Access: O(1), Search: O(n), Insert: N/A |

### Comprehensions vs Loops

```python
# List comprehension - faster
squares = [x**2 for x in range(1000)]

# Equivalent loop - slower
squares = []
for x in range(1000):
    squares.append(x**2)

# Dict comprehension - fast
word_lengths = {word: len(word) for word in ['hello', 'world', 'python']}

# Set comprehension - fast
unique_squares = {x**2 for x in range(-10, 11)}
```

## Advanced Function Techniques

### `*args` and `**kwargs` Unpacking

```python
def greet(greeting, name):
    return f"{greeting}, {name}!"

# Unpack list/tuple with *
args = ["Hello", "Alice"]
greet(*args)  # Same as greet("Hello", "Alice")

# Unpack dict with **
kwargs = {"greeting": "Hi", "name": "Bob"}
greet(**kwargs)  # Same as greet(greeting="Hi", name="Bob")

# Combining in function calls
def config(host, port, debug=False, timeout=30):
    pass

base_config = {"host": "localhost", "port": 8080}
config(**base_config, debug=True)  # Combines both
```

### Closures and Scope

```python
def make_multiplier(factor):
    """Returns a function that multiplies by factor"""
    def multiply(x):
        return x * factor  # Accesses factor from outer scope
    return multiply

double = make_multiplier(2)
triple = make_multiplier(3)

print(double(5))  # 10
print(triple(5))  # 15

# nonlocal keyword - modify outer scope variable
def counter():
    count = 0
    def increment():
        nonlocal count  # Without this, creates new local variable
        count += 1
        return count
    return increment

c = counter()
print(c())  # 1
print(c())  # 2
```

## Error Handling - Advanced

```python
# Custom exceptions
class ValidationError(Exception):
    """Raised when validation fails"""
    pass

class DatabaseError(Exception):
    """Raised when database operations fail"""
    pass

def validate_age(age: int):
    if age < 0:
        raise ValidationError("Age cannot be negative")
    if age > 150:
        raise ValidationError("Age unrealistic")

# Exception chaining
try:
    validate_age(-5)
except ValidationError as e:
    raise DatabaseError("Failed to save user") from e

# Multiple exception handling
try:
    # Risky code
    result = 10 / 0
except (ZeroDivisionError, ValueError) as e:
    print(f"Math error: {e}")
except Exception as e:
    print(f"Unexpected error: {e}")
    raise  # Re-raise the exception
else:
    print("No exceptions occurred")
finally:
    print("Always executes")
```

## Dataclasses (Python 3.7+)

Simplifies class creation for data-holding objects.

```python
from dataclasses import dataclass, field
from typing import List

@dataclass
class Person:
    name: str
    age: int
    email: str = ""  # Default value
    hobbies: List[str] = field(default_factory=list)  # Mutable default
    
    def __post_init__(self):
        """Called after __init__"""
        if self.age < 0:
            raise ValueError("Age cannot be negative")

# Auto-generates __init__, __repr__, __eq__, etc.
person = Person("Alice", 30)
print(person)  # Person(name='Alice', age=30, email='', hobbies=[])

# Comparison
@dataclass(order=True)
class Employee:
    name: str
    salary: int

emp1 = Employee("Alice", 50000)
emp2 = Employee("Bob", 60000)
print(emp1 < emp2)  # True (compares salary)

# Frozen (immutable)
@dataclass(frozen=True)
class Point:
    x: int
    y: int

p = Point(1, 2)
# p.x = 5  # ❌ FrozenInstanceError
```

## Itertools - Powerful Iteration

```python
from itertools import *

# chain - combine iterables
list(chain([1, 2], [3, 4], [5, 6]))  # [1, 2, 3, 4, 5, 6]

# cycle - repeat infinitely
counter = cycle([1, 2, 3])
[next(counter) for _ in range(7)]  # [1, 2, 3, 1, 2, 3, 1]

# groupby - group consecutive items
data = [('A', 1), ('A', 2), ('B', 3), ('B', 4)]
for key, group in groupby(data, lambda x: x[0]):
    print(key, list(group))
# A [('A', 1), ('A', 2)]
# B [('B', 3), ('B', 4)]

# combinations and permutations
list(combinations([1, 2, 3], 2))  # [(1, 2), (1, 3), (2, 3)]
list(permutations([1, 2, 3], 2))  # [(1, 2), (1, 3), (2, 1), (2, 3), (3, 1), (3, 2)]

# product - cartesian product
list(product([1, 2], ['a', 'b']))  # [(1, 'a'), (1, 'b'), (2, 'a'), (2, 'b')]
```

---

**Navigation:**
- [← Previous: Classes & OOP](#/py-classes)
- [→ Next: Database Operations](#/py-database)
- [↑ Back to Python Basics](#/py-basics)
- [🏠 Home](#/home)
