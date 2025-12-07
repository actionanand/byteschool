# Coffee Learn - CoffeeScript & Python Learning Platform

A beautiful, interactive learning platform featuring a todo application and comprehensive tutorials for both CoffeeScript and Python, built with CoffeeScript and Vite.

## Features

### Todo Application
- ✨ Beautiful, modern UI with smooth animations
- 📝 Create, edit, and delete todos
- ✅ Mark todos as complete/incomplete
- 🏷️ Organize todos with categories (work, personal, shopping, health)
- 🔍 Filter todos by status and category
- 💾 Persistent storage with localStorage
- ⌨️ Keyboard shortcuts for productivity
- 📊 Statistics and progress tracking

### Learning Platform
- 📚 **CoffeeScript Tutorials**: 5 comprehensive lessons covering basics to advanced architecture
- 🐍 **Python Tutorials**: 7 in-depth lessons from fundamentals to database operations
- 🎨 Markdown-based content with syntax highlighting
- 🧭 Easy navigation between topics
- 💡 Code examples and best practices

## Project Structure

```
coffee-learn/
├── src/
│   ├── main.coffee              # Entry point
│   ├── app.coffee               # Main app component with routing
│   ├── models/
│   │   ├── todo.coffee          # Todo model with getters/setters
│   │   └── store.coffee         # State management
│   ├── components/
│   │   ├── navbar.coffee        # Navigation with CoffeeScript & Python sections
│   │   ├── tutorial-page.coffee # Tutorial content renderer
│   │   ├── todo-list.coffee     # Todo list component
│   │   ├── todo-item.coffee     # Individual todo item
│   │   ├── input-form.coffee    # Todo input form
│   │   └── stats.coffee         # Statistics display
│   ├── utils/
│   │   ├── router.coffee        # Hash-based routing
│   │   └── markdown-renderer.coffee  # Markdown to HTML converter
│   ├── tutorials/
│   │   ├── coffeescript/        # CoffeeScript tutorials
│   │   │   ├── 01-basics.md         # CoffeeScript basics
│   │   │   ├── 02-functions.md      # Functions & callbacks
│   │   │   ├── 03-classes.md        # Classes & OOP
│   │   │   ├── 04-advanced.md       # Advanced patterns
│   │   │   └── 05-app-architecture.md  # App architecture
│   │   └── python/              # Python tutorials
│   │       ├── py-01-basics.md      # Python 2 vs 3, pip, basics, pprint
│   │       ├── py-02-data-structures.md  # Lists, dicts, tuples, sets
│   │       ├── py-03-functions.md   # Functions, decorators, lambdas
│   │       ├── py-04-classes.md     # Classes, __init__, @property, __slots__
│   │       ├── py-05-advanced.md    # Context managers, generators
│   │       ├── py-06-database.md    # SQLite, ORM patterns
│   │       ├── py-07-file-organization.md  # Modules, packages, imports
│   │       ├── py-08-frameworks-libraries.md  # Popular frameworks & libraries
│   │       └── py-09-logging.md     # Logging, custom loggers, filters
│   └── styles/
│       └── main.scss            # Complete application styles
├── index.html
├── vite.config.js
├── package.json
└── tsconfig.json
```

## Tutorial Topics

### CoffeeScript
1. **Basics**: Data types, variables, operators, comments
2. **Functions**: Arrow functions, callbacks, higher-order functions
3. **Classes**: @symbol, constructors, methods, inheritance
4. **Advanced**: Comprehensions, destructuring, existential operators
5. **Architecture**: Deep dive into the todo app structure

### Python
1. **Basics**: Python 2 vs 3, pip, miniconda, basic syntax, pprint, format strings
2. **Data Structures**: Lists, dictionaries, tuples, sets, comprehensions
3. **Functions**: Parameters, *args/**kwargs, decorators, lambdas
4. **Classes**: `__init__` patterns, `self`, `@property`, `@staticmethod`, `__slots__`
5. **Advanced**: Context managers, generators, type hints, itertools, Python 3.5+ features
6. **Database**: SQLite operations, ORM patterns, connection management
7. **File Organization**: Modules, packages, imports, project structure, relative imports (`.` explained)
8. **Frameworks & Libraries**: Flask, Django, FastAPI, Pandas, NumPy, SQLAlchemy, Pytest, Celery
9. **Logging**: Logger setup, custom filters, log levels (debug/info/warning/error/critical), file handlers

## CoffeeScript Concepts Demonstrated

- **Classes & Inheritance**: Object-oriented design with ES6 classes
- **Arrow Functions**: Lexical `this` binding
- **Destructuring**: Parameter and object destructuring
- **String Interpolation**: Template literals for clean string formatting
- **Comprehensions**: Array and object comprehensions
- **Conditional Assignment**: Existential operators and conditional logic
- **Getters/Setters**: Property accessors for encapsulation
- **Spread Operator**: Array and object spreading
- **Async/Await**: Modern async patterns
- **Module System**: ES6 imports/exports

## Node Version

This project requires Node.js **>=18.0.0** and **<23.0.0**

## Development

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview

# Lint CoffeeScript files
npm run lint
```

## Technologies

- **CoffeeScript 2.7+**: Modern CoffeeScript with ES6 support
- **Vite 5+**: Fast build tool and dev server
- **Sass/SCSS**: Powerful CSS preprocessing
- **ES6 Modules**: Modern JavaScript module system

## Browser Support

- Chrome/Chromium 90+
- Firefox 88+
- Safari 14+
- Edge 90+

## License

MIT
