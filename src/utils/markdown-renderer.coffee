# Markdown Renderer - Converts markdown to HTML with proper formatting
# Demonstrates: String manipulation, array processing, recursive rendering

export default class MarkdownRenderer
  constructor: ->
    # Placeholder patterns to protect content during processing
    @codeBlockPlaceholder = '___CODE_BLOCK___'
    @tablePlaceholder = '___TABLE___'

  render: (markdown) ->
    if !markdown or typeof markdown != 'string'
      return ''
    
    html = markdown
    codeBlocks = []
    tables = []
    
    # Step 1: Extract and protect code blocks (must be first!)
    # Use multiline regex to match code blocks properly
    html = html.replace(/```(\w*)\n([\s\S]*?)\n```/g, (match, lang, code) =>
      placeholder = "#{@codeBlockPlaceholder}#{codeBlocks.length}___"
      codeBlocks.push(@renderCodeBlock(code, lang or 'plaintext'))
      placeholder
    )
    
    # Step 2: Extract and protect tables
    lines = html.split('\n')
    processedLines = []
    i = 0
    while i < lines.length
      line = lines[i]
      if line.trim().startsWith('|') and line.trim().endsWith('|')
        # Collect table lines
        tableLines = [line]
        i++
        # Get separator
        if i < lines.length and lines[i].match(/^\|[\s\-|:]+\|$/)
          tableLines.push(lines[i])
          i++
        # Get body rows
        while i < lines.length and lines[i].trim().startsWith('|') and lines[i].trim().endsWith('|')
          tableLines.push(lines[i])
          i++
        # Process table
        placeholder = "#{@tablePlaceholder}#{tables.length}___"
        tables.push(@renderTable(tableLines))
        processedLines.push(placeholder)
      else
        processedLines.push(line)
        i++
    
    html = processedLines.join('\n')
    
    # Step 3: Process headings
    html = html.replace(/^(#{1,6})\s+(.+)$/gm, (match, hashes, content) =>
      level = hashes.length
      "<h#{level}>#{@processInlineElements(content)}</h#{level}>"
    )
    
    # Step 4: Process lists
    html = @processLists(html)
    
    # Step 5: Process paragraphs - split by blank lines and wrap non-formatted content
    paragraphs = html.split(/\n\n+/)
    processedParagraphs = paragraphs.map((para) =>
      lines = para.split('\n')
      # If all lines start with formatting, keep as is, otherwise wrap in <p>
      if lines.length == 1 and !lines[0].match(/^(<h|<ul|<table|<pre|___PLACEHOLDER___)/)
        "<p>#{@processInlineElements(lines[0])}</p>"
      else
        para
    )
    
    html = processedParagraphs.join('\n\n')
    
    # Step 6: Restore code blocks
    for i in [0...codeBlocks.length]
      placeholder = "#{@codeBlockPlaceholder}#{i}___"
      html = html.replace(new RegExp(placeholder, 'g'), codeBlocks[i])
    
    # Step 7: Restore tables
    for i in [0...tables.length]
      placeholder = "#{@tablePlaceholder}#{i}___"
      html = html.replace(new RegExp(placeholder, 'g'), tables[i])
    
    html

  renderTable: (tableLines) ->
    if tableLines.length < 3
      return ''
    
    # Parse header row
    headerCells = tableLines[0]
      .split('|')
      .slice(1, -1)
      .map((cell) => cell.trim())
      .filter((cell) => cell.length > 0)
    
    headerHtml = headerCells
      .map((cell) => "<th>#{@processInlineElements(cell)}</th>")
      .join('')
    
    # Parse body rows (skip separator at index 1)
    bodyHtml = ''
    for i in [2...tableLines.length]
      cells = tableLines[i]
        .split('|')
        .slice(1, -1)
        .map((cell) => cell.trim())
        .filter((cell) => cell.length > 0)
      
      rowHtml = cells
        .map((cell) => "<td>#{@processInlineElements(cell)}</td>")
        .join('')
      bodyHtml += "<tr>#{rowHtml}</tr>"
    
    """
    <table class="markdown-table">
      <thead><tr>#{headerHtml}</tr></thead>
      <tbody>#{bodyHtml}</tbody>
    </table>
    """

  processLists: (html) ->
    lines = html.split('\n')
    result = []
    i = 0
    
    while i < lines.length
      line = lines[i]
      match = line.match(/^(\s*)[-*]\s+(.+)$/)
      
      if match
        baseIndent = match[1].length
        listItems = []
        
        # Collect all list items at this indent level
        while i < lines.length
          currentMatch = lines[i].match(/^(\s*)[-*]\s+(.+)$/)
          if currentMatch and currentMatch[1].length == baseIndent
            content = currentMatch[2]
            listItems.push("<li>#{@processInlineElements(content)}</li>")
            i++
          else
            break
        
        result.push("<ul>#{listItems.join('')}</ul>")
      else
        result.push(line)
        i++
    
    result.join('\n')

  renderCodeBlock: (code, lang = 'plaintext') ->
    # Language aliases
    langMap = {
      'coffee': 'coffeescript'
      'js': 'javascript'
      'py': 'python'
      'sh': 'bash'
      'txt': 'plaintext'
    }
    
    normalizedLang = langMap[lang] or lang or 'plaintext'
    trimmedCode = code.trim()
    
    # Escape HTML entities
    escapedCode = @escapeHtml(trimmedCode)
    
    # Use Prism for syntax highlighting if available
    highlighted = if window.Prism?
      try
        grammar = window.Prism.languages[normalizedLang]
        if grammar
          window.Prism.highlight(trimmedCode, grammar, normalizedLang)
        else
          escapedCode
      catch
        escapedCode
    else
      escapedCode
    
    """
    <pre class="code-block language-#{normalizedLang}"><code class="language-#{normalizedLang}">#{highlighted}</code></pre>
    """

  processInlineElements: (text) ->
    return '' if !text or typeof text != 'string'
    
    # Process in order: inline code, bold, italic, links
    text = text.replace(/`([^`]+)`/g, '<code>$1</code>')
    text = text.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>')
    text = text.replace(/\*([^*]+)\*/g, '<em>$1</em>')
    text = text.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2" target="_blank" rel="noopener">$1</a>')
    
    text

  escapeHtml: (text) ->
    text
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#039;')

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

