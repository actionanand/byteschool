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

  render: (markdown: string) ->
    html = markdown

    # Code blocks first (preserve formatting)
    html = html.replace(@codeBlockRegex, (match, lang, code) =>
      @renderCodeBlock(code, lang)
    )

    # Headings
    html = html.replace(@headingRegex, (match, hashes, content) =>
      level = hashes.length
      "<h#{level}>#{@escapeHtml(content)}</h#{level}>"
    )

    # Paragraphs (before inline formatting)
    html = html.split(@lineBreakRegex)
      .map((paragraph) =>
        if paragraph.match(/^(#{1,6}|```|[-*]|<)/)
          paragraph  # Skip already formatted
        else
          @renderInline(paragraph)
      )
      .join('')

    # Unordered lists
    html = html.replace(/(<li>.*?<\/li>)/s, (match) ->
      "<ul>#{match}</ul>"
    )

    html

  renderInline: (text: string) ->
    html = text

    # Order matters: backticks first, then bold, then italic
    html = html.replace(@codeRegex, '<code>$1</code>')
    html = html.replace(@boldRegex, '<strong>$1</strong>')
    html = html.replace(@italicRegex, '<em>$1</em>')
    html = html.replace(@linkRegex, '<a href="$2" target="_blank">$1</a>')

    "<p>#{html}</p>"

  renderCodeBlock: (code: string, lang: string = 'coffeescript') ->
    escaped = @escapeHtml(code)
    highlighted = @highlightCode(escaped, lang)
    """
    <pre class="code-block language-#{lang}">
      <code>#{highlighted}</code>
    </pre>
    """

  highlightCode: (code: string, lang: string) ->
    # Basic syntax highlighting
    switch lang
      when 'coffeescript', 'coffee'
        @highlightCoffeeScript(code)
      when 'javascript', 'js'
        @highlightJavaScript(code)
      else
        code

  highlightCoffeeScript: (code: string) ->
    # Keywords
    keywords = ['class', 'constructor', 'if', 'else', 'for', 'in', 'while', 'return', 'new', 'this', '@', 'when', 'is', 'isnt', 'and', 'or', 'not', 'true', 'false', 'null', 'undefined']
    
    html = code
    for keyword in keywords
      pattern = new RegExp("\\b#{keyword}\\b", 'g')
      html = html.replace(pattern, "<span class=\"kw\">#{keyword}</span>")

    # Strings
    html = html.replace(/(["'])([^"']*)\1/g, "<span class=\"str\">$&</span>")

    # Numbers
    html = html.replace(/\b(\d+)\b/g, "<span class=\"num\">$1</span>")

    # Comments
    html = html.replace(/(#[^\n]*)/g, "<span class=\"cmt\">$1</span>")

    html

  highlightJavaScript: (code: string) ->
    # Similar to CoffeeScript but with JS keywords
    keywords = ['class', 'constructor', 'if', 'else', 'for', 'while', 'return', 'new', 'this', 'function', 'const', 'let', 'var', 'true', 'false', 'null', 'undefined', 'async', 'await', 'import', 'export']
    
    html = code
    for keyword in keywords
      pattern = new RegExp("\\b#{keyword}\\b", 'g')
      html = html.replace(pattern, "<span class=\"kw\">#{keyword}</span>")

    # Strings
    html = html.replace(/(["'`])([^"'`]*)\1/g, "<span class=\"str\">$&</span>")

    # Numbers
    html = html.replace(/\b(\d+)\b/g, "<span class=\"num\">$1</span>")

    # Comments
    html = html.replace(/(\/\/[^\n]*)/g, "<span class=\"cmt\">$1</span>")
    html = html.replace(/(\/\*[\s\S]*?\*\/)/g, "<span class=\"cmt\">$1</span>")

    html

  escapeHtml: (text: string) ->
    div = document.createElement('div')
    div.textContent = text
    div.innerHTML

  # Convert markdown file content to HTML
  parseMarkdownFile: (content: string) ->
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
