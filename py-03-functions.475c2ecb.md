# Python Functions & Methods

## Function Basics

### Defining Functions

```python
# Basic function
def greet():
    print("Hello, World!")

# Call it
greet()

# Function with parameters
def greet_person(name):
    print(f"Hello, {name}!")

greet_person("Alice")

# Function with return value
def add(a, b):
    return a + b

result = add(5, 3)  # 8

# Multiple return values (returns tuple)
def get_user():
    return "Alice", 30, "alice@example.com"

name, age, email = get_user()
```

### Function Arguments

```python
# Positional arguments
def power(base, exponent):
    return base ** exponent

power(2, 3)  # 8

# Default arguments
def greet(name, greeting="Hello"):
    return f"{greeting}, {name}!"

greet("Alice")              # "Hello, Alice!"
greet("Bob", "Hi")          # "Hi, Bob!"

# Keyword arguments
def create_user(name, age, email):
    return {'name': name, 'age': age, 'email': email}

# Call with keywords (order doesn't matter)
create_user(email="alice@example.com", name="Alice", age=30)

# *args - Variable positional arguments
def sum_all(*numbers):
    total = 0
    for num in numbers:
        total += num
    return total

sum_all(1, 2, 3, 4, 5)  # 15

# **kwargs - Variable keyword arguments
def print_info(**info):
    for key, value in info.items():
        print(f"{key}: {value}")

print_info(name="Alice", age=30, city="NYC")

# Combining all types
def complex_func(pos1, pos2, *args, default="value", **kwargs):
    print(f"Positional: {pos1}, {pos2}")
    print(f"Args: {args}")
    print(f"Default: {default}")
    print(f"Kwargs: {kwargs}")

complex_func(1, 2, 3, 4, 5, default="custom", key1="a", key2="b")
```

### Type Hints (Python 3.5+)

```python
# Basic type hints
def add(a: int, b: int) -> int:
    return a + b

def greet(name: str) -> str:
    return f"Hello, {name}!"

# Optional types
from typing import Optional

def find_user(user_id: int) -> Optional[str]:
    if user_id == 1:
        return "Alice"
    return None  # Optional allows None

# Complex types
from typing import List, Dict, Tuple, Set

def process_users(users: List[str]) -> Dict[str, int]:
    return {user: len(user) for user in users}

def get_coordinates() -> Tuple[float, float]:
    return (40.7128, -74.0060)

# Union types
from typing import Union

def parse_value(value: Union[int, str]) -> int:
    if isinstance(value, str):
        return int(value)
    return value
```

### Lambda Functions (Anonymous Functions)

```python
# Basic lambda
square = lambda x: x ** 2
square(5)  # 25

# Lambda with multiple arguments
add = lambda a, b: a + b
add(3, 5)  # 8

# Common use: with map, filter, sorted
numbers = [1, 2, 3, 4, 5]

# map - apply function to all items
squared = list(map(lambda x: x**2, numbers))
# [1, 4, 9, 16, 25]

# filter - keep items that match condition
evens = list(filter(lambda x: x % 2 == 0, numbers))
# [2, 4]

# sorted with custom key
users = [{'name': 'Bob', 'age': 25}, {'name': 'Alice', 'age': 30}]
sorted_users = sorted(users, key=lambda u: u['age'])
```

## Methods vs Functions

### What's the Difference?

```python
# FUNCTION - standalone, not attached to object
def greet(name):
    return f"Hello, {name}"

greet("Alice")

# METHOD - function attached to a class/object
class Person:
    def greet(self):
        return "Hello from Person"

person = Person()
person.greet()  # Method call

# Built-in methods
text = "hello"
text.upper()      # Method on string object
text.replace('h', 'H')

numbers = [1, 2, 3]
numbers.append(4)  # Method on list object
```

## Decorators

Decorators modify or enhance functions without changing their code.

### Built-in Decorators

