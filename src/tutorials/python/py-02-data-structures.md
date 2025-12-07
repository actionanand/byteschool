# Python Data Structures

## Lists

Lists are **mutable**, ordered collections that can hold any type of data.

### Creating Lists

```python
# Empty list
empty = []
also_empty = list()

# With initial values
numbers = [1, 2, 3, 4, 5]
mixed = [1, "hello", 3.14, True, None]
nested = [[1, 2], [3, 4], [5, 6]]

# List comprehension (elegant!)
squares = [x**2 for x in range(10)]
evens = [x for x in range(20) if x % 2 == 0]
```

### List Operations

```python
fruits = ['apple', 'banana', 'cherry']

# Accessing
fruits[0]        # 'apple' (first item)
fruits[-1]       # 'cherry' (last item)
fruits[0:2]      # ['apple', 'banana'] (slice)

# Adding
fruits.append('date')           # Add to end
fruits.insert(1, 'blueberry')  # Insert at index
fruits.extend(['elderberry'])   # Add multiple

# Removing
fruits.remove('banana')  # Remove by value
popped = fruits.pop()    # Remove and return last
popped = fruits.pop(0)   # Remove and return at index
del fruits[0]            # Delete by index
fruits.clear()           # Remove all items

# Searching
'apple' in fruits        # True/False
fruits.index('apple')    # Get index (raises error if not found)
fruits.count('apple')    # Count occurrences

# Sorting
fruits.sort()                    # Sort in place
fruits.sort(reverse=True)        # Reverse sort
sorted_fruits = sorted(fruits)   # Return new sorted list

# Other operations
len(fruits)              # Length
fruits.reverse()         # Reverse in place
fruits.copy()            # Shallow copy
```

### List Comprehensions (Advanced)

```python
# Basic
squares = [x**2 for x in range(10)]

# With condition
evens = [x for x in range(20) if x % 2 == 0]

# Transform and filter
upper_fruits = [f.upper() for f in fruits if len(f) > 5]

# Nested comprehension
matrix = [[i*j for j in range(3)] for i in range(3)]

# Multiple conditions
filtered = [x for x in range(100) if x % 2 == 0 if x % 5 == 0]
```

## Dictionaries (dict)

Dictionaries are **mutable**, unordered (ordered in Python 3.7+) key-value collections.

### Creating Dictionaries

```python
# Empty dict
empty = {}
also_empty = dict()

# With initial values
person = {
    'name': 'Alice',
    'age': 30,
    'email': 'alice@example.com'
}

# Using dict()
person = dict(name='Alice', age=30, email='alice@example.com')

# Dict comprehension
squares = {x: x**2 for x in range(5)}
# {0: 0, 1: 1, 2: 4, 3: 9, 4: 16}
```

### Dictionary Operations

```python
person = {'name': 'Alice', 'age': 30, 'city': 'NYC'}

# Accessing
person['name']              # 'Alice'
person.get('name')          # 'Alice'
person.get('phone', 'N/A')  # 'N/A' (default if not found)

# Adding/Updating
person['email'] = 'alice@example.com'  # Add new key
person['age'] = 31                      # Update existing
person.update({'phone': '555-1234', 'zip': '10001'})

# Removing
del person['city']           # Delete key
age = person.pop('age')      # Remove and return value
person.clear()               # Remove all items

# Checking
'name' in person             # True if key exists
'Alice' in person.values()   # True if value exists

# Iteration
for key in person:
    print(key, person[key])

for key, value in person.items():
    print(f"{key}: {value}")

for key in person.keys():
    print(key)

for value in person.values():
    print(value)

# Other operations
len(person)                  # Number of keys
person.keys()                # dict_keys(['name', 'age', ...])
person.values()              # dict_values(['Alice', 30, ...])
person.items()               # dict_items([('name', 'Alice'), ...])
person.copy()                # Shallow copy
```

### Dictionary Comprehensions

```python
# Basic
squares = {x: x**2 for x in range(5)}

# From two lists
keys = ['name', 'age', 'city']
values = ['Alice', 30, 'NYC']
person = {k: v for k, v in zip(keys, values)}

# With condition
even_squares = {x: x**2 for x in range(10) if x % 2 == 0}

# Transform keys/values
upper_dict = {k.upper(): v for k, v in person.items()}
```

## Tuples

Tuples are **immutable**, ordered collections. Once created, cannot be changed.

### Creating Tuples

