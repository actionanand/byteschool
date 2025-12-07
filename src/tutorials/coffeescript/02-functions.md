# Functions & Methods

## Function Basics

CoffeeScript functions are declared with `->` (skinny arrow) or `=>` (fat arrow).

### Basic Functions

```coffeescript
# Function definition
greet = (name) ->
  "Hello, #{name}!"

# Calling the function
result = greet("Alice")  # "Hello, Alice!"

# Function with multiple parameters
add = (a, b) ->
  a + b

result = add(5, 3)  # 8

# Function with default parameters
multiply = (a, b = 2) ->
  a * b

multiply(5)       # 10
multiply(5, 3)    # 15
```

### Arrow Functions (Skinny vs Fat)

```coffeescript
# Skinny arrow -> (no binding of 'this')
regularFunc = (x) ->
  x * 2

# Fat arrow => (binds 'this' context)
ArrowFunc = (x) =>
  @value = x
  x * 2

# The key difference appears in classes:
class Counter
  constructor: ->
    @count = 0
  
  # Regular function - 'this' changes context
  increment: ->
    @count++  # May not work as expected in callbacks!
  
  # Fat arrow - 'this' stays bound to the instance
  decrement: =>
    @count--  # Always works correctly
```

### Implicit Return

CoffeeScript automatically returns the last expression:

```coffeescript
# No 'return' needed!
square = (x) ->
  x * x
  # Automatically returns x * x

# Explicit return if needed
getOrDefault = (value) ->
  return 'default' if not value?
  value
```

### Variable-Length Arguments

```coffeescript
# Rest parameters
sum = (numbers...) ->
  total = 0
  for num in numbers
    total += num
  total

sum(1, 2, 3, 4, 5)  # 15

# Destructuring with rest
printDetails = (name, others...) ->
  console.log "Name: #{name}"
  console.log "Others: #{others.join(', ')}"

printDetails('Alice', 'Bob', 'Charlie')
# Name: Alice
# Others: Bob, Charlie
```

### Conditional Return

```coffeescript
# One-liner conditionals
greetUser = (isAdmin) ->
  return 'Welcome, Admin!' if isAdmin
  'Welcome, User!'

# Multi-line
processInput = (value) ->
  if value < 0
    'Negative'
  else if value > 0
    'Positive'
  else
    'Zero'

# Switch-like with if/else if
categorize = (age) ->
  switch
    when age < 13 then 'Child'
    when age < 18 then 'Teen'
    when age < 65 then 'Adult'
    else 'Senior'
```

## Methods in Classes

Methods are functions defined inside classes. The `@` symbol refers to the instance.

```coffeescript
class Calculator
  constructor: (initial = 0) ->
    @value = initial
  
  # Method without parameters
  getValue: ->
    @value
  
  # Method with parameters
  add: (num) ->
    @value += num
    @  # Return the instance for chaining
  
  # Method with multiple parameters
  operation: (operator, num) ->
    switch operator
      when '+' then @value += num
      when '-' then @value -= num
      when '*' then @value *= num
      when '/' then @value /= num
    @
  
  # Getter property
  get result(): number
    @value
  
  # Setter property
  set result(newValue: number)
    @value = newValue

# Using the class
calc = new Calculator(10)
calc.add(5)           # @value is now 15
calc.operation('+', 3) # @value is now 18
result = calc.getValue()  # 18
```

## Callbacks and Higher-Order Functions

```coffeescript
# Function that takes another function
applyTwice = (fn, value) ->
  fn(fn(value))

double = (x) ->
  x * 2

applyTwice(double, 5)  # double(double(5)) = 20

# Array methods with callbacks
numbers = [1, 2, 3, 4, 5]

squared = numbers.map((x) -> x * x)
# [1, 4, 9, 16, 25]

evens = numbers.filter((x) -> x % 2 is 0)
# [2, 4]

sum = numbers.reduce((total, x) -> total + x)
# 15

# forEach with index
numbers.forEach((num, index) ->
  console.log "#{index}: #{num}"
)
```

## Closures

Closures allow functions to access variables from their outer scope:

```coffeescript
# Creating a counter with closure
makeCounter = ->
  count = 0  # Private variable
  ->
    count++
    count

counter = makeCounter()
counter()  # 1
counter()  # 2
counter()  # 3

# Each counter has its own private count
counter2 = makeCounter()
counter2()  # 1 (independent from counter)

# Practical example from our Todo Store
makeFilter = (store) ->
  (todos) ->
    todos.filter((todo) ->
      # Access 'store' from outer scope
      store.includes(todo)
    )

store = ['work', 'personal']
filterByStore = makeFilter(store)
```

---

**Navigation:**
- [← Previous: CoffeeScript Basics](/?page=coffeescript/01-basics)
- [→ Next: Classes & OOP](/?page=coffeescript/03-classes)
- [↑ Back to Basics](/?page=coffeescript/01-basics)
- [🏠 Home](/?page=home)
