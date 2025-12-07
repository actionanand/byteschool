# Python Basics & Setup

## Python 2 vs Python 3

### Major Differences

Python underwent a significant transformation from version 2.x to 3.x. **Python 2 reached end-of-life on January 1, 2020** and is no longer supported.

#### Key Differences:

| Feature | Python 2.x | Python 3.x |
|---------|------------|------------|
| **Print Statement** | `print "Hello"` | `print("Hello")` |
| **Division** | `5 / 2 = 2` (integer) | `5 / 2 = 2.5` (float) |
| **Unicode** | ASCII by default | Unicode (UTF-8) by default |
| **Range** | `range()` returns list | `range()` returns iterator |
| **Input** | `raw_input()` for strings | `input()` for all types |
| **Exception Syntax** | `except Exception, e:` | `except Exception as e:` |
| **Iterators** | `.next()` method | `next()` function |
| **Integer Division** | `/` operator | `//` operator for floor division |

```python
# Python 2.x (DON'T USE - DEPRECATED!)
print "Hello, World!"           # No parentheses
print 5 / 2                      # Returns 2
name = raw_input("Name: ")       # For string input
except ValueError, e:            # Old exception syntax

# Python 3.x (CURRENT - USE THIS!)
print("Hello, World!")           # Function call
print(5 / 2)                     # Returns 2.5
print(5 // 2)                    # Returns 2 (floor division)
name = input("Name: ")           # Universal input function
except ValueError as e:          # Modern exception syntax
```

### Why Python 3?

- **Better Unicode support**: Handle international characters easily
- **Cleaner syntax**: More consistent and readable
- **Modern features**: Async/await, type hints, f-strings
- **Active development**: All new features only in Python 3
- **Security**: Python 2 no longer receives security updates

## Installation & Setup

### Option 1: Miniconda (Recommended)

**Miniconda** is a minimal installer for Conda, a package and environment manager.

#### Why Miniconda?

- ✅ Lightweight (vs full Anaconda)
- ✅ Manages Python versions easily
- ✅ Isolated environments for projects
- ✅ Cross-platform (Windows, macOS, Linux)
- ✅ Includes conda package manager

#### Installing Miniconda:

```bash
# Download and install from: https://docs.conda.io/en/latest/miniconda.html

# After installation, verify:
conda --version

# Create a new environment with Python 3.11
conda create -n myproject python=3.11

# Activate the environment
conda activate myproject

# Deactivate when done
conda deactivate

# List all environments
conda env list

# Remove an environment
conda env remove -n myproject
```

### Option 2: Official Python Installer

```bash
# Download from python.org
# Windows: Download .exe installer
# macOS: Download .pkg installer
# Linux: Use package manager

# Ubuntu/Debian
sudo apt update
sudo apt install python3 python3-pip

# macOS (with Homebrew)
brew install python3

# Verify installation
python3 --version
pip3 --version
```

### Option 3: pyenv (Version Manager)

```bash
# Install pyenv (Unix-like systems)
curl https://pyenv.run | bash

# Install specific Python version
pyenv install 3.11.5

# Set global Python version
pyenv global 3.11.5

# Set local version for a project
pyenv local 3.11.5
```

## pip - Python Package Manager

**pip** is the standard package installer for Python.

### Basic pip Commands:

```bash
# Install a package
pip install requests

# Install specific version
pip install requests==2.28.0

# Install from requirements.txt
pip install -r requirements.txt

# Upgrade a package
pip install --upgrade requests

# Uninstall a package
pip uninstall requests

# List installed packages
pip list

# Show package info
pip show requests

# Search for packages
pip search flask

# Freeze installed packages (for requirements.txt)
pip freeze > requirements.txt

# Install in development/editable mode
pip install -e .
```

### Virtual Environments (venv):

```bash
# Create virtual environment
python3 -m venv venv

# Activate (Unix/macOS)
source venv/bin/activate

# Activate (Windows)
venv\Scripts\activate

# Deactivate
deactivate

# Install packages in venv
pip install django flask

# Export dependencies
pip freeze > requirements.txt
```

### requirements.txt Example:

```txt
django==4.2.0
requests==2.31.0
pandas>=1.5.0,<2.0.0
numpy~=1.24.0
flask
```

## Basic Python Concepts

### Variables & Types

