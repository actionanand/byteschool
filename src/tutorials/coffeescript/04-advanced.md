# Advanced CoffeeScript Patterns

## Array & Object Comprehensions

Comprehensions are powerful CoffeeScript features for filtering and transforming collections:

```coffeescript
# Basic array comprehension
numbers = [1, 2, 3, 4, 5]
squares = (x * x for x in numbers)
# [1, 4, 9, 16, 25]

# With conditional
evens = (x for x in numbers when x % 2 is 0)
# [2, 4]

# Nested loop
pairs = ([x, y] for x in [1..3] for y in ['a', 'b'])
# [[1, 'a'], [1, 'b'], [2, 'a'], [2, 'b'], [3, 'a'], [3, 'b']]

# Object comprehension
keys = ['name', 'age', 'email']
values = ['Alice', 30, 'alice@example.com']
obj = {keys[i]: values[i] for i in [0...keys.length]}
# { name: 'Alice', age: 30, email: 'alice@example.com' }

# From the Todo Store:
# Get all completed todos
completed = (todo for todo in @todos when todo.completed)

# Get todos by category
categorized = {}
for todo in @todos
  categorized[todo.category] ?= []
  categorized[todo.category].push(todo)
```

## Destructuring

Breaking apart arrays and objects into variables:

```coffeescript
# Array destructuring
[first, second, third] = [1, 2, 3]
# first = 1, second = 2, third = 3

# With rest operator
[head, tail...] = [1, 2, 3, 4, 5]
# head = 1, tail = [2, 3, 4, 5]

# Skipping elements
[a, , c] = [1, 2, 3]
# a = 1, c = 3

# Object destructuring
{ name, age } = { name: 'Alice', age: 30, email: 'alice@example.com' }
# name = 'Alice', age = 30

# Renaming in destructuring
{ name: fullName, age: years } = person
# fullName = 'Alice', years = 30

# With defaults
{ theme = 'light', language = 'en' } = userSettings
# If userSettings.theme is undefined, use 'light'

# From the Store:
# Destructuring updates
{ status, category, searchTerm } = @filters
```

## Existential Operator (?)

The existential operator checks for null/undefined:

```coffeescript
# Basic check
value = person.address?.city
# Returns city only if person.address exists
# Otherwise returns undefined (no error)

# With default
email = user.contact?.email ? 'no-email@example.com'
# Use email if exists, otherwise use default

# Safe method calling
result = obj.method?()
# Only call if method exists

# From the Todo class:
get formattedDate(): string
  return '' unless @dueDate?
  date = new Date(@dueDate)
  date.toLocaleDateString(...)

# Converting optional dates
dueDate: @dueDate?.toISOString() ? null
```

## Spread & Rest Operators

```coffeescript
# Spread in arrays
original = [1, 2, 3]
copy = [...original]  # Shallow copy
merged = [...original, 4, 5]  # [1, 2, 3, 4, 5]

# Spread in objects
defaults = { theme: 'light', language: 'en' }
userPrefs = { theme: 'dark' }
settings = { ...defaults, ...userPrefs }
# { theme: 'dark', language: 'en' }

# Rest parameters
sum = (numbers...) ->
  numbers.reduce((a, b) -> a + b)

sum(1, 2, 3, 4, 5)  # 15

# From the Store:
# Extracting multiple values
{ status, category, searchTerm } = @filters
```

## Conditional Statements & Expressions

```coffeescript
# If/else if/else
status = if age < 13
  'Child'
else if age < 18
  'Teen'
else
  'Adult'

# Unless (opposite of if)
console.log('Error!') unless isValid

# Switch expression
category = switch priority
  when 'high' then 'urgent'
  when 'medium' then 'normal'
  when 'low' then 'deferred'
  else 'unknown'

# Postfix conditionals (more readable)
@todos.push(todo) if validate(todo)
@todos.remove(id) unless confirmed?

# From the Store:
filtered = @todos.filter((todo) =>
  statusMatch = switch @filters.status
    when 'completed' then todo.completed
    when 'active' then not todo.completed
    else true
  
  categoryMatch = @filters.category is 'all' or todo.category is @filters.category
  
  statusMatch and categoryMatch
)
```

## Loops & Iteration

```coffeescript
# For-in loop
for item in array
  console.log item

# For-in with index
for item, index in array
  console.log "#{index}: #{item}"

# For-of loop (over object keys/values)
for key, value of object
  console.log "#{key}: #{value}"

# While loop
i = 0
while i < 10
  console.log i
  i++

# Until loop (opposite of while)
i = 0
until i >= 10
  console.log i
  i++

# Break and continue
for x in [1..10]
  continue if x % 2 isnt 0  # Skip odd
  break if x > 8
  console.log x
```

## String Interpolation

```coffeescript
name = 'Alice'
age = 30

# Simple interpolation
message = "Name: #{name}, Age: #{age}"

# Expression interpolation
message = "Next year: #{age + 1}"

# With method calls
upper = "Hello #{name.toUpperCase()}!"

# From the Todo component:
dueDate = if @todo.dueDate
  "<span class=\"due-date\">📅 #{@todo.formattedDate}</span>"
else
  ''

innerHTML = '''
  <div class="todo-header">
    <span class="priority">#{@todo.priority}</span>
    <span class="text">#{@todo.displayTitle}</span>
    #{dueDate}
  </div>
'''
```

## Commonly Used Methods

```coffeescript
# Array methods
array.map((x) -> x * 2)
array.filter((x) -> x > 5)
array.reduce((sum, x) -> sum + x)
array.find((x) -> x.id is 'abc')
array.includes(value)
array.slice(0, 3)
array.splice(1, 2)  # Mutates!

# String methods
string.toLowerCase()
string.toUpperCase()
string.trim()
string.split(',')
string.includes('text')
string.replace('old', 'new')
string.substring(0, 3)

# Object methods
Object.keys(obj)
Object.values(obj)
Object.entries(obj)
Object.assign(target, source)  # Spread alternative

# From the Store:
@todos = @todos.filter((todo) -> todo.id isnt id)
stats = @todos.map((todo) -> todo.priority)
```

---

**Navigation:**
- [← Previous: Classes & OOP](#/classes)
- [→ Next: Todo App Architecture](#/app-architecture)
- [↑ Back to Basics](#/basics)
- [🏠 Home](#/home)
