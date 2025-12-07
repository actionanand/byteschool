# Python Frameworks & Libraries Reference

A comprehensive guide to the most important Python frameworks and libraries for different domains.

## Web Frameworks

### Flask (Micro-framework)

**Best for:** REST APIs, small web apps, microservices

```python
from flask import Flask, request, jsonify, render_template

app = Flask(__name__)

# Simple route
@app.route('/')
def home():
    return "Hello, World!"

# Route with parameter
@app.route('/api/users/<int:user_id>')
def get_user(user_id):
    return jsonify({'id': user_id, 'name': 'Alice'})

# POST endpoint
@app.route('/api/users', methods=['POST'])
def create_user():
    data = request.get_json()
    return jsonify({'status': 'created', 'data': data}), 201

# Template rendering
@app.route('/dashboard')
def dashboard():
    return render_template('dashboard.html', user='Alice')

# Error handling
@app.errorhandler(404)
def not_found(error):
    return jsonify({'error': 'Not found'}), 404

if __name__ == '__main__':
    app.run(debug=True, port=5000)
```

**Installation:**
```bash
pip install flask
pip install flask-cors  # For CORS support
pip install flask-sqlalchemy  # Database ORM
```

---

### Django (Full-stack Framework)

**Best for:** Large web applications, CMS, admin panels, full-stack projects

```python
# models.py
from django.db import models
from django.contrib.auth.models import User

class Post(models.Model):
    title = models.CharField(max_length=200)
    content = models.TextField()
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'posts'
        ordering = ['-created_at']
    
    def __str__(self):
        return self.title

# views.py
from django.shortcuts import render, get_object_or_404
from django.http import JsonResponse
from .models import Post

def post_list(request):
    posts = Post.objects.all()
    return render(request, 'posts/list.html', {'posts': posts})

def post_detail(request, post_id):
    post = get_object_or_404(Post, id=post_id)
    return render(request, 'posts/detail.html', {'post': post})

# API view
from rest_framework.decorators import api_view
from rest_framework.response import Response

@api_view(['GET', 'POST'])
def api_posts(request):
    if request.method == 'GET':
        posts = Post.objects.all().values()
        return Response({'posts': list(posts)})
    elif request.method == 'POST':
        # Create post logic
        return Response({'status': 'created'}, status=201)

# urls.py
from django.urls import path
from . import views

urlpatterns = [
    path('posts/', views.post_list, name='post_list'),
    path('posts/<int:post_id>/', views.post_detail, name='post_detail'),
    path('api/posts/', views.api_posts, name='api_posts'),
]
```

**Installation:**
```bash
pip install django
pip install djangorestframework  # For REST APIs
pip install django-cors-headers  # For CORS
```

**Quick Start:**
```bash
django-admin startproject myproject
cd myproject
python manage.py startapp myapp
python manage.py runserver
```

---

### FastAPI (Modern API Framework)

**Best for:** High-performance APIs, async operations, auto-documentation

```python
from fastapi import FastAPI, HTTPException, Depends, status
from pydantic import BaseModel, EmailStr
from typing import List, Optional
import uvicorn

app = FastAPI(title="My API", version="1.0.0")

# Pydantic models for validation
class UserCreate(BaseModel):
    name: str
    email: EmailStr
    age: int

class User(BaseModel):
    id: int
    name: str
    email: EmailStr
    age: int

# In-memory database
users_db: List[User] = []

# Routes
@app.get("/")
async def root():
    return {"message": "Welcome to FastAPI"}

@app.post("/users/", response_model=User, status_code=status.HTTP_201_CREATED)
async def create_user(user: UserCreate):
    new_user = User(id=len(users_db) + 1, **user.dict())
    users_db.append(new_user)
    return new_user

@app.get("/users/", response_model=List[User])
async def list_users():
    return users_db

@app.get("/users/{user_id}", response_model=User)
async def get_user(user_id: int):
    for user in users_db:
        if user.id == user_id:
            return user
    raise HTTPException(status_code=404, detail="User not found")

@app.put("/users/{user_id}", response_model=User)
async def update_user(user_id: int, user_update: UserCreate):
    for i, user in enumerate(users_db):
        if user.id == user_id:
            users_db[i] = User(id=user_id, **user_update.dict())
            return users_db[i]
    raise HTTPException(status_code=404, detail="User not found")

@app.delete("/users/{user_id}")
async def delete_user(user_id: int):
    for i, user in enumerate(users_db):
        if user.id == user_id:
            users_db.pop(i)
            return {"message": "User deleted"}
    raise HTTPException(status_code=404, detail="User not found")

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
```

