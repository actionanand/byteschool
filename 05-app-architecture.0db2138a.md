# Todo App Architecture

## Project Overview

The Coffee TODO application demonstrates professional CoffeeScript patterns in a real-world project. It's built with **Vite** for fast development and production builds.

## Vite Configuration

Here's the `vite.config.js` setup for this project:

```javascript
import { defineConfig } from 'vite'

export default defineConfig({
  server: {
    port: 3000,
    open: true,  // Auto-open browser
  },
  build: {
    outDir: 'dist',
    sourcemap: true,  // Debug in production
  },
})
```

**Key features:**
- **Fast HMR (Hot Module Replacement)**: Changes refresh instantly
- **Optimized builds**: Minified, tree-shaken production code
- **Source maps**: Debug compiled CoffeeScript easily

## Architecture Pattern: MVC

The app follows Model-View-Controller pattern:

### Models
Models represent data and business logic:

```coffeescript
# models/todo.coffee - Data model with validation
class Todo
  constructor: (title, @category = 'general', @priority = 'medium') ->
    @id = uuidv4()
    @title = title
    @completed = false
    @createdAt = new Date()
    @updatedAt = new Date()
  
  # Getters for computed properties
  get displayTitle(): string
    if @completed then "✓ #{@title}" else @title
  
  # Setters with validation
  set title(newTitle: string)
    throw new Error('Title empty') if newTitle.trim().length is 0
    @title = newTitle.trim()
    @updatedAt = new Date()
  
  # Methods
  toggle: ->
    @completed = not @completed
    @updatedAt = new Date()
  
  toJSON: ->
    { id: @id, title: @title, completed: @completed, ... }

# models/store.coffee - State management
class TodoStore
  constructor: ->
    @todos = []
    @filters = { status: 'all', category: 'all' }
    @loadFromStorage()
  
  # Business logic
  addTodo: (title, category, priority) ->
    todo = new Todo(title, category, priority)
    @todos.push(todo)
    @saveToStorage()
    todo
  
  getFilteredTodos: ->
    @todos.filter((todo) => @matchesFilters(todo))
  
  saveToStorage: ->
    data = { todos: @todos.map((t) -> t.toJSON()), filters: @filters }
    localStorage.setItem('coffee-todo-store', JSON.stringify(data))
```

### Views
Components render UI and handle user interaction:

```coffeescript
# components/input-form.coffee
class TodoInputForm
  constructor: (@container, @onSubmit) ->
    @render()
    @attachEventListeners()
  
  render: ->
    @container.innerHTML = '''
      <form class="input-form" id="todo-form">
        <input type="text" class="todo-input" placeholder="Add a todo..." />
        <select class="category-select">
          <option>General</option>
          <option>Work</option>
          <option>Personal</option>
        </select>
        <button type="submit">Add</button>
      </form>
    '''
  
  attachEventListeners: ->
    form = document.getElementById('todo-form')
    form.addEventListener('submit', (e) =>
      e.preventDefault()
      input = form.querySelector('.todo-input')
      category = form.querySelector('.category-select').value
      @onSubmit?(input.value, category)
      input.value = ''
    )

# components/todo-item.coffee
class TodoItem
  constructor: (@todo, @onToggle, @onDelete) ->
    @element = null
    @render()
  
  render: ->
    @element = document.createElement('div')
    @element.className = "todo-item #{@todo.statusBadge}"
    @element.innerHTML = '''
      <input type="checkbox" #{if @todo.completed then 'checked' else ''} />
      <span class="text">#{@todo.displayTitle}</span>
      <button class="delete-btn">Delete</button>
    '''
    @attachEventListeners()
    @element
  
  attachEventListeners: ->
    checkbox = @element.querySelector('input[type="checkbox"]')
    checkbox.addEventListener('change', =>
      @onToggle?.(@todo.id)
    )
```

### Controller
The main app orchestrates models and views:

```coffeescript
# app.coffee
class TodoApp
  constructor: ->
    @store = new TodoStore()
    @setupDOM()
    @initializeComponents()
    @setupEventListeners()
  
  setupDOM: ->
    app = document.getElementById('app')
    app.innerHTML = '''
      <header class="header">
        <h1>☕ Coffee TODO</h1>
      </header>
      <main class="main">
        <div class="input-section"></div>
        <div class="list-container"></div>
        <aside class="stats-sidebar"></aside>
      </main>
    '''
  
  initializeComponents: ->
    inputSection = document.querySelector('.input-section')
    listContainer = document.querySelector('.list-container')
    
    # Create views
    @inputForm = new TodoInputForm(inputSection, @handleAddTodo.bind(@))
    @todoList = new TodoList(listContainer, @store, @handleListUpdated.bind(@))
    @stats = new StatsComponent(document.querySelector('.stats-sidebar'), @store)
  
  setupEventListeners: ->
    # Keyboard shortcuts
    document.addEventListener('keydown', (e) =>
      if (e.ctrlKey or e.metaKey) and e.key is 'n'
        e.preventDefault()
        document.querySelector('.todo-input')?.focus()
    )
  
  # Event handlers
  handleAddTodo: (title, category, priority) ->
    @store.addTodo(title, category, priority)
    @handleListUpdated()
  
  handleListUpdated: ->
    @todoList.update()
    @stats.update()

# Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', ->
  window.app = new TodoApp()
)
```

## Data Flow

```
User Interaction
    ↓
View Component (input-form, todo-item)
    ↓
Controller (app.coffee)
    ↓
Store (business logic, state)
    ↓
Model (data, validation)
    ↓
UI Update (re-render components)
```

## Key Features in Action

### 1. State Management with Filters

```coffeescript
# Store maintains filter state
@filters = {
  status: 'all'      # all, completed, active
  category: 'all'    # all, work, personal, shopping, health
  searchTerm: ''
}

# Components update filters via the store
setFilter: (filterType: string, value: string) ->
  @filters[filterType] = value

# List re-renders with filtered todos
getFilteredTodos: ->
  @todos.filter((todo) =>
    statusMatch = switch @filters.status
      when 'completed' then todo.completed
      when 'active' then not todo.completed
      else true
    
    categoryMatch = @filters.category is 'all' or todo.category is @filters.category
    searchMatch = @filters.searchTerm is '' or todo.title.includes(@filters.searchTerm)
    
    statusMatch and categoryMatch and searchMatch
  )
```

### 2. Persistent Storage

```coffeescript
# Auto-save to localStorage
saveToStorage: ->
  data = {
    todos: @todos.map((todo) -> todo.toJSON())
    filters: @filters
  }
  localStorage.setItem('coffee-todo-store', JSON.stringify(data))

# Auto-load on startup
loadFromStorage: ->
  data = localStorage.getItem('coffee-todo-store')
  return unless data?
  
  parsed = JSON.parse(data)
  @todos = parsed.todos.map((json) -> Todo.fromJSON(json))
  @filters = parsed.filters
```

### 3. Real-time Statistics

```coffeescript
# Compute stats from current todos
getStats: ->
  total = @todos.length
  completed = @todos.filter((todo) -> todo.completed).length
  active = total - completed
  overdue = @todos.filter((todo) -> todo.isOverdue).length
  
  {
    total
    completed
    active
    overdue
    completionPercentage: if total > 0 then Math.round((completed / total) * 100) else 0
  }
```

## Running the Project

```bash
# Install dependencies
npm install

# Development with HMR
npm run dev          # Opens at http://localhost:3000

# Production build
npm run build        # Creates optimized dist/ folder

# Preview production build
npm run preview

# Lint code
npm run lint
```

## Project Highlights

- **Classes with Getters/Setters**: Encapsulation and validation
- **Closures**: Private variables in the store
- **Comprehensions**: Efficient filtering and mapping
- **Arrow Functions**: Lexical `this` binding for callbacks
- **Destructuring**: Clean parameter handling
- **String Interpolation**: Readable templates
- **Modern ES6**: Imports/exports, const/let patterns

This is a complete, production-ready application that showcases CoffeeScript best practices!

---

**Navigation:**
- [← Previous: Advanced Patterns](/?page=coffeescript/04-advanced)
- [↑ Back to Basics](/?page=coffeescript/01-basics)
- [🏠 Home](/?page=home)

**Explore More:**
- [Python Tutorials](/?page=python/py-01-basics) - Learn Python alongside CoffeeScript
- Check the `src/` directory in the project to see all these concepts in action
