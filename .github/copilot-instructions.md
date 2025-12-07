# Coffee TODO

> A beautiful hobby project showcasing CoffeeScript concepts

## 🎯 Project Overview

This is a sophisticated todo application built entirely with **CoffeeScript 2.7+**, demonstrating modern CoffeeScript language features and best practices. The project uses **Vite** as the build tool for fast development and optimized production builds.

## ✨ Key Features

### Functionality
- ✅ Create, read, update, delete (CRUD) todos
- 📂 Organize todos by category (work, personal, shopping, health)
- 🎯 Priority levels (high, medium, low)
- 🔍 Search and filter todos
- 📊 Real-time statistics and progress tracking
- 🔔 Due dates and overdue indicators
- 💾 Persistent storage with localStorage
- ⌨️ Keyboard shortcuts (Ctrl+N, Ctrl+K, ?)
- 🎨 Beautiful dark theme with smooth animations

### Design
- 🌈 Modern gradient UI with purple and cyan accents
- 📱 Fully responsive (mobile, tablet, desktop)
- ♿ Accessible with semantic HTML and ARIA labels
- 🎭 Smooth transitions and animations
- 📊 Live statistics sidebar

## 🎓 CoffeeScript Concepts Demonstrated

This project showcases advanced CoffeeScript patterns:

| Concept | Usage | File |
|---------|-------|------|
| **Classes & Inheritance** | ES6 classes with getters/setters | `models/todo.coffee` |
| **Arrow Functions** | Lexical `this` binding | Throughout |
| **Destructuring** | Parameter and object destructuring | `models/store.coffee` |
| **String Interpolation** | Template literals for clean strings | `components/` |
| **Array Comprehensions** | Filtering and mapping with comprehensions | `models/store.coffee` |
| **Conditional Assignment** | Existential operators `?` and `?.` | Throughout |
| **Getters/Setters** | Property accessors with validation | `models/todo.coffee` |
| **Spread Operator** | Array and object spreading | `models/store.coffee` |
| **Async/Await** | Modern async patterns | `main.coffee` |
| **Module System** | ES6 imports/exports | All files |
| **Higher-Order Functions** | Callbacks and event handlers | `components/` |
| **Closures** | Encapsulation and scope | `models/store.coffee` |
| **Default Parameters** | Functions with sensible defaults | Throughout |

## 🚀 Quick Start

### Prerequisites
- **Node.js**: >= 18.0.0 and < 23.0.0
- **npm**: v8+

### Installation

```bash
# Clone and navigate to project
cd coffee-todo

# Install dependencies
npm install

# Start development server
npm run dev
```

The app will automatically open at `http://localhost:3000`

### Development Commands

```bash
# Start dev server with hot reload
npm run dev

# Build for production
npm run build

# Preview production build locally
npm run preview

# Lint CoffeeScript files
npm run lint

# Type check (TypeScript checking)
npm run type-check
```

## 📁 Project Structure

```
coffee-todo/
├── src/
│   ├── main.coffee                # Entry point
│   ├── app.coffee                 # Main app orchestration
│   ├── models/
│   │   ├── todo.coffee            # Todo data model
│   │   └── store.coffee           # State management
│   ├── components/
│   │   ├── input-form.coffee      # Form component
│   │   ├── todo-item.coffee       # Individual todo renderer
│   │   ├── todo-list.coffee       # List management
│   │   └── stats.coffee           # Statistics display
│   └── styles/
│       └── main.scss              # All styles (SCSS)
├── index.html                     # HTML entry
├── vite.config.js                 # Vite configuration
├── tsconfig.json                  # TypeScript config
├── coffeelint.json               # CoffeeScript linter config
├── package.json                   # Dependencies & scripts
└── README.md                      # This file
```

## 🎹 Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| <kbd>Ctrl</kbd>/<kbd>Cmd</kbd> + <kbd>N</kbd> | Focus input field |
| <kbd>Ctrl</kbd>/<kbd>Cmd</kbd> + <kbd>K</kbd> | Clear search |
| <kbd>Enter</kbd> | Add new todo |
| <kbd>Double-click</kbd> | Edit todo |
| <kbd>?</kbd> | Show help |

## 🎨 Design Highlights

- **Color Scheme**: Dark purple theme (#8b5cf6) with cyan accents (#06b6d4)
- **Typography**: System fonts for optimal rendering
- **Spacing**: Consistent 8px grid system
- **Animations**: Smooth transitions (150ms-350ms)
- **Responsive**: Mobile-first approach, breakpoints at 768px and 1024px

## 📊 Stats & Metrics

The application tracks:
- Total todos
- Completed todos
- Active todos
- Overdue todos
- Completion percentage
- Breakdown by category
- Breakdown by priority

## 🔧 Technology Stack

| Tech | Purpose | Version |
|------|---------|---------|
| **CoffeeScript** | Primary language | ^2.7.0 |
| **Vite** | Build tool & dev server | ^5.0.0 |
| **Sass/SCSS** | Styling | ^1.69.0 |
| **TypeScript** | Type checking | ^5.3.0 |

## 🌐 Browser Support

- ✅ Chrome/Chromium 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Edge 90+

## 🛠️ Development Notes

### Code Style
- **Indentation**: 2 spaces
- **Naming**: camelCase for variables/functions, PascalCase for classes
- **Comments**: Inline comments with context

### Architecture
- **MVC Pattern**: Models (store, todo), Views (components), Controllers (app)
- **Event-Driven**: Components communicate via callbacks
- **Reactive**: UI updates automatically on state changes
- **Modular**: Each component is self-contained

### Performance
- Vite's fast HMR (Hot Module Replacement)
- Production build optimizations
- localStorage for instant data persistence
- Debounced search (300ms)

## 📝 License

MIT - Feel free to use this project as a learning resource or template!

---

**Built with ☕ CoffeeScript • Powered by Vite**

*A beautiful example of how CoffeeScript's elegant syntax can build modern web applications.*
