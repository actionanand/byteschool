# Python Classes & Object-Oriented Programming

## Class Basics

### Defining a Simple Class

```python
class Person:
    # Class variable (shared by all instances)
    species = "Homo sapiens"
    
    # Constructor - initializes new instance
    def __init__(self, name, age):
        # Instance variables (unique to each instance)
        self.name = name
        self.age = age
    
    # Instance method
    def greet(self):
        return f"Hello, I'm {self.name}"
    
    # Method with parameters
    def have_birthday(self):
        self.age += 1

# Create instances
person1 = Person("Alice", 30)
person2 = Person("Bob", 25)

# Access attributes and methods
print(person1.name)       # "Alice"
print(person1.greet())    # "Hello, I'm Alice"
person1.have_birthday()
print(person1.age)        # 31

# Class variable shared
print(Person.species)     # "Homo sapiens"
print(person1.species)    # "Homo sapiens"
```

## Understanding `self`

`self` is a **reference to the current instance** of the class.

```python
class Counter:
    def __init__(self):
        self.count = 0  # self.count is instance variable
    
    def increment(self):
        self.count += 1  # self refers to the instance
    
    def get_count(self):
        return self.count  # Access via self

c1 = Counter()
c2 = Counter()

c1.increment()
c1.increment()
c2.increment()

print(c1.get_count())  # 2 (c1's count)
print(c2.get_count())  # 1 (c2's count)
```

**Why `self` is needed:**
- Python passes the instance automatically as the first argument
- `self` lets you distinguish instance variables from local variables
- You can name it anything, but `self` is the convention

```python
class Example:
    def __init__(this, value):  # 'this' works but DON'T do this!
        this.value = value
    
    def show(self):
        return self.value
```

## `__init__` Method Deep Dive

The `__init__` method is the **constructor** that initializes new instances.

### Basic __init__ Patterns

```python
# Simple initialization
class User:
    def __init__(self, username, email):
        self.username = username
        self.email = email
        self.created_at = datetime.now()  # Auto-set
        self.is_active = True  # Default value

# With default parameters
class Product:
    def __init__(self, name, price, quantity=0, category="General"):
        self.name = name
        self.price = price
        self.quantity = quantity
        self.category = category

# Usage
product = Product("Laptop", 999.99)  # quantity=0, category="General"
product = Product("Phone", 599.99, quantity=50, category="Electronics")

# With type hints
class Book:
    def __init__(self, title: str, author: str, pages: int, isbn: str = None):
        self.title: str = title
        self.author: str = author
        self.pages: int = pages
        self.isbn: str = isbn

# With validation
class BankAccount:
    def __init__(self, account_number: str, initial_balance: float = 0.0):
        if initial_balance < 0:
            raise ValueError("Initial balance cannot be negative")
        
        self.account_number = account_number
        self.balance = initial_balance
        self.transactions = []  # Initialize empty list

# With *args and **kwargs
class FlexibleClass:
    def __init__(self, required_param, *args, **kwargs):
        self.required = required_param
        self.args = args  # Tuple of extra positional args
        self.kwargs = kwargs  # Dict of extra keyword args

obj = FlexibleClass("required", 1, 2, 3, name="Alice", age=30)
print(obj.args)    # (1, 2, 3)
print(obj.kwargs)  # {'name': 'Alice', 'age': 30}

# Calling parent __init__
class Employee(User):
    def __init__(self, username, email, employee_id, department):
        super().__init__(username, email)  # Call parent __init__
        self.employee_id = employee_id
        self.department = department

# Private attributes (convention with _)
class SecureClass:
    def __init__(self, public_data, private_data):
        self.public_data = public_data
        self._private_data = private_data  # Single _ = internal use
        self.__very_private = "secret"     # Double __ = name mangling
```

### Common __init__ Patterns

