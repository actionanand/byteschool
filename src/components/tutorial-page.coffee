# Tutorial Page Component - Renders markdown content
# Demonstrates: Async operations, DOM updates, event handling

import MarkdownRenderer from '../utils/markdown-renderer.coffee'

# Import all tutorial markdown files as URLs
import cs01Url from 'url:../tutorials/coffeescript/01-basics.md'
import cs02Url from 'url:../tutorials/coffeescript/02-functions.md'
import cs03Url from 'url:../tutorials/coffeescript/03-classes.md'
import cs04Url from 'url:../tutorials/coffeescript/04-advanced.md'
import cs05Url from 'url:../tutorials/coffeescript/05-app-architecture.md'
import py01Url from 'url:../tutorials/python/py-01-basics.md'
import py02Url from 'url:../tutorials/python/py-02-data-structures.md'
import py03Url from 'url:../tutorials/python/py-03-functions.md'
import py04Url from 'url:../tutorials/python/py-04-classes.md'
import py05Url from 'url:../tutorials/python/py-05-advanced.md'
import py06Url from 'url:../tutorials/python/py-06-database.md'
import py07Url from 'url:../tutorials/python/py-07-file-organization.md'
import py08Url from 'url:../tutorials/python/py-08-frameworks-libraries.md'
import py09Url from 'url:../tutorials/python/py-09-logging.md'

export default class TutorialPage
  constructor: (@container, @router) ->
    @renderer = new MarkdownRenderer()
    @tutorials = {}
    @tutorialUrls = {}
    @loadTutorials()

  loadTutorials: ->
    # Map tutorial names to URLs
    @tutorialUrls = {
      'coffeescript/01-basics': cs01Url
      'coffeescript/02-functions': cs02Url
      'coffeescript/03-classes': cs03Url
      'coffeescript/04-advanced': cs04Url
      'coffeescript/05-app-architecture': cs05Url
      'python/py-01-basics': py01Url
      'python/py-02-data-structures': py02Url
      'python/py-03-functions': py03Url
      'python/py-04-classes': py04Url
      'python/py-05-advanced': py05Url
      'python/py-06-database': py06Url
      'python/py-07-file-organization': py07Url
      'python/py-08-frameworks-libraries': py08Url
      'python/py-09-logging': py09Url
    }

  render: (tutorialName) ->
    # If tutorial already loaded, render it
    if @tutorials[tutorialName]?
      @renderContent(tutorialName)
      return

    # Show loading state
    @container.innerHTML = "
      <div class=\"loading\">
        <p>Loading tutorial...</p>
      </div>
    "

    # Fetch the markdown content
    url = @tutorialUrls[tutorialName]
    if url?
      fetch(url)
        .then((response) => response.text())
        .then((content) =>
          @tutorials[tutorialName] = content
          @renderContent(tutorialName)
        )
        .catch((error) =>
          @container.innerHTML = "
            <div class=\"error\">
              <p>Error loading tutorial: #{error.message}</p>
            </div>
          "
        )
    else
      @container.innerHTML = "
        <div class=\"error\">
          <p>Tutorial not found: #{tutorialName}</p>
        </div>
      "

  renderContent: (tutorialName) ->
    # If tutorial not loaded yet, use placeholder
    unless @tutorials[tutorialName]?
      @container.innerHTML = "
        <div class=\"loading\">
          <p>Loading tutorial...</p>
        </div>
      "
      return

    content = @tutorials[tutorialName]
    html = @renderer.render(content)

    @container.innerHTML = "
      <article class=\"tutorial-content\">
        #{html}
      </article>
    "

    # Trigger Prism syntax highlighting
    if window.Prism?
      window.Prism.highlightAllUnder(@container)
    
    # Attach click handlers to internal navigation links
    @attachLinkHandlers()
  
  attachLinkHandlers: ->
    # Find all links that start with #/
    links = @container.querySelectorAll('a[href^="#/"]')
    console.log("Found #{links.length} internal navigation links")
    links.forEach((link) =>
      link.addEventListener('click', (e) =>
        e.preventDefault()
        href = link.getAttribute('href')
        # Extract path from #/path
        path = href.substring(2)
        console.log("Navigating to: #{path}")
        # Navigate using router
        @router.navigate(path) if @router?
      )
    )