**Installation:**
```bash
pip install fastapi
pip install uvicorn[standard]  # ASGI server
```

**Run:**
```bash
uvicorn main:app --reload
# Docs at: http://localhost:8000/docs
```

---

## Data Science & Analysis

### Pandas (Data Manipulation)

**Best for:** Data analysis, CSV/Excel manipulation, data cleaning

```python
import pandas as pd
import numpy as np

# Create DataFrame
df = pd.DataFrame({
    'name': ['Alice', 'Bob', 'Charlie', 'David'],
    'age': [25, 30, 35, 28],
    'salary': [50000, 60000, 70000, 55000],
    'department': ['IT', 'HR', 'IT', 'HR']
})

# Read from files
df = pd.read_csv('data.csv')
df = pd.read_excel('data.xlsx')
df = pd.read_json('data.json')

# Basic operations
print(df.head())  # First 5 rows
print(df.tail())  # Last 5 rows
print(df.info())  # DataFrame info
print(df.describe())  # Statistical summary

# Filtering
filtered = df[df['age'] > 28]
filtered = df[(df['age'] > 25) & (df['salary'] < 60000)]

# Sorting
sorted_df = df.sort_values('salary', ascending=False)
sorted_df = df.sort_values(['department', 'age'])

# Grouping
grouped = df.groupby('department')['salary'].mean()
grouped = df.groupby('department').agg({
    'salary': ['mean', 'max', 'min'],
    'age': 'mean'
})

# Adding columns
df['bonus'] = df['salary'] * 0.1
df['total_comp'] = df['salary'] + df['bonus']

# Handling missing data
df.fillna(0, inplace=True)
df.dropna(inplace=True)

# Merging DataFrames
df1 = pd.DataFrame({'id': [1, 2], 'name': ['Alice', 'Bob']})
df2 = pd.DataFrame({'id': [1, 2], 'salary': [50000, 60000]})
merged = pd.merge(df1, df2, on='id')

# Export
df.to_csv('output.csv', index=False)
df.to_excel('output.xlsx', index=False)
df.to_json('output.json', orient='records')
```

**Installation:**
```bash
pip install pandas
pip install openpyxl  # For Excel support
```

---

### NumPy (Numerical Computing)

**Best for:** Scientific computing, linear algebra, array operations

```python
import numpy as np

# Array creation
arr = np.array([1, 2, 3, 4, 5])
matrix = np.array([[1, 2, 3], [4, 5, 6]])
zeros = np.zeros((3, 3))
ones = np.ones((2, 4))
identity = np.eye(3)
range_arr = np.arange(0, 10, 2)  # [0, 2, 4, 6, 8]
linspace = np.linspace(0, 1, 5)  # 5 evenly spaced values

# Array operations
print(arr * 2)  # Element-wise multiplication
print(arr + 10)  # Element-wise addition
print(arr ** 2)  # Element-wise power
print(np.sqrt(arr))  # Square root

# Statistical operations
print(np.mean(arr))
print(np.median(arr))
print(np.std(arr))
print(np.var(arr))
print(np.sum(arr))
print(np.min(arr), np.max(arr))

# Matrix operations
A = np.array([[1, 2], [3, 4]])
B = np.array([[5, 6], [7, 8]])
print(A @ B)  # Matrix multiplication
print(A.T)  # Transpose
print(np.linalg.inv(A))  # Inverse
print(np.linalg.det(A))  # Determinant

# Random numbers
random_arr = np.random.rand(3, 3)  # Uniform [0, 1)
normal = np.random.randn(1000)  # Normal distribution
integers = np.random.randint(0, 100, size=10)

# Reshaping
arr_2d = np.arange(12).reshape(3, 4)
flattened = arr_2d.flatten()

# Boolean indexing
arr = np.array([1, 2, 3, 4, 5])
print(arr[arr > 3])  # [4, 5]
```