```python
# Pattern 1: Factory-like initialization
class Config:
    def __init__(self, config_dict=None):
        config_dict = config_dict or {}
        self.host = config_dict.get('host', 'localhost')
        self.port = config_dict.get('port', 8080)
        self.debug = config_dict.get('debug', False)

# Pattern 2: Copy constructor
class Point:
    def __init__(self, x=0, y=0, other=None):
        if other is not None:
            self.x = other.x
            self.y = other.y
        else:
            self.x = x
            self.y = y

# Usage
p1 = Point(10, 20)
p2 = Point(other=p1)  # Copy p1

# Pattern 3: Builder pattern with None defaults
class DatabaseConnection:
    def __init__(self, host=None, port=None, username=None, password=None):
        self.host = host or os.environ.get('DB_HOST', 'localhost')
        self.port = port or int(os.environ.get('DB_PORT', 5432))
        self.username = username or os.environ.get('DB_USER')
        self.password = password or os.environ.get('DB_PASS')
        self.connection = None

# Pattern 4: Initialization with computation
class Circle:
    def __init__(self, radius: float):
        self.radius = radius
        # Compute derived values in __init__
        self.diameter = radius * 2
        self.area = 3.14159 * radius ** 2
        self.circumference = 2 * 3.14159 * radius

# Pattern 5: Resource initialization
class FileHandler:
    def __init__(self, filename: str):
        self.filename = filename
        self.file = None
        self.is_open = False
    
    def __enter__(self):
        """Called when entering 'with' block"""
        self.file = open(self.filename, 'r')
        self.is_open = True
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        """Called when exiting 'with' block"""
        if self.file:
            self.file.close()
            self.is_open = False
```

## Type Hints for Instance Variables

```python
class User:
    # Python 3.6+ type hints
    def __init__(self, name: str, age: int):
        self.name: str = name
        self.age: int = age
        self.email: str = ""  # Optional, initialized later
    
    def set_email(self, email: str) -> None:
        self.email = email

# Python 3.10+ alternative (class variable annotations)
class User:
    name: str
    age: int
    email: str = ""  # Default value
    
    def __init__(self, name: str, age: int):
        self.name = name
        self.age = age
```

### Setting Attributes to `None`

```python
class DatabaseConnection:
    def __init__(self, host: str):
        self.host: str = host
        self.connection = None  # Not connected yet
        self.last_error: str = None  # No error yet
    
    def connect(self):
        try:
            # Connect logic...
            self.connection = "connected"
        except Exception as e:
            self.last_error = str(e)

# Why use None?
# - Indicates "no value yet" or "optional"
# - Avoids errors when attribute might not be set
# - Clear semantic meaning
```

## Class Variables vs Instance Variables

```python
class BankAccount:
    # Class variable - shared by ALL instances
    interest_rate = 0.05
    total_accounts = 0
    
    def __init__(self, owner: str, balance: float):
        # Instance variables - unique per instance
        self.owner = owner
        self.balance = balance
        
        # Modify class variable
        BankAccount.total_accounts += 1
    
    def apply_interest(self):
        # Access class variable via class name or self
        self.balance *= (1 + BankAccount.interest_rate)

acc1 = BankAccount("Alice", 1000)
acc2 = BankAccount("Bob", 2000)

print(BankAccount.total_accounts)  # 2

# Changing class variable affects all instances
BankAccount.interest_rate = 0.06
acc1.apply_interest()
acc2.apply_interest()
```

## Method Types

### Instance Methods

```python
class Circle:
    def __init__(self, radius: float):
        self.radius = radius
    
    # Regular instance method - needs self
    def area(self) -> float:
        return 3.14159 * self.radius ** 2
    
    def circumference(self) -> float:
        return 2 * 3.14159 * self.radius

circle = Circle(5)
print(circle.area())  # Needs instance
```

### Class Methods

Use `@classmethod` when you need access to the **class itself**, not an instance.

```python
class Person:
    population = 0
    
    def __init__(self, name: str, age: int):
        self.name = name
        self.age = age
        Person.population += 1
    
    @classmethod
    def from_birth_year(cls, name: str, birth_year: int) -> 'Person':
        """Alternative constructor"""
        age = 2024 - birth_year
        return cls(name, age)  # cls is the class itself
    
    @classmethod
    def get_population(cls) -> int:
        return cls.population

# Use classmethod as alternative constructor
person = Person.from_birth_year("Alice", 1990)

# Use classmethod to access class data
print(Person.get_population())
```

### Static Methods

Use `@staticmethod` when the method **doesn't need access** to instance or class.

```python
class MathUtils:
    @staticmethod
    def add(a: float, b: float) -> float:
        """Utility function, doesn't need self or cls"""
        return a + b
    
    @staticmethod
    def is_even(n: int) -> bool:
        return n % 2 == 0

# Call without creating instance
result = MathUtils.add(5, 3)
print(MathUtils.is_even(4))  # True
```

