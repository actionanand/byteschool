# Classes & Object-Oriented Programming

## Class Basics

Classes in CoffeeScript compile to JavaScript ES6 classes:

```coffeescript
class Person
  constructor: (name, age) ->
    @name = name
    @age = age
  
  # Method
  greet: ->
    "Hello, I'm #{@name}"
  
  # Method with parameters
  haveBirthday: ->
    @age++

# Creating an instance
person = new Person('Alice', 30)
person.greet()         # "Hello, I'm Alice"
person.haveBirthday()
person.age             # 31
```

## The @ Symbol

`@` is shorthand for `this.` in JavaScript. It refers to the current instance:

```coffeescript
class Todo
  constructor: (title) ->
    @title = title        # Instance property
    @completed = false    # Instance property
  
  toggle: ->
    @completed = not @completed  # Access instance property
  
  describe: ->
    status = if @completed then 'done' else 'pending'
    "#{@title} is #{status}"

todo = new Todo('Learn CoffeeScript')
todo.toggle()
console.log todo.describe()  # "Learn CoffeeScript is done"
```

### @ in Object Literals

```coffeescript
class User
  constructor: (name) ->
    @name = name
    @settings = {
      @name        # Shorthand for name: @name
      theme: 'dark'
      notifications: true
    }
  
  showSettings: ->
    console.log @settings
    # { name: 'Alice', theme: 'dark', notifications: true }
```

## Properties with Getters & Setters

```coffeescript
class Todo
  constructor: (title) ->
    @_title = title  # Private (by convention)
    @completed = false
  
  # Getter - accessed like a property
  get title(): string
    @_title
  
  # Setter - validates on set
  set title(newTitle: string)
    if newTitle.trim().length is 0
      throw new Error('Title cannot be empty')
    @_title = newTitle
  
  # Computed property
  get status(): string
    if @completed then '✓ Done' else '○ Todo'

todo = new Todo('Learn CoffeeScript')
console.log todo.title      # 'Learn CoffeeScript'
todo.title = 'New Title'    # Uses setter
console.log todo.status     # '○ Todo'
```

## Inheritance

CoffeeScript supports class inheritance with `extends`:

```coffeescript
# Base class
class Animal
  constructor: (name) ->
    @name = name
  
  speak: ->
    "#{@name} makes a sound"

# Derived class
class Dog extends Animal
  constructor: (name, breed) ->
    super(name)      # Call parent constructor
    @breed = breed
  
  # Override method
  speak: ->
    "#{@name} barks"
  
  # New method
  fetch: ->
    "#{@name} fetches the ball"

dog = new Dog('Rex', 'Labrador')
dog.speak()   # "Rex barks"
dog.fetch()   # "Rex fetches the ball"
```

## Static Methods

Static methods belong to the class, not instances:

```coffeescript
class MathUtil
  # Static method
  @add: (a, b) ->
    a + b
  
  @multiply: (a, b) ->
    a * b
  
  # Instance method for reference
  describe: ->
    'A math utility'

# Call static methods on the class
MathUtil.add(5, 3)        # 8
MathUtil.multiply(4, 2)   # 8

# Cannot call on instance (well, technically can but shouldn't)
util = new MathUtil()
util.describe()           # 'A math utility'
```

## Complete Class Example from Todo App

Here's how the `Todo` class is built:

```coffeescript
import { v4 as uuidv4 } from 'uuid'

export default class Todo
  constructor: (title, @category = 'general', @priority = 'medium') ->
    @id = uuidv4()
    @title = title.trim()
    @completed = false
    @createdAt = new Date()
    @updatedAt = new Date()
    @description = ''
    @dueDate = null
  
  # Getter for display
  get displayTitle(): string
    if @completed then "✓ #{@title}" else @title
  
  # Getter for computed value
  get isOverdue(): boolean
    @dueDate? and @dueDate < new Date() and not @completed
  
  # Setter with validation
  set title(newTitle: string)
    trimmed = newTitle.trim()
    throw new Error('Title cannot be empty') if trimmed.length is 0
    throw new Error('Title too long') if trimmed.length > 100
    @title = trimmed
    @updatedAt = new Date()
  
  # Method
  toggle: ->
    @completed = not @completed
    @updatedAt = new Date()
  
  # Method with parameter
  setDescription: (desc: string) ->
    @description = desc.trim()
    @updatedAt = new Date()
  
  # Convert to JSON
  toJSON: ->
    {
      id: @id
      title: @title
      category: @category
      priority: @priority
      completed: @completed
      createdAt: @createdAt.toISOString()
      updatedAt: @updatedAt.toISOString()
      description: @description
      dueDate: @dueDate?.toISOString() ? null
    }
  
  # Static method (class method)
  @fromJSON: (json) ->
    todo = new Todo(json.title, json.category, json.priority)
    todo.id = json.id
    todo.completed = json.completed
    todo.createdAt = new Date(json.createdAt)
    todo.updatedAt = new Date(json.updatedAt)
    todo.description = json.description
    todo.dueDate = if json.dueDate then new Date(json.dueDate) else null
    todo
```

## Mixins & Composition

```coffeescript
# Mixin object
timeable =
  getCreatedTime: ->
    @createdAt
  
  getDaysOld: ->
    now = new Date()
    days = (now - @createdAt) / (1000 * 60 * 60 * 24)
    Math.floor(days)

class Task
  constructor: (title) ->
    @title = title
    @createdAt = new Date()
    # Mix in methods
    Object.assign(@, timeable)

task = new Task('Learn')
task.getCreatedTime()  # Returns when task was created
task.getDaysOld()      # Returns how many days old
```

---

**Navigation:**
- [← Previous: Functions & Methods](#/functions)
- [→ Next: Advanced Patterns](#/advanced)
- [↑ Back to Basics](#/basics)
- [🏠 Home](#/home)
