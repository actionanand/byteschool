# Markdown Renderer - Converts markdown to HTML
# Demonstrates: String manipulation, regular expressions, classes

export default class MarkdownRenderer
  constructor: ->
    @headingRegex = /^(#{1,6})\s+(.+)$/gm
    @boldRegex = /\*\*(.+?)\*\*/g
    @italicRegex = /\*(.+?)\*/g
    @codeRegex = /`(.+?)`/g
    @codeBlockRegex = /^```([a-z]*)\n([\s\S]*?)\n```$/gm
    @listRegex = /^\s*[-*]\s+(.+)$/gm
    @linkRegex = /\[(.+?)\]\((.+?)\)/g
    @lineBreakRegex = /\n\n+/g
    @tableRegex = /^\|(.+)\|$/gm

  render: (markdown) ->
    html = markdown

    # Code blocks first (preserve formatting)
    html = html.replace(@codeBlockRegex, (match, lang, code) =>
      @renderCodeBlock(code, lang)
    )

    # Tables (before other processing)
    html = @renderTables(html)

    # Headings
    html = html.replace(@headingRegex, (match, hashes, content) =>
      level = hashes.length
      "<h#{level}>#{@renderInlineFormatting(content)}</h#{level}>"
    )

    # Lists
    html = @renderLists(html)

    # Paragraphs (before inline formatting)
    html = html.split(@lineBreakRegex)
      .map((paragraph) =>
        if paragraph.match(/^(#{1,6}|```|[-*]|<)/)
          paragraph  # Skip already formatted (headings, code, lists, tables/html)
        else if paragraph.trim()
          @renderInline(paragraph)
        else
          ''
      )
      .join('')

    html

  renderInline: (text) ->
    html = text

    # Order matters: backticks first, then bold, then italic
    html = html.replace(@codeRegex, '<code>$1</code>')
    html = html.replace(@boldRegex, '<strong>$1</strong>')
    html = html.replace(@italicRegex, '<em>$1</em>')
    html = html.replace(@linkRegex, '<a href="$2" target="_blank" rel="noopener">$1</a>')

    "<p>#{html}</p>"

  renderInlineFormatting: (text) ->
    html = text

    # Order matters: backticks first, then bold, then italic
    html = html.replace(@codeRegex, '<code>$1</code>')
    html = html.replace(@boldRegex, '<strong>$1</strong>')
    html = html.replace(@italicRegex, '<em>$1</em>')
    html = html.replace(@linkRegex, '<a href="$2" target="_blank" rel="noopener">$1</a>')

    html

  renderTables: (markdown) ->
    lines = markdown.split('\n')
    result = []
    inTable = false
    tableRows = []

    for line in lines
      if line.match(/^\|/)
        if not inTable
          inTable = true
          tableRows = []
        tableRows.push(line)
      else
        if inTable
          # Process accumulated table
          result.push(@buildTable(tableRows))
          tableRows = []
          inTable = false
        result.push(line)

    # Handle table at end of content
    if inTable and tableRows.length > 0
      result.push(@buildTable(tableRows))

    result.join('\n')

  buildTable: (rows) ->
    return '' unless rows.length >= 2

    # Parse header
    headerCells = rows[0].split('|').filter((cell) -> cell.trim())
    headerHtml = headerCells.map((cell) => 
      "<th>#{@renderInlineFormatting(cell.trim())}</th>"
    ).join('')

    # Skip separator row (row 1)
    # Parse body rows
    bodyHtml = ''
    for i in [2...rows.length]
      cells = rows[i].split('|').filter((cell) -> cell.trim())
      rowHtml = cells.map((cell) => 
        "<td>#{@renderInlineFormatting(cell.trim())}</td>"
      ).join('')
      bodyHtml += "<tr>#{rowHtml}</tr>"

    """
    <table class="markdown-table">
      <thead><tr>#{headerHtml}</tr></thead>
      <tbody>#{bodyHtml}</tbody>
    </table>
    """

  renderLists: (markdown) ->
    lines = markdown.split('\n')
    result = []
    inList = false
    listItems = []

    for line in lines
      if line.match(/^\s*[-*]\s+/)
        if not inList
          inList = true
          listItems = []
        # Extract list item content
        content = line.replace(/^\s*[-*]\s+/, '')
        listItems.push(content)
      else
        if inList
          # Process accumulated list
          itemsHtml = listItems.map((item) => 
            "<li>#{@renderInlineFormatting(item)}</li>"
          ).join('')
          result.push("<ul>#{itemsHtml}</ul>")
          listItems = []
          inList = false
        result.push(line)

    # Handle list at end of content
    if inList and listItems.length > 0
      itemsHtml = listItems.map((item) => 
        "<li>#{@renderInlineFormatting(item)}</li>"
      ).join('')
      result.push("<ul>#{itemsHtml}</ul>")

    result.join('\n')

  renderCodeBlock: (code, lang = 'coffeescript') ->
    # Map common language aliases
    langMap = {
      'coffee': 'coffeescript'
      'js': 'javascript'
      'py': 'python'
      'sh': 'bash'
    }
    
    normalizedLang = langMap[lang] or lang
    escaped = @escapeHtml(code)
    
    # Use global Prism if available (loaded via CDN)
    if window.Prism?
      try
        grammar = window.Prism.languages[normalizedLang]
        highlighted = if grammar then window.Prism.highlight(code, grammar, normalizedLang) else escaped
      catch
        highlighted = escaped
    else
      highlighted = escaped
    
    """
    <pre class="code-block language-#{normalizedLang}"><code class="language-#{normalizedLang}">#{highlighted}</code></pre>
    """



  escapeHtml: (text) ->
    div = document.createElement('div')
    div.textContent = text
    div.innerHTML

  # Convert markdown file content to HTML
  parseMarkdownFile: (content) ->
    lines = content.split('\n')
    sections = []
    currentSection = { title: '', content: '' }

    for line in lines
      if line.match(/^#/)
        if currentSection.title
          sections.push(currentSection)
        heading = line.match(/^(#+)\s+(.+)/)?[2] or ''
        currentSection = { title: heading, content: '' }
      else
        currentSection.content += line + '\n'

    sections.push(currentSection) if currentSection.title
    sections