**Comparison:**

| Type | First Param | Access To | Use When |
|------|-------------|-----------|----------|
| Instance Method | `self` | Instance & Class | Need instance data |
| Class Method | `cls` | Class only | Alternative constructors, class data |
| Static Method | None | Neither | Utility functions |

## Properties with `@property`

Properties let you access methods like attributes (without parentheses).

```python
class Temperature:
    def __init__(self, celsius: float):
        self._celsius = celsius  # Private by convention
    
    @property
    def celsius(self) -> float:
        """Getter - access like attribute"""
        return self._celsius
    
    @celsius.setter
    def celsius(self, value: float) -> None:
        """Setter - validate before setting"""
        if value < -273.15:
            raise ValueError("Below absolute zero!")
        self._celsius = value
    
    @property
    def fahrenheit(self) -> float:
        """Computed property"""
        return self._celsius * 9/5 + 32
    
    @fahrenheit.setter
    def fahrenheit(self, value: float) -> None:
        self._celsius = (value - 32) * 5/9

# Usage
temp = Temperature(25)
print(temp.celsius)     # 25 (no parentheses!)
print(temp.fahrenheit)  # 77.0

temp.celsius = 30       # Uses setter
temp.fahrenheit = 100   # Sets via fahrenheit
print(temp.celsius)     # 37.78

# temp.celsius = -300  # Raises ValueError
```

**Why use @property:**
- Control access to attributes (validation, computed values)
- Change implementation without breaking API
- More Pythonic than Java-style getters/setters

## Real-World Class Patterns

### Multi-line Imports & Complex Constructors

```python
# Multi-line imports using backslash \
from models.my_db.report import Report
from typing import Union, Optional, List, Dict, \
    Tuple, Any

# Or use parentheses (preferred)
from typing import (
    Union, Optional, List, Dict,
    Tuple, Any, Callable
)

# Complex constructor with custom model dependency
class ReportProcessor:
    def __init__(
        self,
        origin_report: Report,  # Custom model from another module
        name: str,
        extracted_field_group_index: Union[int, None] = 0
    ) -> None:
        """
        Initialize ReportProcessor with a Report object.
        
        Args:
            origin_report: Original Report object from database
            name: Processor name
            extracted_field_group_index: Index of field group (None if no extraction)
        """
        # Store custom model reference
        self.origin_report = origin_report
        self.name = name
        self.extracted_field_group_index = extracted_field_group_index
        
        # Initialize other attributes
        self.processed_data: List[Dict[str, Any]] = []
        self.errors: List[str] = []

# Why Union[int, None] instead of Optional[int]?
# They're equivalent! Both mean "int or None"
# Optional[int] is just shorthand for Union[int, None]

# Python 3.10+ cleaner syntax
class ReportProcessor:
    def __init__(
        self,
        origin_report: Report,
        name: str,
        extracted_field_group_index: int | None = 0  # Cleaner!
    ) -> None:
        pass
```

### Understanding `self.__name = None`

```python
class User:
    def __init__(self, username: str, email: str):
        # Public attributes (no underscore)
        self.username = username
        self.email = email
        
        # Why set to None?
        # 1. Optional attribute - may be set later
        self.__name: str = None  # Private (name mangled)
        self._profile_pic: str = None  # Protected (convention)
        self.last_login = None  # Public optional
        
        # Initialize empty collections
        self.posts: List[Dict] = []
        self.settings: Dict[str, Any] = {}
    
    def set_name(self, first: str, last: str) -> None:
        """Set the private name after initialization"""
        self.__name = f"{first} {last}"
    
    def get_name(self) -> Optional[str]:
        """Get name, returns None if not set"""
        return self.__name

# Why use None?
user = User("alice123", "alice@example.com")
print(user.username)  # "alice123" - always exists
print(user.get_name())  # None - not set yet

user.set_name("Alice", "Smith")
print(user.get_name())  # "Alice Smith" - now set

# None vs default values
class Product:
    def __init__(self, name: str, price: float):
        self.name = name
        self.price = price
        
        # None = "not set yet" or "optional"
        self.discount: float = None
        self.sale_end_date = None
        
        # Empty collections = "no items yet"
        self.reviews: List[str] = []
        
        # Explicit defaults = "this is the starting value"
        self.in_stock: bool = True
        self.quantity: int = 0
```

