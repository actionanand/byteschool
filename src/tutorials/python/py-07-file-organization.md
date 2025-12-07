# Python File Organization & Project Structure

## Modules and Packages

### What is a Module?

A module is a single `.py` file containing Python code.

```python
# math_utils.py
def add(a, b):
    return a + b

def multiply(a, b):
    return a * b

PI = 3.14159
```

### Importing Modules - Normal File Import Methods

#### Method 1: Import Entire Module

```python
# Import the whole module
import math_utils

# Access items with module prefix
result = math_utils.add(5, 3)
print(math_utils.PI)

# ✅ Pros: Clear where functions come from, no naming conflicts
# ❌ Cons: Verbose, need to type module name every time
```

#### Method 2: Import Specific Items

```python
# Import only what you need
from math_utils import add, PI

# Use directly without module prefix
result = add(5, 3)
print(PI)

# ✅ Pros: Cleaner code, less typing
# ❌ Cons: Less clear where functions come from
```

#### Method 3: Import with Alias

```python
# Give module a shorter name
import math_utils as mu

# Use alias instead of full name
result = mu.add(5, 3)

# Common aliases in Python community:
import numpy as np          # Standard
import pandas as pd         # Standard
import matplotlib.pyplot as plt  # Standard
import tensorflow as tf     # Standard

# ✅ Pros: Shorter names, clear namespace
# ❌ Cons: Need to remember aliases
```

#### Method 4: Import Specific Item with Alias

```python
# Rename imported item
from math_utils import add as addition

result = addition(5, 3)

# Useful when you have naming conflicts:
from datetime import datetime as dt
from my_module import datetime as my_datetime  # Different datetime

# ✅ Pros: Avoid naming conflicts
# ❌ Cons: Can be confusing if overused
```

#### Method 5: Import All (Not Recommended!)

```python
# Import everything from module
from math_utils import *

# Use items directly
result = add(5, 3)
print(PI)

# ❌ Problems:
# - Pollutes namespace
# - Unclear where functions come from
# - Can overwrite existing variables
# - Makes code hard to debug

# ⚠️ Only use in interactive Python shell, never in production code!
```

#### Import Location Matters

```python
# Standard import order (PEP 8):

# 1. Standard library imports
import os
import sys
from datetime import datetime

# 2. Third-party library imports
import numpy as np
import pandas as pd
from flask import Flask

# 3. Local application imports
from myapp.models import User
from myapp.utils import helpers
```

### What is a Package?

A package is a **directory containing modules** and a special `__init__.py` file.

```
mypackage/
├── __init__.py
├── module1.py
├── module2.py
└── subpackage/
    ├── __init__.py
    └── module3.py
```

## Project Structure Examples

### Small Script Project

```
my_script/
├── script.py           # Main script
├── utils.py           # Helper functions
└── config.py          # Configuration
```

```python
# utils.py
def format_name(name):
    return name.title()

# config.py
DATABASE_URL = "sqlite:///data.db"

# script.py
from utils import format_name
from config import DATABASE_URL

print(format_name("alice"))
```

### Medium Application

```
myapp/
├── myapp/                  # Main package
│   ├── __init__.py
│   ├── main.py            # Entry point
│   ├── models.py          # Data models
│   ├── database.py        # Database logic
│   └── utils.py           # Utilities
├── tests/                 # Tests
│   ├── __init__.py
│   └── test_models.py
├── requirements.txt       # Dependencies
├── README.md
└── setup.py              # Installation script
```

### Large Application

```
myapp/
├── myapp/
│   ├── __init__.py
│   ├── api/              # API layer
│   │   ├── __init__.py
│   │   ├── routes.py
│   │   └── validators.py
│   ├── models/           # Data models
│   │   ├── __init__.py
│   │   ├── user.py
│   │   └── post.py
│   ├── services/         # Business logic
│   │   ├── __init__.py
│   │   ├── auth.py
│   │   └── email.py
│   ├── database/         # Database layer
│   │   ├── __init__.py
│   │   ├── connection.py
│   │   └── repositories.py
│   └── utils/            # Utilities
│       ├── __init__.py
│       └── helpers.py
├── tests/
│   ├── unit/
│   └── integration/
├── config/
│   ├── development.py
│   └── production.py
├── requirements.txt
└── README.md
```

