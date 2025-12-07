# Store/State Management - Showcasing comprehensions, spreading, and functional patterns
# Demonstrates: Array comprehensions, object spreading, closures, and functional programming

import Todo from './todo.coffee'

export default class TodoStore
  constructor: ->
    @todos = []
    @filters =
      status: 'all' # all, completed, active
      category: 'all'
      searchTerm: ''
    @categories = ['general', 'work', 'personal', 'shopping', 'health']
    @loadFromStorage()

  # Add a new todo
  addTodo: (title: string, category: string = 'general', priority: string = 'medium') ->
    todo = new Todo(title, category, priority)
    @todos.push(todo)
    @saveToStorage()
    todo

  # Remove a todo
  removeTodo: (id: string) ->
    @todos = @todos.filter((todo) -> todo.id isnt id)
    @saveToStorage()

  # Get a specific todo
  getTodo: (id: string) ->
    @todos.find((todo) -> todo.id is id)

  # Update a todo (demonstrates object spreading)
  updateTodo: (id: string, updates: Object) ->
    todo = @getTodo(id)
    return null unless todo?
    
    # Apply updates using object properties
    Object.assign(todo, updates)
    @saveToStorage()
    todo

  # Toggle todo completion status
  toggleTodo: (id: string) ->
    todo = @getTodo(id)
    todo?.toggle()
    @saveToStorage()
    todo

  # Get filtered todos (demonstrates comprehensions)
  getFilteredTodos: ->
    filtered = @todos.filter((todo) =>
      # Filter by status
      statusMatch = switch @filters.status
        when 'completed' then todo.completed
        when 'active' then not todo.completed
        else true

      # Filter by category
      categoryMatch = @filters.category is 'all' or todo.category is @filters.category

      # Filter by search term (case-insensitive)
      searchMatch = @filters.searchTerm is '' or \
        todo.title.toLowerCase().includes(@filters.searchTerm.toLowerCase()) or \
        todo.description.toLowerCase().includes(@filters.searchTerm.toLowerCase())

      statusMatch and categoryMatch and searchMatch
    )

    # Sort by priority and date
    priorityOrder = { high: 0, medium: 1, low: 2 }
    filtered.sort((a, b) ->
      # Sort by completion first, then priority, then date
      if a.completed isnt b.completed
        a.completed - b.completed
      else if a.priority isnt b.priority
        priorityOrder[a.priority] - priorityOrder[b.priority]
      else
        b.createdAt.getTime() - a.createdAt.getTime()
    )

  # Get todos by category (array comprehension style)
  getTodosByCategory: (category: string) ->
    @todos.filter((todo) -> todo.category is category)

  # Get statistics (demonstrates comprehensions and reduce)
  getStats: ->
    total = @todos.length
    completed = @todos.filter((todo) -> todo.completed).length
    active = total - completed
    overdue = @todos.filter((todo) -> todo.isOverdue).length

    # Count by category
    byCategory = {}
    for todo in @todos
      byCategory[todo.category] ?= 0
      byCategory[todo.category]++

    # Count by priority
    byPriority = {}
    for todo in @todos
      byPriority[todo.priority] ?= 0
      byPriority[todo.priority]++

    {
      total
      completed
      active
      overdue
      completionPercentage: if total > 0 then Math.round((completed / total) * 100) else 0
      byCategory
      byPriority
    }

  # Set filter
  setFilter: (filterType: string, value: string) ->
    @filters[filterType] = value

  # Clear all filters
  clearFilters: ->
    @filters =
      status: 'all'
      category: 'all'
      searchTerm: ''

  # Clear completed todos
  clearCompleted: ->
    @todos = @todos.filter((todo) -> not todo.completed)
    @saveToStorage()

  # Save to localStorage
  saveToStorage: ->
    data =
      todos: @todos.map((todo) -> todo.toJSON())
      filters: @filters
    localStorage.setItem('coffee-todo-store', JSON.stringify(data))

  # Load from localStorage
  loadFromStorage: ->
    data = localStorage.getItem('coffee-todo-store')
    return unless data?

    try
      parsed = JSON.parse(data)
      @todos = parsed.todos.map((json) -> Todo.fromJSON(json))
      @filters = parsed.filters if parsed.filters?
    catch error
      console.error('Error loading from storage:', error)