### Using `self` in Methods with Collections

```python
from typing import List, Dict, Optional

class StudentGradeBook:
    def __init__(self, student_name: str):
        self.student_name = student_name
        self.grades: List[float] = []
        self.subjects: Dict[str, float] = {}
        self.attendance: List[bool] = []
    
    def add_grade(self, grade: float) -> None:
        """self gives access to instance's grades list"""
        self.grades.append(grade)
    
    def add_subject_grade(self, subject: str, grade: float) -> None:
        """self gives access to instance's subjects dict"""
        self.subjects[subject] = grade
    
    def mark_attendance(self, present: bool) -> None:
        """self gives access to instance's attendance list"""
        self.attendance.append(present)
    
    def get_average(self) -> float:
        """Calculate average using self.grades"""
        if not self.grades:  # Check if list is empty
            return 0.0
        return sum(self.grades) / len(self.grades)
    
    def get_subject_grades(self) -> Dict[str, float]:
        """Return copy of subjects dict"""
        return self.subjects.copy()
    
    def get_attendance_rate(self) -> float:
        """Calculate attendance percentage"""
        if not self.attendance:
            return 0.0
        present_count = sum(1 for present in self.attendance if present)
        return (present_count / len(self.attendance)) * 100

# Usage
student = StudentGradeBook("Alice")
student.add_grade(95.0)
student.add_grade(87.5)
student.add_grade(92.0)

student.add_subject_grade("Math", 95.0)
student.add_subject_grade("English", 87.5)

student.mark_attendance(True)
student.mark_attendance(True)
student.mark_attendance(False)

print(f"Average: {student.get_average()}")  # 91.5
print(f"Subjects: {student.get_subject_grades()}")
print(f"Attendance: {student.get_attendance_rate():.1f}%")  # 66.7%
```

### For Loops with Lists and Dicts in Methods

```python
class DataProcessor:
    def __init__(self, data: List[Dict[str, Any]]):
        self.data: List[Dict[str, Any]] = data
        self.processed: List[Dict[str, Any]] = []
        self.errors: List[str] = []
    
    def process_all(self) -> None:
        """Process all items with self access in loop"""
        # Loop through self.data
        for index, item in enumerate(self.data):
            try:
                # Use self to access instance methods
                processed_item = self._process_single(item, index)
                self.processed.append(processed_item)
            except Exception as e:
                self.errors.append(f"Error at index {index}: {str(e)}")
    
    def _process_single(self, item: Dict[str, Any], index: int) -> Dict[str, Any]:
        """Process single item - self used to access instance state"""
        result = {
            'index': index,
            'original': item,
            'processed': {}
        }
        
        # Loop through dictionary items
        for key, value in item.items():
            # Conditional processing
            if isinstance(value, str):
                result['processed'][key] = value.upper()
            elif isinstance(value, (int, float)):
                result['processed'][key] = value * 2
            else:
                result['processed'][key] = value
        
        return result
    
    def filter_by_condition(self, key: str, min_value: float) -> List[Dict]:
        """Filter processed data with conditional clause"""
        return [
            item for item in self.processed
            if key in item['processed'] and item['processed'][key] > min_value
        ]
    
    def get_summary(self) -> Dict[str, Any]:
        """Generate summary using self attributes"""
        return {
            'total_items': len(self.data),
            'processed_items': len(self.processed),
            'errors': len(self.errors),
            'success_rate': len(self.processed) / len(self.data) * 100 if self.data else 0
        }

# Usage
data = [
    {'name': 'alice', 'score': 50, 'active': True},
    {'name': 'bob', 'score': 75, 'active': False},
    {'name': 'charlie', 'score': 60, 'active': True}
]

processor = DataProcessor(data)
processor.process_all()

# Check results
print(f"Processed: {len(processor.processed)} items")
print(f"Errors: {len(processor.errors)} errors")
print(processor.get_summary())

# Filter results
high_scores = processor.filter_by_condition('score', 100)
print(f"High scores: {high_scores}")
```

### Conditional Clauses in Methods