## `__init__.py` File

The `__init__.py` file makes a directory a package.

### Empty `__init__.py`

```python
# mypackage/__init__.py
# Empty file - just marks directory as package
```

### Initializing Package

```python
# mypackage/__init__.py
print("Initializing mypackage...")

# Package-level variables
__version__ = '1.0.0'
__author__ = 'Alice'

# Initialize something when package is imported
_initialized = False

def initialize():
    global _initialized
    if not _initialized:
        print("Setting up package...")
        _initialized = True
```

### Exposing Package API

```python
# mypackage/__init__.py
from .module1 import function1, ClassA
from .module2 import function2, ClassB

# Now users can import directly from package
# from mypackage import function1, ClassA
# Instead of: from mypackage.module1 import function1
```

### Controlling `import *`

```python
# mypackage/__init__.py
from .module1 import function1
from .module2 import function2

# Only these are imported with "from mypackage import *"
__all__ = ['function1', 'function2']
```

## Relative vs Absolute Imports

### Understanding the Dot (`.`) in Imports

The **dot (`.`)** in Python imports refers to **relative paths** within your package structure.

#### What Does the Dot Mean?

```python
# Single dot (.)
from . import module        # Current directory/package
from .module import func    # From module in current directory

# Double dot (..)
from .. import module       # Parent directory/package
from ..module import func   # From module in parent directory

# Triple dot (...)
from ... import module      # Grandparent directory/package
```

#### Visual Example: The Dot Explained

```
myapp/
├── __init__.py
├── main.py
├── models/
│   ├── __init__.py
│   ├── user.py          ← You are here
│   └── post.py
├── services/
│   ├── __init__.py
│   └── auth.py
└── utils/
    ├── __init__.py
    └── helpers.py
```

```python
# Inside myapp/models/user.py

# from . import post
# ↑ The dot means: "current directory" (models/)
# Result: Import models/post.py

# from .. import main
# ↑ Two dots mean: "parent directory" (myapp/)
# Result: Import myapp/main.py

# from ..services import auth
# ↑ Two dots go to parent (myapp/), then into services/
# Result: Import myapp/services/auth.py

# from ..utils.helpers import format_name
# ↑ Two dots to parent, then utils/, then helpers.py
# Result: Import function from myapp/utils/helpers.py
```

### Absolute Imports

Import using **full module path** from project root.

```
myapp/
├── myapp/
│   ├── __init__.py
│   ├── models/
│   │   ├── __init__.py
│   │   └── user.py
│   └── services/
│       ├── __init__.py
│       └── auth.py
```

```python
# myapp/services/auth.py

# Absolute import - full path from project root
from myapp.models.user import User

def authenticate(username):
    user = User(username)
    return user

# ✅ Advantages:
# - Clear and explicit
# - Works from anywhere
# - Easy to understand
# - Recommended for most cases
```

### Relative Imports

Import **relative to current module's location**.

```python
# myapp/services/auth.py

# Relative import using dots
from ..models.user import User  # Go up one level (..), then to models/user

def authenticate(username):
    user = User(username)
    return user

# ✅ Advantages:
# - Package is portable (can rename parent package)
# - Shorter paths within package
# - Good for internal package imports

# ❌ Disadvantages:
# - Only works inside packages
# - Can be confusing with many dots
# - Doesn't work in __main__ script
```

### Detailed Relative Import Examples

```
myproject/
└── myapp/
    ├── __init__.py
    ├── main.py
    ├── models/
    │   ├── __init__.py
    │   ├── user.py       ← Current file
    │   ├── post.py
    │   └── comment.py
    ├── services/
    │   ├── __init__.py
    │   ├── auth.py
    │   └── email.py
    └── utils/
        ├── __init__.py
        ├── validators.py
        └── formatters.py
```