**Installation:**
```bash
pip install numpy
```

---

### Matplotlib & Seaborn (Visualization)

**Best for:** Data visualization, charts, graphs, statistical plots

```python
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
import pandas as pd

# Matplotlib - Line plot
x = np.linspace(0, 10, 100)
y = np.sin(x)
plt.figure(figsize=(10, 6))
plt.plot(x, y, label='sin(x)', color='blue', linewidth=2)
plt.xlabel('X axis')
plt.ylabel('Y axis')
plt.title('Sine Wave')
plt.legend()
plt.grid(True)
plt.show()

# Bar chart
categories = ['A', 'B', 'C', 'D']
values = [23, 45, 56, 78]
plt.bar(categories, values, color='skyblue')
plt.title('Bar Chart')
plt.show()

# Scatter plot
x = np.random.rand(50)
y = np.random.rand(50)
colors = np.random.rand(50)
sizes = 1000 * np.random.rand(50)
plt.scatter(x, y, c=colors, s=sizes, alpha=0.5, cmap='viridis')
plt.colorbar()
plt.show()

# Subplots
fig, axes = plt.subplots(2, 2, figsize=(12, 10))
axes[0, 0].plot(x, y)
axes[0, 0].set_title('Plot 1')
axes[0, 1].scatter(x, y)
axes[0, 1].set_title('Plot 2')
axes[1, 0].bar(categories, values)
axes[1, 0].set_title('Plot 3')
axes[1, 1].hist(np.random.randn(1000), bins=30)
axes[1, 1].set_title('Plot 4')
plt.tight_layout()
plt.show()

# Seaborn - Better styling
sns.set_style("darkgrid")
sns.set_palette("husl")

# Load sample data
iris = sns.load_dataset("iris")

# Scatter plot with hue
sns.scatterplot(data=iris, x="sepal_length", y="sepal_width", hue="species")
plt.title('Iris Dataset')
plt.show()

# Pair plot
sns.pairplot(iris, hue="species")
plt.show()

# Heatmap
correlation = iris.corr()
sns.heatmap(correlation, annot=True, cmap='coolwarm')
plt.title('Correlation Heatmap')
plt.show()

# Box plot
sns.boxplot(data=iris, x="species", y="sepal_length")
plt.show()

# Violin plot
sns.violinplot(data=iris, x="species", y="sepal_width")
plt.show()
```

**Installation:**
```bash
pip install matplotlib
pip install seaborn
```

---

## Database & ORM

### SQLAlchemy (ORM)

**Best for:** Database ORM, SQL abstraction, complex queries

```python
from sqlalchemy import create_engine, Column, Integer, String, Float, ForeignKey, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship
from datetime import datetime

Base = declarative_base()

# Define models
class User(Base):
    __tablename__ = 'users'
    
    id = Column(Integer, primary_key=True)
    username = Column(String(50), unique=True, nullable=False)
    email = Column(String(100), unique=True, nullable=False)
    created_at = Column(DateTime, default=datetime.now)
    
    # Relationship
    posts = relationship("Post", back_populates="author", cascade="all, delete-orphan")
    
    def __repr__(self):
        return f"<User(username='{self.username}')>"

class Post(Base):
    __tablename__ = 'posts'
    
    id = Column(Integer, primary_key=True)
    title = Column(String(200), nullable=False)
    content = Column(String)
    user_id = Column(Integer, ForeignKey('users.id'))
    created_at = Column(DateTime, default=datetime.now)
    
    # Relationship
    author = relationship("User", back_populates="posts")
    
    def __repr__(self):
        return f"<Post(title='{self.title}')>"

# Create database
engine = create_engine('sqlite:///blog.db', echo=True)
Base.metadata.create_all(engine)

# Create session
Session = sessionmaker(bind=engine)
session = Session()

# CRUD operations

# Create
user = User(username='alice', email='alice@example.com')
session.add(user)
session.commit()

post = Post(title='My First Post', content='Hello World!', author=user)
session.add(post)
session.commit()

# Read
users = session.query(User).all()
user = session.query(User).filter_by(username='alice').first()
user = session.query(User).filter(User.username == 'alice').first()

# With relationships
user_with_posts = session.query(User).filter_by(username='alice').first()
for post in user_with_posts.posts:
    print(post.title)

# Update
user = session.query(User).filter_by(username='alice').first()
user.email = 'newemail@example.com'
session.commit()

# Delete
post = session.query(Post).filter_by(id=1).first()
session.delete(post)
session.commit()

# Complex queries
from sqlalchemy import and_, or_

# Multiple conditions
users = session.query(User).filter(
    and_(User.username.like('%alice%'), User.id > 1)
).all()

# Join
results = session.query(User, Post).join(Post).all()

# Order by
users = session.query(User).order_by(User.created_at.desc()).all()

# Limit
users = session.query(User).limit(10).all()

# Count
user_count = session.query(User).count()

session.close()
```