```python
class UserValidator:
    def __init__(self, min_age: int = 18, allowed_domains: List[str] = None):
        self.min_age = min_age
        self.allowed_domains = allowed_domains or ['gmail.com', 'yahoo.com']
        self.validation_errors: List[str] = []
    
    def validate_user(self, user_data: Dict[str, Any]) -> bool:
        """Validate user with multiple conditional checks"""
        self.validation_errors.clear()  # Reset errors
        
        # Check required fields
        if 'username' not in user_data:
            self.validation_errors.append("Username is required")
            return False
        
        if 'email' not in user_data:
            self.validation_errors.append("Email is required")
            return False
        
        # Validate username
        username = user_data['username']
        if not isinstance(username, str):
            self.validation_errors.append("Username must be string")
        elif len(username) < 3:
            self.validation_errors.append("Username too short")
        elif len(username) > 20:
            self.validation_errors.append("Username too long")
        
        # Validate email
        email = user_data['email']
        if '@' not in email:
            self.validation_errors.append("Invalid email format")
        else:
            domain = email.split('@')[1]
            if domain not in self.allowed_domains:
                self.validation_errors.append(f"Domain {domain} not allowed")
        
        # Validate age if present
        if 'age' in user_data:
            age = user_data['age']
            if not isinstance(age, int):
                self.validation_errors.append("Age must be integer")
            elif age < self.min_age:
                self.validation_errors.append(f"Must be at least {self.min_age} years old")
            elif age > 150:
                self.validation_errors.append("Age seems unrealistic")
        
        return len(self.validation_errors) == 0
    
    def get_errors(self) -> List[str]:
        """Return validation errors"""
        return self.validation_errors.copy()

# Usage
validator = UserValidator(min_age=18)

user1 = {'username': 'alice', 'email': 'alice@gmail.com', 'age': 25}
if validator.validate_user(user1):
    print("User 1 valid!")
else:
    print(f"Errors: {validator.get_errors()}")

user2 = {'username': 'ab', 'email': 'bob@hotmail.com', 'age': 15}
if validator.validate_user(user2):
    print("User 2 valid!")
else:
    print(f"Errors: {validator.get_errors()}")
    # ['Username too short', 'Domain hotmail.com not allowed', 'Must be at least 18 years old']
```

### Using `vars()` to Inspect Objects

```python
class Report:
    def __init__(self, title: str, author: str):
        self.title = title
        self.author = author
        self.created_at = "2024-01-01"
        self.status = "draft"
        self._internal_id = "R123"
        self.data: Dict[str, Any] = {"views": 0, "downloads": 0}
    
    def __repr__(self):
        return f"Report(title='{self.title}', status='{self.status}')"

# Create object
report = Report("Q4 Report", "Alice")

# vars() returns __dict__ - all instance attributes as dict
print(vars(report))
# Output:
# {
#     'title': 'Q4 Report',
#     'author': 'Alice',
#     'created_at': '2024-01-01',
#     'status': 'draft',
#     '_internal_id': 'R123',
#     'data': {'views': 0, 'downloads': 0}
# }

# Useful for debugging
def debug_object(obj: Any) -> None:
    """Print all attributes of an object"""
    print(f"Object: {obj}")
    print(f"Type: {type(obj).__name__}")
    print("Attributes:")
    for key, value in vars(obj).items():
        print(f"  {key}: {value} ({type(value).__name__})")

debug_object(report)

# Useful for serialization
def object_to_dict(obj: Any) -> Dict[str, Any]:
    """Convert object to dictionary"""
    return vars(obj).copy()

report_dict = object_to_dict(report)
print(report_dict)

# Compare with dir() - shows all attributes AND methods
print(dir(report))  # Includes methods like __init__, __repr__, etc.

# vars() vs __dict__
print(vars(report) == report.__dict__)  # True - they're the same!

# Note: vars() doesn't work with __slots__
class SlottedClass:
    __slots__ = ('x', 'y')
    def __init__(self, x, y):
        self.x = x
        self.y = y

slotted = SlottedClass(1, 2)
# print(vars(slotted))  # ❌ TypeError: vars() argument must have __dict__ attribute
```

### Complete Real-World Example

