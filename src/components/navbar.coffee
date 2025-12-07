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
    ]
    @render()
    @attachEventListeners()

  render: ->
    @container.innerHTML = '''
      <nav class="navbar">
        <div class="nav-brand">
          <h1 class="brand-text">📚 ByteSchool</h1>
          <p class="brand-subtitle">Learn CoffeeScript & Python</p>
        </div>
        <div class="nav-sections">
          <div class="nav-section coffee-section">
            <h3 class="section-title">☕ CoffeeScript</h3>
            <ul class="nav-menu" data-section="coffee"></ul>
          </div>
          <div class="nav-section python-section">
            <h3 class="section-title">🐍 Python</h3>
            <ul class="nav-menu" data-section="python"></ul>
          </div>
        </div>
      </nav>
    '''

    # Populate CoffeeScript menu
    coffeeMenu = @container.querySelector('.nav-menu[data-section="coffee"]')
    coffeeItems = @navItems.filter((item) -> item.section is 'coffee')
    for item in coffeeItems
      li = @createNavItem(item)
      coffeeMenu.appendChild(li)
    
    # Populate Python menu
    pythonMenu = @container.querySelector('.nav-menu[data-section="python"]')
    pythonItems = @navItems.filter((item) -> item.section is 'python')
    for item in pythonItems
      li = @createNavItem(item)
      pythonMenu.appendChild(li)
  
  createNavItem: (item) ->
    li = document.createElement('li')
    li.className = 'nav-item'
    li.dataset.page = item.page
    li.innerHTML = """
      <a href="#/#{item.page}" class="nav-link">
        <span class="nav-icon">#{item.icon}</span>
        <span class="nav-label">#{item.label}</span>
      </a>
    """
    li

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

  setActivePage: (page: string) ->
    @container.querySelectorAll('.nav-item').forEach((item) ->
      if item.dataset.page is page
        item.classList.add('active')
      else
        item.classList.remove('active')
    )