```python
# Empty tuple
empty = ()
also_empty = tuple()

# With values
point = (10, 20)
person = ('Alice', 30, 'alice@example.com')

# Single item tuple (note the comma!)
single = (42,)
not_tuple = (42)  # This is just an int!

# Tuple unpacking
x, y = point
name, age, email = person
```

### Tuple Operations

```python
point = (10, 20, 30)

# Accessing
point[0]         # 10
point[-1]        # 30 (last item)
point[0:2]       # (10, 20) (slice)

# Immutable - these will fail!
# point[0] = 15   # TypeError!
# point.append(40) # AttributeError!

# Other operations
len(point)       # 3
10 in point      # True
point.count(10)  # 1
point.index(20)  # 1
```

### When to Use Tuples vs Lists?

```python
# Use TUPLE when:
# - Data shouldn't change (immutable)
# - Dictionary keys (lists can't be keys!)
# - Function returns multiple values
# - Performance matters (tuples are faster)

coordinates = (40.7128, -74.0060)  # Fixed lat/lng
rgb_color = (255, 0, 128)          # Fixed RGB values

# Use LIST when:
# - Data needs to change
# - Adding/removing items
# - Sorting or modifying data

todo_items = ['Task 1', 'Task 2']  # Will add more
todo_items.append('Task 3')
```

## Sets

Sets are **mutable**, unordered collections of **unique** elements.

### Creating Sets

```python
# Empty set (can't use {} - that's a dict!)
empty = set()

# With values
numbers = {1, 2, 3, 4, 5}
letters = set(['a', 'b', 'c'])

# Duplicates are automatically removed
numbers = {1, 2, 2, 3, 3, 3}  # Results in {1, 2, 3}

# Set comprehension
squares = {x**2 for x in range(5)}
```

### Set Operations

```python
fruits = {'apple', 'banana', 'cherry'}

# Adding
fruits.add('date')                   # Add single item
fruits.update(['elderberry', 'fig']) # Add multiple

# Removing
fruits.remove('banana')   # Remove (raises error if not found)
fruits.discard('banana')  # Remove (no error if not found)
popped = fruits.pop()     # Remove and return arbitrary item
fruits.clear()            # Remove all

# Checking
'apple' in fruits         # True/False
len(fruits)               # Number of items

# Set operations (mathematical)
a = {1, 2, 3, 4}
b = {3, 4, 5, 6}

a | b        # Union: {1, 2, 3, 4, 5, 6}
a & b        # Intersection: {3, 4}
a - b        # Difference: {1, 2}
a ^ b        # Symmetric difference: {1, 2, 5, 6}

# Method versions
a.union(b)
a.intersection(b)
a.difference(b)
a.symmetric_difference(b)

# Subset/superset
a.issubset(b)     # Is a subset of b?
a.issuperset(b)   # Is a superset of b?
```

## Comparison: List vs Dict vs Tuple vs Set

| Feature | List | Dict | Tuple | Set |
|---------|------|------|-------|-----|
| **Mutable** | ✅ Yes | ✅ Yes | ❌ No | ✅ Yes |
| **Ordered** | ✅ Yes | ✅ Yes (3.7+) | ✅ Yes | ❌ No |
| **Duplicates** | ✅ Yes | ❌ Keys unique | ✅ Yes | ❌ No |
| **Indexing** | ✅ Yes | ✅ By key | ✅ Yes | ❌ No |
| **Use Case** | Ordered items | Key-value pairs | Fixed data | Unique items |

## Common Patterns

### Converting Between Types

```python
# List to set (remove duplicates)
numbers = [1, 2, 2, 3, 3, 3]
unique = list(set(numbers))  # [1, 2, 3]

# Dict keys/values to list
person = {'name': 'Alice', 'age': 30}
keys = list(person.keys())
values = list(person.values())

# String to list
chars = list("hello")  # ['h', 'e', 'l', 'l', 'o']

# List to tuple
immutable = tuple([1, 2, 3])
```

### Nested Structures

```python
# List of dicts (common for data)
users = [
    {'name': 'Alice', 'age': 30},
    {'name': 'Bob', 'age': 25},
    {'name': 'Charlie', 'age': 35}
]

# Access
users[0]['name']  # 'Alice'

# Dict of lists
categories = {
    'fruits': ['apple', 'banana'],
    'vegetables': ['carrot', 'broccoli']
}

# Access
categories['fruits'][0]  # 'apple'
```

---

**Navigation:**
- [← Previous: Python Basics](#/py-basics)
- [→ Next: Functions & Methods](#/py-functions)
- [↑ Back to Python Basics](#/py-basics)
- [🏠 Home](#/home)
