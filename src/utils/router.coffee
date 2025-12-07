# Router Component - Handles page navigation
# Demonstrates: Classes, closures, event handling

export default class Router
  constructor: (@routes = {}) ->
    @currentPage = null
    @currentParams = {}
    @setupPopState()

  # Register a route
  register: (path: string, handler) ->
    @routes[path] = handler

  # Navigate to a page
  navigate: (path: string, params = {}) ->
    @currentPage = path
    @currentParams = params
    
    # Update URL without reload
    queryString = if Object.keys(params).length > 0
      '?' + Object.entries(params)
        .map(([k, v]) -> "#{k}=#{encodeURIComponent(v)}")
        .join('&')
    else
      ''
    
    window.history.pushState({ path, params }, '', "/##{path}#{queryString}")
    
    # Execute handler
    handler = @routes[path]
    handler?(@currentParams)

  # Handle back/forward buttons
  setupPopState: ->
    window.addEventListener('popstate', (e) =>
      if e.state?.path
        handler = @routes[e.state.path]
        handler?(e.state.params)
    )

  # Parse current URL on load
  parseCurrentUrl: ->
    hash = window.location.hash.slice(1)
    query = window.location.search.slice(1)
    
    [path, ...rest] = hash.split('?')
    path = path or 'home'
    
    params = {}
    if query
      for param in query.split('&')
        [key, value] = param.split('=')
        params[key] = decodeURIComponent(value)
    
    { path, params }

  # Start router
  start: ->
    { path, params } = @parseCurrentUrl()
    handler = @routes[path]
    handler?(params)
    @currentPage = path
    @currentParams = params
