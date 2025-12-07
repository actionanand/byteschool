# Main entry point
import './styles/main.scss'
import TodoApp from './app.coffee'

# Initialize app when DOM is ready
document.addEventListener('DOMContentLoaded', ->
  window.app = new TodoApp()
)
