# Todo List Component - Showcasing list management
# Demonstrates: Array operations, map, filter, event coordination

import TodoItem from './todo-item.coffee'

export default class TodoList
  constructor: (@container, @store, @onUpdated) ->
    @items = {}
    @render()

  render: ->
    todos = @store.getFilteredTodos()

    @container.innerHTML = if todos.length is 0
      '<div class="empty-state"><p>📭 No todos yet. Create one to get started!</p></div>'
    else
      '<div class="todos-container"></div>'

    if todos.length > 0
      todosContainer = @container.querySelector('.todos-container')

      for todo in todos
        item = new TodoItem(
          todo,
          @handleToggle.bind(@),
          @handleDelete.bind(@),
          @handleEdit.bind(@)
        )
        todosContainer.appendChild(item.render())
        @items[todo.id] = item

  handleToggle: (id) ->
    @store.toggleTodo(id)
    @onUpdated?.()

  handleDelete: (id) ->
    # Confirm deletion
    if confirm('Are you sure you want to delete this todo?')
      @store.removeTodo(id)
      delete @items[id]
      @onUpdated?.()

  handleEdit: (id) ->
    todo = @store.getTodo(id)
    return unless todo?

    newTitle = prompt('Edit todo:', todo.title)
    return if newTitle is null or newTitle.trim() is ''

    try
      todo.title = newTitle.trim()
      @store.saveToStorage()
      @onUpdated?.()
    catch error
      alert("Error: #{error.message}")

  update: ->
    @render()