```python
# Python is dynamically typed
x = 10              # int
y = 3.14            # float
name = "Alice"      # str
is_active = True    # bool
items = [1, 2, 3]   # list
data = None         # NoneType

# Type hints (Python 3.5+)
age: int = 30
price: float = 19.99
username: str = "john"
is_valid: bool = True

# Multiple assignment
a, b, c = 1, 2, 3
x = y = z = 0

# Type checking
print(type(x))           # <class 'int'>
print(isinstance(x, int)) # True
```

### Operators

```python
# Arithmetic
a + b    # Addition
a - b    # Subtraction
a * b    # Multiplication
a / b    # Division (float)
a // b   # Floor division
a % b    # Modulo
a ** b   # Exponentiation

# Comparison
a == b   # Equal
a != b   # Not equal
a > b    # Greater than
a < b    # Less than
a >= b   # Greater or equal
a <= b   # Less or equal

# Logical
a and b  # Logical AND
a or b   # Logical OR
not a    # Logical NOT

# Identity
a is b       # Same object
a is not b   # Different object

# Membership
x in list    # Is x in list?
x not in list
```

### String Operations & Printing

```python
# String creation
text = "Hello, World!"
multiline = """This is
a multiline
string"""

# f-strings (Python 3.6+) - BEST WAY!
name = "Alice"
age = 30
message = f"My name is {name} and I'm {age} years old"
result = f"2 + 2 = {2 + 2}"

# Advanced f-string formatting
price = 19.99
print(f"Price: ${price:.2f}")  # 2 decimal places
number = 42
print(f"Binary: {number:b}, Hex: {number:x}")  # Number bases
text = "python"
print(f"Uppercase: {text.upper()}")  # Call methods in f-string

# .format() method (Python 2.7+)
message = "My name is {} and I'm {} years old".format(name, age)
message = "My name is {0} and I'm {1} years old".format(name, age)
message = "My name is {name} and I'm {age} years old".format(name=name, age=age)

# % formatting (old style - avoid in new code)
message = "Hello, %s. You are %d years old" % (name, age)

# Print function
print("Hello, World!")
print("Multiple", "arguments", "separated", "by", "spaces")
print("No newline", end="")
print("Custom separator", 1, 2, 3, sep=" | ")  # 1 | 2 | 3

# Pretty printing (pprint) - for complex data structures
import pprint

# Regular print - hard to read
data = {'users': [{'name': 'Alice', 'age': 30, 'skills': ['Python', 'JavaScript']}, {'name': 'Bob', 'age': 25, 'skills': ['Java', 'C++']}]}
print(data)  # All on one line, hard to read

# pprint - formatted and readable
pprint.pprint(data)
# Output:
# {'users': [{'age': 30,
#             'name': 'Alice',
#             'skills': ['Python', 'JavaScript']},
#            {'age': 25,
#             'name': 'Bob',
#             'skills': ['Java', 'C++']}]}

# pprint options
pprint.pprint(data, width=40)  # Wrap at 40 chars
pprint.pprint(data, depth=2)   # Limit nesting depth
pprint.pprint(data, compact=True)  # More compact output

# pformat - return formatted string instead of printing
formatted = pprint.pformat(data, indent=4)
print(formatted)

# String methods
text.lower()          # lowercase
text.upper()          # UPPERCASE
text.strip()          # Remove whitespace
text.split(',')       # Split into list
text.replace('a', 'b') # Replace chars
text.startswith('H')  # Check prefix
text.endswith('!')    # Check suffix
len(text)             # Length
```

### Control Flow

```python
# If-elif-else
if age < 13:
    print("Child")
elif age < 18:
    print("Teen")
else:
    print("Adult")

# Ternary operator
status = "Minor" if age < 18 else "Adult"

# For loop
for i in range(5):
    print(i)  # 0, 1, 2, 3, 4

for item in items:
    print(item)

for index, value in enumerate(items):
    print(f"{index}: {value}")

# While loop
count = 0
while count < 5:
    print(count)
    count += 1

# Break and continue
for i in range(10):
    if i == 3:
        continue  # Skip 3
    if i == 7:
        break     # Stop at 7
    print(i)
```

## Python 3.5+ Special Features

### Type Hints (Python 3.5+)

