# Input Form Component - Showcasing event handling and DOM manipulation
# Demonstrates: Event listeners, DOM creation, string interpolation

export default class TodoInputForm
  constructor: (@container, @onSubmit) ->
    @render()
    @attachEventListeners()

  render: ->
    @container.innerHTML = '''
      <form class="input-form" id="todo-form">
        <div class="input-group">
          <input
            type="text"
            class="todo-input"
            id="todo-input"
            placeholder="What needs to be done today?"
            autocomplete="off"
          />
          <select class="category-select" id="category-select">
            <option value="general">General</option>
            <option value="work">Work</option>
            <option value="personal">Personal</option>
            <option value="shopping">Shopping</option>
            <option value="health">Health</option>
          </select>
          <select class="priority-select" id="priority-select">
            <option value="low">Low</option>
            <option value="medium" selected>Medium</option>
            <option value="high">High</option>
          </select>
          <button type="submit" class="add-button" title="Add todo (Enter)">
            <span class="icon">+</span>
            Add
          </button>
        </div>
      </form>
    '''

  attachEventListeners: ->
    form = document.getElementById('todo-form')
    input = document.getElementById('todo-input')
    categorySelect = document.getElementById('category-select')
    prioritySelect = document.getElementById('priority-select')

    # Handle form submission
    form.addEventListener('submit', (e) =>
      e.preventDefault()
      title = input.value.trim()
      category = categorySelect.value
      priority = prioritySelect.value

      return if title.length is 0

      @onSubmit?(title, category, priority)
      input.value = ''
      input.focus()
    )

    # Auto-focus input on load
    input.focus()