**Installation:**
```bash
pip install sqlalchemy
pip install psycopg2-binary  # For PostgreSQL
pip install pymysql  # For MySQL
```

---

## API & HTTP Requests

### Requests (HTTP Library)

**Best for:** API calls, web scraping, HTTP operations

```python
import requests
from requests.auth import HTTPBasicAuth

# GET request
response = requests.get('https://api.github.com/users/octocat')
print(response.status_code)  # 200
print(response.json())  # JSON response
print(response.text)  # Text response
print(response.headers)  # Headers

# POST request
data = {'name': 'Alice', 'email': 'alice@example.com'}
response = requests.post('https://api.example.com/users', json=data)

# PUT request
data = {'name': 'Alice Updated'}
response = requests.put('https://api.example.com/users/1', json=data)

# DELETE request
response = requests.delete('https://api.example.com/users/1')

# Headers
headers = {
    'Authorization': 'Bearer token123',
    'Content-Type': 'application/json'
}
response = requests.get('https://api.example.com/data', headers=headers)

# Query parameters
params = {'page': 1, 'limit': 10, 'sort': 'created_at'}
response = requests.get('https://api.example.com/items', params=params)
# URL: https://api.example.com/items?page=1&limit=10&sort=created_at

# Authentication
response = requests.get(
    'https://api.example.com/protected',
    auth=HTTPBasicAuth('username', 'password')
)

# Timeout
response = requests.get('https://api.example.com/data', timeout=5)

# Session (persist cookies)
session = requests.Session()
session.headers.update({'Authorization': 'Bearer token'})
response = session.get('https://api.example.com/endpoint1')
response = session.get('https://api.example.com/endpoint2')

# Error handling
try:
    response = requests.get('https://api.example.com/data', timeout=5)
    response.raise_for_status()  # Raises HTTPError for bad responses
except requests.exceptions.Timeout:
    print("Request timed out")
except requests.exceptions.HTTPError as e:
    print(f"HTTP Error: {e}")
except requests.exceptions.RequestException as e:
    print(f"Error: {e}")

# Download file
response = requests.get('https://example.com/file.pdf')
with open('downloaded_file.pdf', 'wb') as f:
    f.write(response.content)

# Stream large files
with requests.get('https://example.com/large_file.zip', stream=True) as r:
    with open('large_file.zip', 'wb') as f:
        for chunk in r.iter_content(chunk_size=8192):
            f.write(chunk)
```

**Installation:**
```bash
pip install requests
```

---

## Testing

### Pytest (Testing Framework)

**Best for:** Unit testing, integration testing, fixtures

