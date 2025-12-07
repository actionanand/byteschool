# Tutorial Page Component - Renders markdown content
# Demonstrates: Async operations, DOM updates, event handling

import MarkdownRenderer from '../utils/markdown-renderer.coffee'

export default class TutorialPage
  constructor: (@container) ->
    @renderer = new MarkdownRenderer()
    @tutorials = {}
    @loadTutorials()

  loadTutorials: ->
    # Import all tutorial markdown files from subdirectories
    tutorialModules = import.meta.glob('../tutorials/**/*.md', { as: 'raw' })
    
    # Load each tutorial
    for path, importFn of tutorialModules
      # Extract folder/filename pattern (e.g., coffeescript/01-basics or python/py-01-basics)
      match = path.match(/\/tutorials\/([^\/]+\/[^\/]+)\.md/)
      if match
        name = match[1]  # e.g., "coffeescript/01-basics" or "python/py-01-basics"
        importFn().then((content) =>
          @tutorials[name] = content
        )

  render: (tutorialName: string) ->
    # If tutorial not loaded yet, use placeholder
    unless @tutorials[tutorialName]?
      @container.innerHTML = '''
        <div class="loading">
          <p>Loading tutorial...</p>
        </div>
      '''
      return

    content = @tutorials[tutorialName]
    html = @renderer.render(content)

    @container.innerHTML = '''
      <article class="tutorial-content">
        #{html}
      </article>
    '''

    # Style code blocks
    @styleCodeBlocks()

  styleCodeBlocks: ->
    codeBlocks = @container.querySelectorAll('code-block')
    codeBlocks.forEach((block) ->
      block.classList.add('highlighted')
    )