```python
from typing import List, Dict, Union, Optional, Any
from datetime import datetime

# Custom model from another module (simulated)
class DatabaseRecord:
    def __init__(self, id: int, data: Dict[str, Any]):
        self.id = id
        self.data = data
        self.timestamp = datetime.now()

# Complex class with all concepts
class DataAnalyzer:
    def __init__(
        self,
        source_record: DatabaseRecord,
        analyzer_name: str,
        config: Optional[Dict[str, Any]] = None,
        threshold: Union[int, float, None] = None
    ) -> None:
        """
        Initialize analyzer with complex dependencies.
        
        Args:
            source_record: Original database record (custom model)
            analyzer_name: Name of this analyzer
            config: Optional configuration dict
            threshold: Numeric threshold or None for auto-detect
        """
        # Store custom model reference
        self.source_record = source_record
        self.analyzer_name = analyzer_name
        
        # Initialize with None (to be set later)
        self.__result: Optional[Dict[str, Any]] = None
        self._status: str = None
        
        # Process config with defaults
        self.config = config or {'default': True}
        self.threshold = threshold if threshold is not None else self._auto_detect_threshold()
        
        # Initialize collections
        self.metrics: List[float] = []
        self.categories: Dict[str, int] = {}
        self.warnings: List[str] = []
    
    def _auto_detect_threshold(self) -> float:
        """Private method to detect threshold"""
        return 0.5
    
    def analyze(self) -> None:
        """Main analysis using self in loops and conditionals"""
        data = self.source_record.data
        
        # Loop through data with conditional processing
        for key, value in data.items():
            # Type checking with conditionals
            if isinstance(value, (int, float)):
                self.metrics.append(float(value))
                
                # Conditional categorization
                if value > self.threshold:
                    self.categories['high'] = self.categories.get('high', 0) + 1
                elif value > 0:
                    self.categories['medium'] = self.categories.get('medium', 0) + 1
                else:
                    self.categories['low'] = self.categories.get('low', 0) + 1
            
            elif isinstance(value, str):
                if len(value) == 0:
                    self.warnings.append(f"Empty string for key: {key}")
            
            elif value is None:
                self.warnings.append(f"None value for key: {key}")
        
        # Set result (was None before)
        self.__result = {
            'total_metrics': len(self.metrics),
            'average': sum(self.metrics) / len(self.metrics) if self.metrics else 0,
            'categories': self.categories,
            'warnings_count': len(self.warnings)
        }
        self._status = "completed"
    
    def get_result(self) -> Optional[Dict[str, Any]]:
        """Get result (may be None if not analyzed yet)"""
        return self.__result
    
    def print_summary(self) -> None:
        """Print using vars() for debugging"""
        print(f"Analyzer: {self.analyzer_name}")
        print(f"Status: {self._status or 'not started'}")
        print("\nAll attributes:")
        
        # Use vars() but skip private attributes in output
        for key, value in vars(self).items():
            if not key.startswith('_DataAnalyzer__'):  # Skip name-mangled
                print(f"  {key}: {value}")

# Usage
record = DatabaseRecord(
    id=1,
    data={'score': 85, 'value': 120, 'name': 'test', 'empty': '', 'null': None}
)

analyzer = DataAnalyzer(
    source_record=record,
    analyzer_name="TestAnalyzer",
    config={'mode': 'strict'},
    threshold=100
)

print("Before analysis:")
print(f"Result: {analyzer.get_result()}")  # None

analyzer.analyze()

print("\nAfter analysis:")
print(f"Result: {analyzer.get_result()}")
print(f"Metrics: {analyzer.metrics}")
print(f"Categories: {analyzer.categories}")
print(f"Warnings: {analyzer.warnings}")

print("\nFull object inspection:")
analyzer.print_summary()
```

---

## `__slots__` - Memory Optimization

By default, Python stores instance attributes in a dict (`__dict__`). `__slots__` uses a fixed structure to save memory.

```python
# Without __slots__
class Person:
    def __init__(self, name: str, age: int):
        self.name = name
        self.age = age

p = Person("Alice", 30)
print(p.__dict__)  # {'name': 'Alice', 'age': 30}
p.email = "alice@example.com"  # Can add new attributes dynamically

# With __slots__
class OptimizedPerson:
    __slots__ = ('name', 'age')  # Only these attributes allowed
    
    def __init__(self, name: str, age: int):
        self.name = name
        self.age = age

p = OptimizedPerson("Bob", 25)
# p.email = "bob@example.com"  # ❌ AttributeError!
# print(p.__dict__)  # ❌ AttributeError - no __dict__!

# Memory comparison
import sys
regular = Person("Alice", 30)
optimized = OptimizedPerson("Alice", 30)
print(sys.getsizeof(regular.__dict__))  # ~240 bytes
print(sys.getsizeof(optimized))         # ~64 bytes
```