```python
# test_calculator.py
import pytest

# Simple function to test
def add(a, b):
    return a + b

def divide(a, b):
    if b == 0:
        raise ValueError("Cannot divide by zero")
    return a / b

# Basic tests
def test_add():
    assert add(2, 3) == 5
    assert add(-1, 1) == 0
    assert add(0, 0) == 0

def test_divide():
    assert divide(10, 2) == 5
    assert divide(9, 3) == 3

# Test exceptions
def test_divide_by_zero():
    with pytest.raises(ValueError):
        divide(10, 0)

# Parametrized tests
@pytest.mark.parametrize("a,b,expected", [
    (2, 3, 5),
    (5, 5, 10),
    (-1, 1, 0),
    (100, 200, 300)
])
def test_add_parametrized(a, b, expected):
    assert add(a, b) == expected

# Fixtures
@pytest.fixture
def user_data():
    return {'name': 'Alice', 'age': 30, 'email': 'alice@example.com'}

@pytest.fixture
def database_connection():
    # Setup
    connection = "database_connected"
    yield connection
    # Teardown
    print("Closing connection")

def test_user(user_data):
    assert user_data['name'] == 'Alice'
    assert user_data['age'] == 30

def test_database(database_connection):
    assert database_connection == "database_connected"

# Marking tests
@pytest.mark.slow
def test_slow_operation():
    import time
    time.sleep(2)
    assert True

@pytest.mark.skip(reason="Not implemented yet")
def test_future_feature():
    pass

# Test class
class TestCalculator:
    def test_add(self):
        assert add(2, 2) == 4
    
    def test_subtract(self):
        assert add(5, -3) == 2
```

**Run tests:**
```bash
# Run all tests
pytest

# Run specific file
pytest test_calculator.py

# Run specific test
pytest test_calculator.py::test_add

# Run with verbose output
pytest -v

# Run tests matching pattern
pytest -k "add"

# Run tests with markers
pytest -m slow

# Run with coverage
pytest --cov=.
```

**Installation:**
```bash
pip install pytest
pip install pytest-cov  # For coverage
```

---

## Async & Task Queues

### Celery (Distributed Task Queue)

**Best for:** Background tasks, scheduled jobs, distributed processing

```python
# tasks.py
from celery import Celery
import time

# Create Celery app
app = Celery(
    'tasks',
    broker='redis://localhost:6379/0',
    backend='redis://localhost:6379/0'
)

# Configure Celery
app.conf.update(
    task_serializer='json',
    accept_content=['json'],
    result_serializer='json',
    timezone='UTC',
    enable_utc=True,
)

# Simple task
@app.task
def add(x, y):
    return x + y

# Long-running task
@app.task
def send_email(email, message):
    time.sleep(5)  # Simulate email sending
    return f"Email sent to {email}"

# Task with retry
@app.task(bind=True, max_retries=3)
def process_data(self, data):
    try:
        # Process data
        result = sum(data)
        return result
    except Exception as exc:
        raise self.retry(exc=exc, countdown=60)

# Scheduled task
from celery.schedules import crontab

app.conf.beat_schedule = {
    'cleanup-every-day': {
        'task': 'tasks.cleanup',
        'schedule': crontab(hour=0, minute=0),
    },
    'send-report-every-monday': {
        'task': 'tasks.send_weekly_report',
        'schedule': crontab(day_of_week=1, hour=9, minute=0),
    },
}

@app.task
def cleanup():
    print("Running cleanup task")

@app.task
def send_weekly_report():
    print("Sending weekly report")

# Usage in your app
from tasks import add, send_email, process_data

# Async execution
result = add.delay(4, 6)
print(result.ready())  # False
print(result.get(timeout=10))  # 10

# Check result
email_result = send_email.delay('user@example.com', 'Hello!')
print(email_result.id)  # Task ID
print(email_result.status)  # PENDING, STARTED, SUCCESS, FAILURE

# Wait for result
result = add.delay(2, 3)
output = result.get()  # Blocks until task completes
```

**Run Celery worker:**
```bash
# Start worker
celery -A tasks worker --loglevel=info

# Start beat scheduler
celery -A tasks beat --loglevel=info

# Start both
celery -A tasks worker --beat --loglevel=info
```

**Installation:**
```bash
pip install celery
pip install redis  # For Redis broker
```

---

## Utility Libraries

### Python-dotenv (Environment Variables)

```python
from dotenv import load_dotenv
import os

# Load .env file
load_dotenv()

# Or specify file
load_dotenv('.env.production')

# Access variables
database_url = os.getenv('DATABASE_URL')
api_key = os.getenv('API_KEY')
debug_mode = os.getenv('DEBUG', 'False') == 'True'

# .env file example:
# DATABASE_URL=postgresql://user:pass@localhost/dbname
# API_KEY=your_secret_key
# DEBUG=True
```

### Pydantic (Data Validation)

