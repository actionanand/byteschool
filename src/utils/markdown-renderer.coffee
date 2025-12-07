# Markdown Renderer - Converts markdown to HTML with Prism syntax highlighting
# Improved table handling with support for empty cells

export default class MarkdownRenderer
  constructor: ->
    # Initialize renderer

  render: (markdown) ->
    if !markdown or typeof markdown != 'string'
      return ''
    
    lines = markdown.split('\n')
    html = []
    i = 0
    
    while i < lines.length
      line = lines[i]
      
      # Code blocks (highest priority)
      if line.startsWith('```')
        lang = line.substring(3).trim()
        code = []
        i++
        while i < lines.length and !lines[i].startsWith('```')
          code.push(lines[i])
          i++
        i++  # Skip closing ```
        html.push(@renderCodeBlock(code.join('\n'), lang))
        continue
      
      # Horizontal rule
      if line.match(/^-{3,}$/) or line.match(/^\*{3,}$/) or line.match(/^_{3,}$/)
        html.push('<hr />')
        i++
        continue
      
      # Headings
      if line.match(/^#{1,6}\s+/)
        match = line.match(/^(#{1,6})\s+(.+)$/)
        if match
          level = match[1].length
          content = match[2]
          html.push("<h#{level}>#{@processInlineElements(content)}</h#{level}>")
          i++
          continue
      
      # Tables - improved handling
      if line.trim().startsWith('|') and line.trim().endsWith('|')
        tableLines = []
        # Collect all table lines
        while i < lines.length and lines[i].trim().startsWith('|') and lines[i].trim().endsWith('|')
          tableLines.push(lines[i])
          i++
        
        if tableLines.length >= 2
          html.push(@renderTable(tableLines))
        continue
      
      # Unordered lists
      if line.match(/^[\s]*[-*]\s+/)
        listLines = []
        while i < lines.length and (lines[i].match(/^[\s]*[-*]\s+/) or lines[i].trim() == '')
          if lines[i].trim() != ''
            listLines.push(lines[i])
          i++
        if listLines.length > 0
          html.push(@renderList(listLines))
        continue
      
      # Empty lines
      if line.trim() == ''
        i++
        continue
      
      # Paragraphs
      paragraphLines = []
      while i < lines.length and lines[i].trim() != '' and !lines[i].match(/^#{1,6}\s+/) and !lines[i].startsWith('```') and !lines[i].match(/^[\s]*[-*]\s+/) and !(lines[i].trim().startsWith('|') and lines[i].trim().endsWith('|'))
        paragraphLines.push(lines[i])
        i++
      
      if paragraphLines.length > 0
        content = paragraphLines.join('\n')
        html.push("<p>#{@processInlineElements(content)}</p>")
    
    html.join('\n')

  renderCodeBlock: (code, lang = 'plaintext') ->
    # Language aliases
    langMap = {
      'coffee': 'coffeescript'
      'js': 'javascript'
      'py': 'python'
      'sh': 'bash'
      'txt': 'plaintext'
      '': 'plaintext'
    }
    
    # Ensure lang is not empty
    lang = 'plaintext' if !lang or lang.trim() == ''
    
    normalizedLang = langMap[lang] or lang or 'plaintext'
    trimmedCode = code.trim()
    
    # Escape HTML entities
    escapedCode = @escapeHtml(trimmedCode)
    
    # Use Prism for syntax highlighting if available
    highlighted = if window.Prism? and window.Prism.languages[normalizedLang]?
      try
        grammar = window.Prism.languages[normalizedLang]
        window.Prism.highlight(trimmedCode, grammar, normalizedLang)
      catch
        escapedCode
    else
      escapedCode
    
    """
    <pre class="code-block language-#{normalizedLang}"><code class="language-#{normalizedLang}">#{highlighted}</code></pre>
    """

  renderTable: (tableLines) ->
    if tableLines.length < 2
      return ''
    
    # Parse header row - keep empty cells
    headerCells = @parseTableRow(tableLines[0])
    
    if headerCells.length == 0
      return ''
    
    headerHtml = headerCells
      .map((cell) => "<th>#{@processInlineElements(cell.trim())}</th>")
      .join('')
    
    # Check if second line is a separator (contains only |, -, :, and whitespace)
    startBody = 1
    if tableLines.length > 1 and tableLines[1].match(/^\|[\s\-:|]+\|$/)
      # Line 1 is separator, body starts at line 2
      startBody = 2
    
    # Parse body rows - keep empty cells for proper table structure
    bodyHtml = ''
    for i in [startBody...tableLines.length]
      line = tableLines[i]
      
      # Skip separator lines in body (shouldn't happen but just in case)
      continue if line.match(/^\|[\s\-:|]+\|$/)
      
      cells = @parseTableRow(line)
      
      # Pad cells to match header length
      while cells.length < headerCells.length
        cells.push('')
      
      rowHtml = cells
        .slice(0, headerCells.length)
        .map((cell) => "<td>#{@processInlineElements(cell.trim())}</td>")
        .join('')
      bodyHtml += "<tr>#{rowHtml}</tr>"
    
    """
    <table class="markdown-table">
      <thead><tr>#{headerHtml}</tr></thead>
      <tbody>#{bodyHtml}</tbody>
    </table>
    """
  
  parseTableRow: (line) ->
    # Split by pipe, remove first and last empty parts
    cells = line.split('|').slice(1, -1)
    # Return cells as-is, preserving empty ones
    cells

  renderList: (listLines) ->
    items = []
    for line in listLines
      match = line.match(/^[\s]*[-*]\s+(.+)$/)
      if match
        content = match[1]
        items.push("<li>#{@processInlineElements(content)}</li>")
    
    if items.length > 0
      "<ul>#{items.join('')}</ul>"
    else
      ''

  processInlineElements: (text) ->
    return '' if !text or typeof text != 'string'
    
    # Process in correct order to avoid conflicts
    
    # 1. Inline code (backticks) - protect this first
    text = text.replace(/`([^`]+)`/g, '<code>$1</code>')
    
    # 2. Bold text - handle both ** and __
    text = text.replace(/\*\*([^\*\*]+)\*\*/g, '<strong>$1</strong>')
    text = text.replace(/__([^__]+)__/g, '<strong>$1</strong>')
    
    # 3. Italic text - handle both * and _
    text = text.replace(/\*([^\*]+)\*/g, '<em>$1</em>')
    text = text.replace(/_([^_]+)_/g, '<em>$1</em>')
    
    # 4. Links - handle internal (#/) vs external links differently
    text = text.replace(/\[([^\]]+)\]\(([^)]+)\)/g, (match, linkText, url) =>
      if url.startsWith('#/')
        # Internal hash link - no target blank
        "<a href=\"#{url}\">#{linkText}</a>"
      else
        # External link - open in new tab
        "<a href=\"#{url}\" target=\"_blank\" rel=\"noopener\">#{linkText}</a>"
    )
    
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
