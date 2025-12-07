# CoffeeScript Basics

## What is CoffeeScript?

CoffeeScript is a programming language that compiles to JavaScript. It offers a cleaner, more elegant syntax with modern features like arrow functions, classes, destructuring, and comprehensions built-in.

## Data Types

CoffeeScript supports all JavaScript data types with cleaner syntax:

### Strings
```coffeescript
# Double quotes with interpolation
name = "Alice"
greeting = "Hello, #{name}!"

# Single quotes (no interpolation)
simple = 'Hello'

# Multi-line strings
paragraph = """
  This is a
  multi-line string
  with interpolation: #{name}
"""
```

### Numbers
```coffeescript
# Integers and floats
integer = 42
float = 3.14

# Binary and octal literals
binary = 0b1010
octal = 0o755
```

### Booleans
```coffeescript
truth = true
falsehood = false
```

### Arrays
```coffeescript
# Array literals
fruits = ['apple', 'banana', 'cherry']

# Array with different types
mixed = [1, 'two', true, null]

# Array comprehensions (powerful!)
squares = (x * x for x in [1..5])  # [1, 4, 9, 16, 25]
evens = (x for x in [1..10] when x % 2 is 0)  # [2, 4, 6, 8, 10]
```

### Objects
```coffeescript
# Object literals
person = {
  name: 'Bob'
  age: 30
  email: 'bob@example.com'
}

# Shorthand syntax
name = 'Bob'
age = 30
person = { name, age }  # Same as { name: name, age: age }

# Nested objects
user = {
  profile: {
    fullName: 'Alice Smith'
    location: 'New York'
  }
}
```

### Null and Undefined
```coffeescript
nothing = null
notDefined = undefined

# Existential operator (unique to CoffeeScript)
value = something ? 'default'  # Returns 'default' if something is null/undefined
```

## Variables and Assignment

```coffeescript
# Basic assignment
x = 10

# Multiple assignment (destructuring)
[a, b, c] = [1, 2, 3]
a  # => 1

# Object destructuring
{ name, age } = person
# name and age are extracted from person

# Default values
{ name = 'Unknown', age = 0 } = person
```

## Operators

### Comparison
```coffeescript
# CoffeeScript uses English words
5 is 5              # true (instead of ===)
5 isnt 5            # false (instead of !==)
x > 10              # greater than
x < 10              # less than
x >= 10             # greater than or equal
x <= 10             # less than or equal
```

### Logical
```coffeescript
true and false      # false (instead of &&)
true or false       # true (instead of ||)
not true            # false (instead of !)
```

### Existential
```coffeescript
x?                  # true if x is not null/undefined
x?.y                # accesses y only if x exists (safe navigation)
x ? 'default'       # returns 'default' if x is null/undefined
```

## Comments

```coffeescript
# Single line comment

###
Multi-line comment
Useful for documentation
###

# Comments inside code
x = 10  # End of line comment
```

---

**Navigation:**
- [→ Next: Functions & Methods](#/functions)
- [🏠 Home](#/home)
