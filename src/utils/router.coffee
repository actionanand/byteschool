# Router Component - Handles page navigation
# Demonstrates: Classes, closures, event handling

export default class Router
  constructor: (@routes = {}) ->
    @currentPage = null
    @currentParams = {}
    @setupPopState()

  # Register a route
  register: (path, handler) ->
    @routes[path] = handler

  # Navigate to a page
  navigate: (path, params = {}) ->
    console.log("Router.navigate called with path: #{path}")
    @currentPage = path
    @currentParams = params
    
    # Update URL without reload
    queryString = if Object.keys(params).length > 0
      '?' + Object.entries(params)
        .map(([k, v]) -> "#{k}=#{encodeURIComponent(v)}")
        .join('&')
    else
      ''
    
    window.history.pushState({ path, params }, '', "#/#{path}#{queryString}")
    
    # Execute handler
    handler = @routes[path]
    if handler?
      console.log("Executing handler for: #{path}")
      handler(@currentParams)
    else
      console.warn("No route handler found for: #{path}")

  # Handle back/forward buttons
  setupPopState: ->
    window.addEventListener('popstate', (e) =>
      if e.state?.path
        @currentPage = e.state.path
        @currentParams = e.state.params or {}
        handler = @routes[e.state.path]
        handler?(@currentParams)
      else
        # Handle initial hash navigation
        { path, params } = @parseCurrentUrl()
        @currentPage = path
        @currentParams = params
        handler = @routes[path]
        handler?(params)
    )

  # Parse current URL on load
  parseCurrentUrl: ->
    hash = window.location.hash.slice(1)  # Remove #
    
    # Remove leading / if present
    hash = hash.slice(1) if hash.startsWith('/')
    
    [path, ...rest] = hash.split('?')
    path = path or 'home'
    
    # Parse query string
    query = rest.join('?')
    params = {}
    if query
      for param in query.split('&')
        [key, value] = param.split('=')
        params[key] = decodeURIComponent(value) if key
    
    { path, params }

  # Start router
  start: ->
    { path, params } = @parseCurrentUrl()
    handler = @routes[path]
    handler?(params)
    @currentPage = path
    @currentParams = params