**When to use `__slots__`:**
- ✅ Creating thousands/millions of instances
- ✅ Fixed set of attributes
- ❌ Need dynamic attributes
- ❌ Inheritance (complex)
- ❌ Need vars() or __dict__ access

## Inheritance

```python
class Animal:
    def __init__(self, name: str):
        self.name = name
    
    def speak(self) -> str:
        return "Some sound"
    
    def info(self) -> str:
        return f"I am {self.name}"

class Dog(Animal):  # Dog inherits from Animal
    def __init__(self, name: str, breed: str):
        super().__init__(name)  # Call parent constructor
        self.breed = breed
    
    # Override method
    def speak(self) -> str:
        return "Woof!"
    
    # Add new method
    def fetch(self) -> str:
        return f"{self.name} fetches the ball"

class Cat(Animal):
    def speak(self) -> str:
        return "Meow!"

# Usage
dog = Dog("Buddy", "Golden Retriever")
print(dog.speak())  # "Woof!" (overridden)
print(dog.info())   # "I am Buddy" (inherited)
print(dog.fetch())  # "Buddy fetches the ball" (new)

cat = Cat("Whiskers")
print(cat.speak())  # "Meow!"
```

### Multiple Inheritance

```python
class Flyable:
    def fly(self) -> str:
        return "Flying!"

class Swimmable:
    def swim(self) -> str:
        return "Swimming!"

class Duck(Animal, Flyable, Swimmable):
    def speak(self) -> str:
        return "Quack!"

duck = Duck("Donald")
print(duck.speak())  # "Quack!"
print(duck.fly())    # "Flying!"
print(duck.swim())   # "Swimming!"
```

## Special Methods (Dunder Methods)

```python
class Book:
    def __init__(self, title: str, pages: int):
        self.title = title
        self.pages = pages
    
    def __str__(self) -> str:
        """String representation (user-friendly)"""
        return f"'{self.title}' ({self.pages} pages)"
    
    def __repr__(self) -> str:
        """String representation (developer-friendly)"""
        return f"Book(title='{self.title}', pages={self.pages})"
    
    def __len__(self) -> int:
        """Enable len(book)"""
        return self.pages
    
    def __eq__(self, other) -> bool:
        """Enable book1 == book2"""
        if not isinstance(other, Book):
            return False
        return self.title == other.title and self.pages == other.pages
    
    def __lt__(self, other) -> bool:
        """Enable book1 < book2"""
        return self.pages < other.pages

book = Book("Python Guide", 500)
print(str(book))   # "'Python Guide' (500 pages)"
print(len(book))   # 500

book2 = Book("Python Guide", 500)
print(book == book2)  # True
```

## Best Practices

```python
# ✅ DO: Use clear naming
class UserAccount:
    pass

# ❌ DON'T: Use unclear naming
class UA:
    pass

# ✅ DO: One responsibility per class
class User:
    def __init__(self, name: str):
        self.name = name

class UserRepository:
    def save(self, user: User):
        pass

# ❌ DON'T: God objects (do everything)
class User:
    def __init__(self, name: str):
        self.name = name
    def save_to_database(self): pass
    def send_email(self): pass
    def generate_report(self): pass

# ✅ DO: Use properties for computed/validated values
class Rectangle:
    def __init__(self, width: float, height: float):
        self._width = width
        self._height = height
    
    @property
    def area(self) -> float:
        return self._width * self._height

# ✅ DO: Initialize all instance attributes in __init__
class Config:
    def __init__(self):
        self.host: str = "localhost"
        self.port: int = 8080
        self.debug: bool = False
```

---

**Navigation:**
- [← Previous: Functions & Methods](#/py-functions)
- [→ Next: Advanced Concepts](#/py-advanced)
- [↑ Back to Python Basics](#/py-basics)
- [🏠 Home](#/home)

**See Also:**
- [Frameworks & Libraries](#/py-frameworks-libraries) - Flask, Django, FastAPI, and more