```python
# Inside myapp/models/user.py

# Import from SAME directory (models/)
from . import post           # Import models/post.py
from . import comment        # Import models/comment.py
from .post import Post       # Import Post class from models/post.py

# Import from PARENT directory (myapp/)
from .. import main          # Import myapp/main.py

# Import from SIBLING directory (same level as models/)
from ..services import auth              # Import myapp/services/auth.py
from ..services.auth import authenticate # Import function from auth.py
from ..utils.validators import check_email  # Import from utils/validators.py

# Multiple levels up (if you had nested packages)
from ...somepackage import something  # Go up 3 levels
```

### Real-World Example: from . import Explained

```
ecommerce/
└── store/
    ├── __init__.py          ← File 1
    ├── models/
    │   ├── __init__.py      ← File 2 (You are here)
    │   ├── product.py       ← File 3
    │   ├── order.py         ← File 4
    │   └── customer.py      ← File 5
    └── services/
        └── payment.py
```

```python
# File 2: store/models/__init__.py

# What does "from . import" do here?

from . import product    # Import store/models/product.py
from . import order      # Import store/models/order.py  
from . import customer   # Import store/models/customer.py

# This makes them available when someone imports the package:
# >>> from store.models import product
# >>> from store.models import order

# You can also expose specific classes:
from .product import Product
from .order import Order
from .customer import Customer

# Now users can do:
# >>> from store.models import Product, Order, Customer
# Instead of:
# >>> from store.models.product import Product
```

### The Dot (.) Use Cases

#### Use Case 1: Package __init__.py

```python
# myapp/models/__init__.py

# Expose all models from package
from .user import User
from .post import Post
from .comment import Comment

# Now users can import directly from models:
# from myapp.models import User, Post, Comment
```

#### Use Case 2: Importing Sibling Modules

```python
# myapp/models/post.py

# Import User from sibling module user.py
from .user import User

class Post:
    def __init__(self, author: User):
        self.author = author
```

#### Use Case 3: Importing from Parent Package

```python
# myapp/models/user.py

# Import config from parent package
from ..config import DATABASE_URL

# Import from sibling package
from ..utils.validators import validate_email
```

### When to Use Which Import Style?

```python
# ✅ Use ABSOLUTE imports for:
# - Main entry points (scripts that run directly)
# - Clear, unambiguous imports
# - When you want code to be readable by anyone

from myapp.models.user import User
from myapp.services.auth import authenticate

# ✅ Use RELATIVE imports for:
# - Inside packages (__init__.py files)
# - When modules are tightly coupled
# - When you want portability (package can be renamed)

from . import helpers
from ..models import User
from .validators import check_email
```

### Common Mistakes with Relative Imports

```python
# ❌ MISTAKE 1: Using relative imports in main script
# File: myapp/main.py
from . import models  # ERROR! Can't use relative import in script run directly

# ✅ FIX: Use absolute import
from myapp import models


# ❌ MISTAKE 2: Too many dots
from ..... import something  # Hard to read and maintain

# ✅ FIX: Use absolute import
from mypackage.subpackage import something


# ❌ MISTAKE 3: Mixing relative and absolute inconsistently
from ..models import User          # Relative
from myapp.services import auth    # Absolute - confusing!

# ✅ FIX: Be consistent within a package
from ..models import User
from ..services import auth
```

### Complete Example: All Import Styles

```
myproject/
└── myapp/
    ├── __init__.py
    ├── run.py           ← Entry point
    ├── config.py
    ├── models/
    │   ├── __init__.py
    │   ├── base.py
    │   └── user.py
    └── services/
        ├── __init__.py
        └── auth.py
```

```python
# 1. myapp/run.py (Main entry point - use ABSOLUTE)
from myapp.models.user import User
from myapp.services.auth import authenticate

def main():
    user = User("alice")
    authenticate(user)

if __name__ == "__main__":
    main()


# 2. myapp/models/__init__.py (Package init - use RELATIVE)
from .base import BaseModel
from .user import User

__all__ = ['BaseModel', 'User']


# 3. myapp/models/user.py (Inside package - use RELATIVE)
from .base import BaseModel        # Same directory
from ..config import DATABASE_URL  # Parent directory

class User(BaseModel):
    def __init__(self, name):
        self.name = name
        self.db_url = DATABASE_URL


# 4. myapp/services/auth.py (Inside package - use RELATIVE)
from ..models.user import User  # Go up one level, then to models

def authenticate(user: User):
    print(f"Authenticating {user.name}")
```