```python
from pydantic import BaseModel, EmailStr, validator, Field
from typing import Optional, List

class Address(BaseModel):
    street: str
    city: str
    zipcode: str = Field(..., regex=r'^\d{5}$')

class User(BaseModel):
    id: int
    name: str = Field(..., min_length=1, max_length=100)
    email: EmailStr
    age: Optional[int] = Field(None, ge=0, le=150)
    addresses: List[Address] = []
    
    @validator('age')
    def age_must_be_positive(cls, v):
        if v is not None and v < 0:
            raise ValueError('Age must be positive')
        return v
    
    class Config:
        schema_extra = {
            "example": {
                "id": 1,
                "name": "Alice",
                "email": "alice@example.com",
                "age": 30
            }
        }

# Usage
user = User(
    id=1,
    name='Alice',
    email='alice@example.com',
    age=30
)
print(user.dict())
print(user.json())
```

### Click (CLI Framework)

```python
import click

@click.group()
def cli():
    """My CLI Application"""
    pass

@cli.command()
@click.option('--name', default='World', help='Name to greet')
@click.option('--count', default=1, help='Number of greetings')
def greet(name, count):
    """Greet someone COUNT times."""
    for _ in range(count):
        click.echo(f'Hello, {name}!')

@cli.command()
@click.argument('filename', type=click.Path(exists=True))
@click.option('--format', type=click.Choice(['json', 'xml', 'csv']))
def process(filename, format):
    """Process a file."""
    click.echo(f'Processing {filename} as {format}')

if __name__ == '__main__':
    cli()
```

**Installation:**
```bash
pip install python-dotenv
pip install "pydantic[email]"
pip install click
```

---

## Quick Reference Table

| Category | Package | Install | Best For |
|----------|---------|---------|----------|
| **Web** | Flask | `pip install flask` | Simple APIs, microservices |
| | Django | `pip install django` | Full web apps, admin panels |
| | FastAPI | `pip install fastapi uvicorn` | Modern APIs, async operations |
| **Data** | Pandas | `pip install pandas` | Data analysis, CSV/Excel |
| | NumPy | `pip install numpy` | Numerical computing |
| | Matplotlib | `pip install matplotlib` | Plotting, visualization |
| | Seaborn | `pip install seaborn` | Statistical visualization |
| **Database** | SQLAlchemy | `pip install sqlalchemy` | ORM, database abstraction |
| | Psycopg2 | `pip install psycopg2-binary` | PostgreSQL connection |
| | PyMongo | `pip install pymongo` | MongoDB integration |
| **API** | Requests | `pip install requests` | HTTP requests, API calls |
| | httpx | `pip install httpx` | Async HTTP client |
| **Testing** | Pytest | `pip install pytest` | Unit/integration testing |
| | unittest | (built-in) | Basic testing |
| **Async** | Celery | `pip install celery redis` | Background tasks |
| | asyncio | (built-in) | Async programming |
| **Utils** | python-dotenv | `pip install python-dotenv` | Environment variables |
| | Pydantic | `pip install pydantic` | Data validation |
| | Click | `pip install click` | CLI applications |
| **ML** | scikit-learn | `pip install scikit-learn` | ML algorithms |
| | TensorFlow | `pip install tensorflow` | Deep learning |
| | PyTorch | `pip install torch` | Neural networks |

---

## Common Project Setup

### Web API Project

```bash
# requirements.txt
fastapi==0.104.1
uvicorn[standard]==0.24.0
sqlalchemy==2.0.23
psycopg2-binary==2.9.9
python-dotenv==1.0.0
pydantic==2.5.0
requests==2.31.0
pytest==7.4.3
black==23.12.0
flake8==6.1.0
```

### Data Science Project

```bash
# requirements.txt
pandas==2.1.3
numpy==1.26.2
matplotlib==3.8.2
seaborn==0.13.0
scikit-learn==1.3.2
jupyter==1.0.0
```

### Install & Run

```bash
# Install dependencies
pip install -r requirements.txt

# Format code
black .

# Lint code
flake8 .

# Run tests
pytest --cov=.
```

---

**Navigation:**
- [← Previous: File Organization](#/py-file-organization)
- [→ Next: Logging](#/py-logging)
- [↑ Back to Python Basics](#/py-basics)
- [🏠 Home](#/home)
