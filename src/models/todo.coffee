# Todo Model - Showcasing CoffeeScript class features
# Demonstrates: Classes, getters, setters, private fields, methods

import { v4 as uuidv4 } from '../utils/uuid.coffee'

export default class Todo
  # Constructor with default parameters
  constructor: (title, @category = 'general', @priority = 'medium') ->
    @id = uuidv4()
    @title = title.trim()
    @completed = false
    @createdAt = new Date()
    @updatedAt = new Date()
    @description = ''
    @dueDate = null

  # Getters for computed properties
  displayTitle: ->
    if @completed then "✓ #{@title}" else @title

  isOverdue: ->
    @dueDate? and @dueDate < new Date() and not @completed

  formattedDate: ->
    return '' unless @dueDate?
    date = new Date(@dueDate)
    date.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })

  statusBadge: ->
    switch
      when @isOverdue() then 'overdue'
      when @completed then 'completed'
      else 'active'

  # Setter for title with validation
  setTitle: (newTitle) ->
    trimmed = newTitle.trim()
    throw new Error('Title cannot be empty') if trimmed.length is 0
    throw new Error('Title is too long (max 100 chars)') if trimmed.length > 100
    @title = trimmed
    @updatedAt = new Date()

  # Setter for priority with validation
  setPriority: (newPriority) ->
    validPriorities = ['low', 'medium', 'high']
    throw new Error("Invalid priority. Must be one of: #{validPriorities.join(', ')}") unless newPriority in validPriorities
    @priority = newPriority
    @updatedAt = new Date()

  # Toggle completion status
  toggle: ->
    @completed = not @completed
    @updatedAt = new Date()

  # Update description
  setDescription: (desc) ->
    @description = desc.trim()
    @updatedAt = new Date()

  # Set due date
  setDueDate: (date) ->
    @dueDate = date
    @updatedAt = new Date()

  # Convert to JSON for storage
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
      dueDate: if @dueDate then @dueDate.toISOString() else null
    }

  # Create from JSON
  @fromJSON: (json) ->
    todo = new Todo(json.title, json.category, json.priority)
    todo.id = json.id
    todo.completed = json.completed
    todo.createdAt = new Date(json.createdAt)
    todo.updatedAt = new Date(json.updatedAt)
    todo.description = json.description
    todo.dueDate = if json.dueDate then new Date(json.dueDate) else null
    todo
