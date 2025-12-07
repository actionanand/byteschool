# Main App Component - Orchestrates all components with routing
# Demonstrates: Component composition, event handling, routing, app architecture

import TodoStore from './models/store.coffee'
import TodoInputForm from './components/input-form.coffee'
import TodoList from './components/todo-list.coffee'
import StatsComponent from './components/stats.coffee'
import Router from './utils/router.coffee'
import NavigationBar from './components/navbar.coffee'
import TutorialPage from './components/tutorial-page.coffee'

export default class TodoApp
  constructor: ->
    @store = new TodoStore()
    @setupDOM()
    @setupRouter()
    @initializeComponents()
    @setupEventListeners()
    @setupKeyboardShortcuts()

  setupDOM: ->
    app = document.getElementById('app')
    app.innerHTML = "
      <div class=\"app-container\">
        <div class=\"navbar-container\"></div>

        <main class=\"app-main\">
          <div class=\"app-content\">
            <div class=\"page-container\"></div>
          </div>
        </main>

        <footer class=\"app-footer\">
          <p>📚 <strong>ByteSchool</strong> - Learn CoffeeScript & Python</p>
          <p class=\"keyboard-hint\">💡 Tip: Press <kbd>?</kbd> for keyboard shortcuts</p>
        </footer>
      </div>
    "

  setupRouter: ->
    @router = new Router()
    
    # Home page - Todo App
    @router.register('home', (params) =>
      @showTodoApp()
      @updateNavigation()
    )
    
    # CoffeeScript tutorial pages
    @router.register('basics', (params) =>
      @showTutorial('coffeescript/01-basics')
      @updateNavigation()
    )
    
    @router.register('functions', (params) =>
      @showTutorial('coffeescript/02-functions')
      @updateNavigation()
    )
    
    @router.register('classes', (params) =>
      @showTutorial('coffeescript/03-classes')
      @updateNavigation()
    )
    
    @router.register('advanced', (params) =>
      @showTutorial('coffeescript/04-advanced')
      @updateNavigation()
    )
    
    @router.register('app-architecture', (params) =>
      @showTutorial('coffeescript/05-app-architecture')
      @updateNavigation()
    )
    
    # Python tutorial pages
    @router.register('py-basics', (params) =>
      @showTutorial('python/py-01-basics')
      @updateNavigation()
    )
    
    @router.register('py-data-structures', (params) =>
      @showTutorial('python/py-02-data-structures')
      @updateNavigation()
    )
    
    @router.register('py-functions', (params) =>
      @showTutorial('python/py-03-functions')
      @updateNavigation()
    )
    
    @router.register('py-classes', (params) =>
      @showTutorial('python/py-04-classes')
      @updateNavigation()
    )
    
    @router.register('py-advanced', (params) =>
      @showTutorial('python/py-05-advanced')
      @updateNavigation()
    )
    
    @router.register('py-database', (params) =>
      @showTutorial('python/py-06-database')
      @updateNavigation()
    )
    
    @router.register('py-file-organization', (params) =>
      @showTutorial('python/py-07-file-organization')
      @updateNavigation()
    )
    
    @router.register('py-frameworks-libraries', (params) =>
      @showTutorial('python/py-08-frameworks-libraries')
      @updateNavigation()
    )
    
    @router.register('py-logging', (params) =>
      @showTutorial('python/py-09-logging')
      @updateNavigation()
    )

  initializeComponents: ->
    # Navbar
    navbarContainer = document.querySelector('.navbar-container')
    @navbar = new NavigationBar(navbarContainer, @router)
    
    # Tutorial page container
    pageContainer = document.querySelector('.page-container')
    @tutorialPage = new TutorialPage(pageContainer)
    
    # Start router after components initialized
    @router.start()

  setupEventListeners: ->
    # Router handles all page navigation
    pass

  showTodoApp: ->
    pageContainer = document.querySelector('.page-container')
    
    # Clear previous content
    pageContainer.innerHTML = "
      <div class=\"todo-page\">
        <header class=\"app-header\">
          <div class=\"header-content\">
            <h1>☕ Coffee TODO</h1>
            <p class=\"subtitle\">A beautiful task manager built with CoffeeScript</p>
          </div>
        </header>

        <div class=\"input-section\"></div>

        <div class=\"control-panel\">
          <div class=\"filter-group\">
            <button class=\"filter-btn active\" data-filter=\"all\">All</button>
            <button class=\"filter-btn\" data-filter=\"active\">Active</button>
            <button class=\"filter-btn\" data-filter=\"completed\">Completed</button>
          </div>
          <div class=\"category-filter\">
            <select id=\"category-filter\" class=\"category-dropdown\">
              <option value=\"all\">All Categories</option>
              <option value=\"general\">General</option>
              <option value=\"work\">Work</option>
              <option value=\"personal\">Personal</option>
              <option value=\"shopping\">Shopping</option>
              <option value=\"health\">Health</option>
            </select>
          </div>
          <input type=\"text\" id=\"search-input\" class=\"search-box\" placeholder=\"🔍 Search todos...\" />
          <button id=\"clear-btn\" class=\"clear-btn\" title=\"Clear completed todos\">Clear Done</button>
        </div>

        <div class=\"content-wrapper\">
          <div class=\"todos-section\">
            <div class=\"list-container\"></div>
          </div>
          <aside class=\"stats-sidebar\">
            <div class=\"stats-container\"></div>
          </aside>
        </div>
      </div>
    "

    # Initialize todo components
    inputSection = pageContainer.querySelector('.input-section')
    listContainer = pageContainer.querySelector('.list-container')
    statsContainer = pageContainer.querySelector('.stats-container')

    @inputForm = new TodoInputForm(inputSection, @handleAddTodo.bind(@))
    @todoList = new TodoList(listContainer, @store, @handleListUpdated.bind(@))
    @todoList.render()
    @stats = new StatsComponent(statsContainer, @store)
    @stats.render()

    # Attach control panel listeners
    @setupTodoEventListeners()

  showTutorial: (tutorialName) ->
    # Make sure tutorialPage is initialized
    unless @tutorialPage?
      pageContainer = document.querySelector('.page-container')
      @tutorialPage = new TutorialPage(pageContainer)
    
    @tutorialPage.render(tutorialName)

  setupTodoEventListeners: ->
    pageContainer = document.querySelector('.page-container')
    
    # Filter buttons
    filterBtns = pageContainer.querySelectorAll('.filter-btn')
    filterBtns.forEach((btn) =>
      btn.addEventListener('click', =>
        filterBtns.forEach((b) -> b.classList.remove('active'))
        btn.classList.add('active')
        filter = btn.dataset.filter
        @store.setFilter('status', filter)
        @handleListUpdated()
      )
    )

    # Category filter
    categorySelect = pageContainer.querySelector('#category-filter')
    categorySelect?.addEventListener('change', =>
      @store.setFilter('category', categorySelect.value)
      @handleListUpdated()
    )

    # Search input (debounced)
    searchInput = pageContainer.querySelector('#search-input')
    searchTimeout = null
    searchInput?.addEventListener('input', (e) =>
      clearTimeout(searchTimeout)
      searchTimeout = setTimeout(=>
        @store.setFilter('searchTerm', e.target.value)
        @handleListUpdated()
      , 300)
    )

    # Clear completed button
    clearBtn = pageContainer.querySelector('#clear-btn')
    clearBtn?.addEventListener('click', =>
      if confirm('Clear all completed todos?')
        @store.clearCompleted()
        @handleListUpdated()
    )

  updateNavigation: ->
    currentPage = @router.currentPage or 'home'
    @navbar.setActivePage(currentPage)

  setupKeyboardShortcuts: ->
    document.addEventListener('keydown', (e) =>
      # Ctrl/Cmd + N for new todo
      if (e.ctrlKey or e.metaKey) and e.key is 'n'
        e.preventDefault()
        input = document.getElementById('todo-input')
        input?.focus()

      # Ctrl/Cmd + K for clear search
      if (e.ctrlKey or e.metaKey) and e.key is 'k'
        e.preventDefault()
        document.getElementById('search-input').value = ''
        @store.setFilter('searchTerm', '')
        @handleListUpdated()

      # ? for help
      if e.key is '?'
        @showKeyboardHelp()
    )

  showKeyboardHelp: ->
    shortcuts = "⌨️ Keyboard Shortcuts\n\nCtrl/Cmd + N - Focus input (New todo)\nCtrl/Cmd + K - Clear search\nEnter - Add todo\nDouble-click - Edit todo\n? - Show this help\n\nAvailable at any time!"
    alert(shortcuts)

  handleAddTodo: (title, category, priority) ->
    @store.addTodo(title, category, priority)
    @handleListUpdated()

  handleListUpdated: ->
    @todoList.update()
    @stats.update()