### Quick Reference: Dot Navigation

| Syntax | Meaning | Example |
|--------|---------|---------|
| `from . import X` | Current directory | `from . import user` |
| `from .X import Y` | From file in current dir | `from .user import User` |
| `from .. import X` | Parent directory | `from .. import config` |
| `from ..X import Y` | From parent's file | `from ..config import DB_URL` |
| `from ..X.Y import Z` | Parent → subdirectory → file | `from ..models.user import User` |
| `from ... import X` | Grandparent directory | `from ... import base` |

### Absolute Imports

Import using full module path from project root.

```
myapp/
├── myapp/
│   ├── __init__.py
│   ├── models/
│   │   ├── __init__.py
│   │   └── user.py
│   └── services/
│       ├── __init__.py
│       └── auth.py
```

```python
# myapp/services/auth.py
from myapp.models.user import User  # Absolute import

def authenticate(username):
    user = User(username)
    return user
```

### Relative Imports

Import relative to current module's location.

```python
# myapp/services/auth.py
from ..models.user import User  # Relative import
# .. means "go up one directory"

def authenticate(username):
    user = User(username)
    return user
```

**Relative Import Syntax:**
- `.` = current package
- `..` = parent package
- `...` = grandparent package

```python
# myapp/services/auth.py
from . import helpers          # From current package
from ..models import user      # From parent package's models
from ..models.user import User # Specific import
```

### When to Use Which?

```python
# ✅ Absolute imports - clearer, works everywhere
from myapp.models.user import User
from myapp.utils.helpers import format_name

# ✅ Relative imports - good for package-internal imports
from .models import User
from ..utils import format_name

# ❌ Avoid relative imports in entry point scripts
# main.py should use absolute imports
```

## Sharing Code Between Folders

### Sibling Directories

```
project/
├── app/
│   ├── __init__.py
│   └── main.py
└── utils/
    ├── __init__.py
    └── helpers.py
```

**Problem:** `app/main.py` can't import `utils.helpers` directly.

**Solution 1:** Make project root a package

```
project/
├── __init__.py       # Add this
├── app/
│   ├── __init__.py
│   └── main.py
└── utils/
    ├── __init__.py
    └── helpers.py
```

```python
# app/main.py
from utils.helpers import some_function
```

**Solution 2:** Modify Python path

```python
# app/main.py
import sys
from pathlib import Path

# Add parent directory to path
sys.path.insert(0, str(Path(__file__).parent.parent))

from utils.helpers import some_function
```

**Solution 3:** Install as package (best for production)

```python
# setup.py at project root
from setuptools import setup, find_packages

setup(
    name='myproject',
    packages=find_packages(),
)
```

```bash
# Install in development mode
pip install -e .

# Now can import from anywhere
from utils.helpers import some_function
```

### Cross-Folder Imports Example

```
webapp/
├── backend/
│   ├── __init__.py
│   ├── api.py
│   └── models.py
├── frontend/
│   ├── __init__.py
│   └── components.py
└── shared/
    ├── __init__.py
    └── constants.py
```

```python
# backend/api.py
from shared.constants import API_VERSION  # Import from shared

# shared/constants.py
API_VERSION = 'v1'
MAX_UPLOAD_SIZE = 10 * 1024 * 1024  # 10MB

# frontend/components.py
from shared.constants import API_VERSION
```

## Environment and Configuration

### Using Environment Variables

```python
import os
from pathlib import Path

# Get environment variable
DATABASE_URL = os.environ.get('DATABASE_URL', 'sqlite:///default.db')

# Check if variable exists
if 'API_KEY' in os.environ:
    api_key = os.environ['API_KEY']

# Get with type conversion
DEBUG = os.environ.get('DEBUG', 'False').lower() == 'true'
PORT = int(os.environ.get('PORT', 8000))
```

### Configuration File Pattern

