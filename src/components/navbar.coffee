# Navigation Bar Component - Route navigation
# Demonstrates: DOM manipulation, event delegation, active state management

export default class NavigationBar
  constructor: (@container, @router) ->
    @navItems = [
      # CoffeeScript section
      { page: 'home', label: '🏠 App', icon: '☕', section: 'coffee' }
      { page: 'basics', label: '📚 Basics', icon: '🔤', section: 'coffee' }
      { page: 'functions', label: '⚙️ Functions', icon: '🔧', section: 'coffee' }
      { page: 'classes', label: '📦 Classes', icon: '🎁', section: 'coffee' }
      { page: 'advanced', label: '🚀 Advanced', icon: '⚡', section: 'coffee' }
      { page: 'app-architecture', label: '🏗️ App', icon: '🏢', section: 'coffee' }
      # Python section
      { page: 'py-basics', label: '🐍 Basics', icon: '📖', section: 'python' }
      { page: 'py-data-structures', label: '📊 Data', icon: '🗂️', section: 'python' }
      { page: 'py-functions', label: '⚡ Functions', icon: '🔨', section: 'python' }
      { page: 'py-classes', label: '🎯 Classes', icon: '📦', section: 'python' }
      { page: 'py-advanced', label: '🚀 Advanced', icon: '✨', section: 'python' }
      { page: 'py-database', label: '💾 Database', icon: '🗄️', section: 'python' }
      { page: 'py-file-organization', label: '📁 Files', icon: '🗂️', section: 'python' }
      { page: 'py-frameworks-libraries', label: '🔧 Frameworks', icon: '📚', section: 'python' }
      { page: 'py-logging', label: '📝 Logging', icon: '📋', section: 'python' }
    ]
    @render()
    @attachEventListeners()

  render: ->
    # Build coffee items HTML
    coffeeItemsHtml = ''
    coffeeItems = @navItems.filter((item) -> item.section is 'coffee')
    for item in coffeeItems
      coffeeItemsHtml += "<li class=\"nav-item\" data-page=\"#{item.page}\"><a href=\"#/#{item.page}\" class=\"nav-link\"><span class=\"nav-icon\">#{item.icon}</span><span class=\"nav-label\">#{item.label}</span></a></li>"

    # Build python items HTML
    pythonItemsHtml = ''
    pythonItems = @navItems.filter((item) -> item.section is 'python')
    for item in pythonItems
      pythonItemsHtml += "<li class=\"nav-item\" data-page=\"#{item.page}\"><a href=\"#/#{item.page}\" class=\"nav-link\"><span class=\"nav-icon\">#{item.icon}</span><span class=\"nav-label\">#{item.label}</span></a></li>"

    # Render navbar
    navHtml = "<nav class=\"navbar\">" +
      "<div class=\"nav-brand\">" +
      "<h1 class=\"brand-text\">📚 ByteSchool</h1>" +
      "<p class=\"brand-subtitle\">Learn CoffeeScript & Python</p>" +
      "</div>" +
      "<div class=\"nav-sections\">" +
      "<div class=\"nav-section coffee-section\">" +
      "<h3 class=\"section-title\">☕ CoffeeScript Tutorials</h3>" +
      "<ul class=\"nav-menu\" data-section=\"coffee\">#{coffeeItemsHtml}</ul>" +
      "</div>" +
      "<div class=\"nav-section python-section\">" +
      "<h3 class=\"section-title\">🐍 Python Tutorials</h3>" +
      "<ul class=\"nav-menu\" data-section=\"python\">#{pythonItemsHtml}</ul>" +
      "</div>" +
      "</div>" +
      "</nav>"
    
    @container.innerHTML = navHtml

  attachEventListeners: ->
    menus = @container.querySelectorAll('.nav-menu')
    menus.forEach((menu) =>
      menu.addEventListener('click', (e) =>
        link = e.target.closest('.nav-link')
        return unless link?

        e.preventDefault()
        item = link.closest('.nav-item')
        page = item.dataset.page

        # Remove active from all
        @container.querySelectorAll('.nav-item').forEach((el) ->
          el.classList.remove('active')
        )

        # Set active on clicked
        item.classList.add('active')

        # Navigate
        @router.navigate(page)
      )
    )

  setActivePage: (page) ->
    @container.querySelectorAll('.nav-item').forEach((item) ->
      if item.dataset.page is page
        item.classList.add('active')
      else
        item.classList.remove('active')
    )
