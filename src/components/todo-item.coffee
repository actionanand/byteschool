# Todo Item Component - Showcasing individual todo rendering
# Demonstrates: DOM manipulation, event delegation, class binding

export default class TodoItem
  constructor: (@todo, @onToggle, @onDelete, @onEdit) ->
    @element = null
    @render()

  render: ->
    @element = document.createElement('div')
    @element.className = "todo-item #{@todo.statusBadge()} priority-#{@todo.priority}"
    @element.dataset.todoId = @todo.id

    priorityIcon = switch @todo.priority
      when 'high' then '🔴'
      when 'medium' then '🟡'
      when 'low' then '🟢'
      else '⚪'

    categoryEmoji = switch @todo.category
      when 'work' then '💼'
      when 'personal' then '👤'
      when 'shopping' then '🛍️'
      when 'health' then '🏥'
      else '📝'

    dueDate = if @todo.dueDate
      "<span class=\"due-date\">📅 #{@todo.formattedDate()}</span>"
    else
      ''

    checkedAttr = if @todo.completed then 'checked' else ''
    descriptionHtml = if @todo.description then "<div class=\"todo-description\">#{@todo.description}</div>" else ''

    @element.innerHTML = "
      <div class=\"todo-content\">
        <input type=\"checkbox\" class=\"todo-checkbox\" #{checkedAttr} />
        <div class=\"todo-details\">
          <div class=\"todo-header\">
            <span class=\"priority-indicator\" title=\"Priority: #{@todo.priority}\">#{priorityIcon}</span>
            <span class=\"category-badge\" title=\"#{@todo.category}\">#{categoryEmoji}</span>
            <span class=\"todo-text\">#{@todo.displayTitle()}</span>
            #{dueDate}
          </div>
          #{descriptionHtml}
        </div>
      </div>
      <div class=\"todo-actions\">
        <button class=\"edit-btn\" title=\"Edit\" aria-label=\"Edit todo\">✏️</button>
        <button class=\"delete-btn\" title=\"Delete\" aria-label=\"Delete todo\">🗑️</button>
      </div>
    "

    @attachEventListeners()
    @element

  attachEventListeners: ->
    checkbox = @element.querySelector('.todo-checkbox')
    deleteBtn = @element.querySelector('.delete-btn')
    editBtn = @element.querySelector('.edit-btn')

    checkbox.addEventListener('change', =>
      @onToggle(@todo.id) if @onToggle
    )

    deleteBtn.addEventListener('click', =>
      @onDelete(@todo.id) if @onDelete
    )

    editBtn.addEventListener('click', =>
      @onEdit(@todo.id) if @onEdit
    )

    # Double-click to edit
    @element.addEventListener('dblclick', =>
      @onEdit(@todo.id) if @onEdit
    )

  remove: ->
    @element.remove() if @element

  update: (todo) ->
    @todo = todo
    oldElement = @element
    @render()
    oldElement.replaceWith(@element)