```python
from typing import List, Dict, Tuple, Optional, Union

# Basic type hints
def greet(name: str) -> str:
    return f"Hello, {name}!"

def add(a: int, b: int) -> int:
    return a + b

# Variable type hints
age: int = 30
names: List[str] = ["Alice", "Bob"]
user: Dict[str, any] = {"name": "Alice", "age": 30}

# Optional types (can be None)
def find_user(user_id: int) -> Optional[str]:
    if user_id == 1:
        return "Alice"
    return None

# Union types (multiple possible types)
def process_value(value: Union[int, str]) -> str:
    return str(value)

# Type aliases
UserId = int
Username = str

def get_user(user_id: UserId) -> Username:
    return "Alice"
```

### Async/Await (Python 3.5+)

```python
import asyncio

# Define async function
async def fetch_data(url: str) -> dict:
    # Simulate async operation
    await asyncio.sleep(1)
    return {"data": "fetched"}

async def main():
    # Await async function
    result = await fetch_data("https://api.example.com")
    print(result)
    
    # Run multiple tasks concurrently
    tasks = [
        fetch_data("url1"),
        fetch_data("url2"),
        fetch_data("url3")
    ]
    results = await asyncio.gather(*tasks)

# Run async function
asyncio.run(main())
```

### Matrix Multiplication Operator @ (Python 3.5+)

```python
import numpy as np

# Before: numpy.dot()
A = np.array([[1, 2], [3, 4]])
B = np.array([[5, 6], [7, 8]])
result = np.dot(A, B)

# Python 3.5+: @ operator
result = A @ B

# More readable for matrix operations
C = A @ B @ A.T  # Much cleaner than np.dot(np.dot(A, B), A.T)
```

### Unpacking Generalizations (Python 3.5+)

```python
# Extended unpacking in function calls
def func(a, b, c, d, e):
    print(a, b, c, d, e)

first = [1, 2]
second = [3, 4]
func(*first, *second, 5)  # 1 2 3 4 5

# Multiple unpacking in literals
list1 = [1, 2, 3]
list2 = [4, 5, 6]
combined = [*list1, *list2, 7, 8]  # [1, 2, 3, 4, 5, 6, 7, 8]

# Dictionary unpacking with **
dict1 = {"a": 1, "b": 2}
dict2 = {"c": 3, "d": 4}
combined = {**dict1, **dict2, "e": 5}  # Merge dicts
```

### F-strings with = for debugging (Python 3.8+)

```python
# Quick debug printing
x = 10
y = 20
print(f"{x=}, {y=}")  # x=10, y=20

# With expressions
print(f"{x + y=}")  # x + y=30
print(f"{len('hello')=}")  # len('hello')=5
```

### Walrus Operator := (Python 3.8+)

```python
# Assign and use in one expression
# Before:
data = input("Enter name: ")
if len(data) > 0:
    print(f"Hello, {data}")

# With walrus operator:
if (data := input("Enter name: ")):
    print(f"Hello, {data}")

# In list comprehensions
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
if (squared := [x**2 for x in numbers if x % 2 == 0]):
    print(f"Even squares: {squared}")

# In while loops
while (line := input(">> ")) != "quit":
    print(f"You said: {line}")
```

### Match Statement (Python 3.10+)

```python
# Pattern matching (like switch/case)
def http_status(status):
    match status:
        case 200:
            return "OK"
        case 404:
            return "Not Found"
        case 500 | 502 | 503:
            return "Server Error"
        case _:
            return "Unknown"

# Match with patterns
def process_command(command):
    match command.split():
        case ["quit"]:
            return "Quitting..."
        case ["load", filename]:
            return f"Loading {filename}"
        case ["save", filename]:
            return f"Saving {filename}"
        case ["delete", *files]:
            return f"Deleting {len(files)} files"
        case _:
            return "Unknown command"

# Match with guards
def categorize_number(x):
    match x:
        case n if n < 0:
            return "Negative"
        case 0:
            return "Zero"
        case n if n < 10:
            return "Small positive"
        case _:
            return "Large positive"
```

### Union Types with | (Python 3.10+)

```python
# Old way
from typing import Union
def process(value: Union[int, str]) -> Union[int, None]:
    return None

# Python 3.10+ - cleaner syntax
def process(value: int | str) -> int | None:
    return None

# Optional becomes clearer
def find_user(user_id: int) -> str | None:
    return None  # Instead of Optional[str]
```

---

**Navigation:**
- [→ Next: Data Structures](/?page=python/py-02-data-structures)
- [🏠 Home](/?page=home)