```python
class MyClass:
    # @property - access method like an attribute
    @property
    def full_name(self):
        return f"{self.first_name} {self.last_name}"
    
    # @staticmethod - doesn't need self or cls
    @staticmethod
    def is_adult(age):
        return age >= 18
    
    # @classmethod - receives class as first argument
    @classmethod
    def from_string(cls, string):
        first, last = string.split()
        return cls(first, last)

# Usage
person = MyClass()
print(person.full_name)  # No () needed!
MyClass.is_adult(25)     # Call without instance
```

### Custom Decorators

```python
# Simple decorator
def log_calls(func):
    def wrapper(*args, **kwargs):
        print(f"Calling {func.__name__}")
        result = func(*args, **kwargs)
        print(f"Finished {func.__name__}")
        return result
    return wrapper

@log_calls
def add(a, b):
    return a + b

add(5, 3)
# Output:
# Calling add
# Finished add

# Decorator with arguments
def repeat(times):
    def decorator(func):
        def wrapper(*args, **kwargs):
            for _ in range(times):
                result = func(*args, **kwargs)
            return result
        return wrapper
    return decorator

@repeat(times=3)
def greet(name):
    print(f"Hello, {name}!")

greet("Alice")
# Prints "Hello, Alice!" three times
```

## Common Patterns

### Error Handling in Functions

```python
def divide(a, b):
    try:
        return a / b
    except ZeroDivisionError:
        return None
    except TypeError:
        return "Invalid types"
    finally:
        print("Division attempted")

# With custom errors
def validate_age(age):
    if age < 0:
        raise ValueError("Age cannot be negative")
    if age > 150:
        raise ValueError("Age too high")
    return True
```

### Generator Functions

```python
# Yields values one at a time (memory efficient)
def fibonacci(n):
    a, b = 0, 1
    for _ in range(n):
        yield a
        a, b = b, a + b

# Use generator
for num in fibonacci(10):
    print(num)

# Generator expression (like list comprehension)
squares = (x**2 for x in range(1000000))  # Doesn't create list!
```

### Recursion

```python
def factorial(n):
    if n == 0 or n == 1:
        return 1
    return n * factorial(n - 1)

factorial(5)  # 120

# With memoization (caching)
from functools import lru_cache

@lru_cache(maxsize=None)
def fibonacci(n):
    if n < 2:
        return n
    return fibonacci(n-1) + fibonacci(n-2)
```

### Partial Functions

```python
from functools import partial

def power(base, exponent):
    return base ** exponent

# Create specialized version
square = partial(power, exponent=2)
cube = partial(power, exponent=3)

square(5)  # 25
cube(5)    # 125
```

## Best Practices

```python
# ✅ DO: Use descriptive names
def calculate_total_price(items, tax_rate):
    subtotal = sum(item['price'] for item in items)
    return subtotal * (1 + tax_rate)

# ❌ DON'T: Use unclear names
def calc(i, t):
    return sum(x['p'] for x in i) * (1 + t)

# ✅ DO: Keep functions small and focused
def validate_email(email):
    return '@' in email and '.' in email

def send_email(to, subject, body):
    if not validate_email(to):
        raise ValueError("Invalid email")
    # Send email logic...

# ❌ DON'T: Make functions do too much
def process_user(email, data, db):
    # Validates, saves to DB, sends email, logs...
    pass  # Too many responsibilities!

# ✅ DO: Use type hints
def calculate_discount(price: float, discount: float) -> float:
    return price * (1 - discount)

# ✅ DO: Document with docstrings
def calculate_tax(amount: float, rate: float) -> float:
    """
    Calculate tax on a given amount.
    
    Args:
        amount: The base amount
        rate: Tax rate as decimal (0.08 for 8%)
    
    Returns:
        The tax amount
    
    Example:
        >>> calculate_tax(100, 0.08)
        8.0
    """
    return amount * rate
```

---

**Navigation:**
- [← Previous: Data Structures](#/py-data-structures)
- [→ Next: Classes & OOP](#/py-classes)
- [↑ Back to Python Basics](#/py-basics)
- [🏠 Home](#/home)