```python
# config/base.py
class BaseConfig:
    DEBUG = False
    TESTING = False
    DATABASE_URL = 'sqlite:///app.db'

# config/development.py
from .base import BaseConfig

class DevelopmentConfig(BaseConfig):
    DEBUG = True
    DATABASE_URL = 'sqlite:///dev.db'

# config/production.py
from .base import BaseConfig

class ProductionConfig(BaseConfig):
    DATABASE_URL = os.environ['DATABASE_URL']
    SECRET_KEY = os.environ['SECRET_KEY']

# config/__init__.py
import os

config = {
    'development': 'config.development.DevelopmentConfig',
    'production': 'config.production.ProductionConfig',
}

def get_config():
    env = os.environ.get('FLASK_ENV', 'development')
    return config[env]
```

### `.env` Files

```bash
# .env
DATABASE_URL=postgresql://localhost/mydb
SECRET_KEY=your-secret-key
DEBUG=True
```

```python
# Load with python-dotenv
from dotenv import load_dotenv
import os

load_dotenv()  # Loads variables from .env

DATABASE_URL = os.environ['DATABASE_URL']
```

## Python Path and PYTHONPATH

### Understanding `sys.path`

```python
import sys

# Where Python looks for modules
print(sys.path)
# ['/current/directory', '/usr/lib/python3.x', ...]

# Add directory to path
sys.path.append('/path/to/modules')
sys.path.insert(0, '/path/to/modules')  # Add at beginning (higher priority)
```

### Setting PYTHONPATH

```bash
# Bash
export PYTHONPATH=/path/to/project:$PYTHONPATH

# Windows Command Prompt
set PYTHONPATH=C:\path\to\project;%PYTHONPATH%

# Windows PowerShell
$env:PYTHONPATH = "C:\path\to\project;$env:PYTHONPATH"
```

```python
# Or in Python before imports
import sys
import os

project_root = os.path.dirname(os.path.dirname(__file__))
sys.path.insert(0, project_root)
```

## Package Entry Points

### `__main__.py`

Allows running package as script.

```
mypackage/
├── __init__.py
├── __main__.py
└── core.py
```

```python
# mypackage/__main__.py
from .core import main

if __name__ == '__main__':
    main()
```

```bash
# Run package as module
python -m mypackage
```

### `if __name__ == '__main__'`

```python
# module.py
def main():
    print("Running main function")

def helper():
    print("Helper function")

# Only runs when script is executed directly
if __name__ == '__main__':
    main()
```

```bash
python module.py        # Runs main()
python -c "import module"  # Doesn't run main()
```

## Best Practices

```python
# ✅ DO: Use clear package structure
myapp/
├── myapp/          # Package code
├── tests/          # Tests
├── docs/           # Documentation
└── requirements.txt

# ✅ DO: Use absolute imports in main scripts
from myapp.models import User

# ✅ DO: Use relative imports within packages
from .models import User

# ✅ DO: Keep __init__.py files minimal
# __init__.py
from .core import main_function
__version__ = '1.0.0'

# ✅ DO: Organize by feature (for large apps)
myapp/
├── users/
│   ├── models.py
│   ├── views.py
│   └── services.py
└── products/
    ├── models.py
    ├── views.py
    └── services.py

# ❌ DON'T: Use relative imports in entry scripts
# main.py
from .utils import helper  # Error!

# ❌ DON'T: Circular imports
# a.py
from b import function_b
# b.py
from a import function_a  # Circular!

# ❌ DON'T: Modify sys.path in library code
# Only in entry points/scripts
```

## Virtual Environments

Isolate project dependencies.

```bash
# Create virtual environment
python -m venv venv

# Activate
# Linux/Mac:
source venv/bin/activate
# Windows:
venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Deactivate
deactivate
```

### `requirements.txt`

```
# requirements.txt
Flask==2.3.0
SQLAlchemy>=1.4,<2.0
pytest==7.3.1
```

```bash
# Generate from current environment
pip freeze > requirements.txt

# Install from file
pip install -r requirements.txt
```

---

**Navigation:**
- [← Previous: Database Operations](/?page=python/py-06-database)
- [→ Next: Frameworks & Libraries](/?page=python/py-08-frameworks-libraries)
- [↑ Back to Python Basics](/?page=python/py-01-basics)
- [🏠 Home](/?page=home)
