# Qwen Code Context for Kanban Project

## Project Overview

This is a Kanban board application written in the D programming language. The application uses a custom text-based file format with a `.kantban` extension to store kanban board data. The project aims to be a "deeply nested, unix-porn friendly, with a dumb file format todo list."

### Key Features
- Terminal-based Kanban board viewer and editor
- Custom `.kantban` file format for storing board data
- Arrow key navigation through columns and items
- Visual rendering using the Parin game engine
- Support for checked/unchecked items

### Project Structure
```
├── app.d              # Main application entry point
├── format.d           # File format parsing and serialization
├── configs.d          # Configuration and font handling
├── drawing.d          # Visual rendering functions
├── tools/             # Utility tools for working with .kantban files
├── syntaxtest/        # Syntax test files for validating concepts
├── docs/              # Documentation files
├── ai_thoughts/       # AI planning and workflow documentation
└── parin_package/     # Local Parin game engine dependency
```

## Main Application Components

### app.d - Main Application
The main entry point that sets up the Kanban board viewer using the Parin game engine. It handles:
- Command-line argument parsing for specifying the .kantban file to open
- Keyboard navigation (arrow keys) for moving between columns and items
- Rendering the Kanban board using functions from the drawing module
- Managing the application state (current column `y` and item positions `x[]`)

### format.d - File Format Handling
Handles parsing and serialization of the custom `.kantban` file format:
- `todolist` struct: Represents a card with title, items, and crossed (checked) status
- `openkantban()`: Parses a .kantban file into a `todolist[][]` data structure
- `savekantban()`: Serializes a `todolist[][]` structure back to a .kantban file

The file format uses a hierarchical structure:
```
# Column
## Card Title
- [ ] Unchecked item
- [x] Checked item
```

### configs.d - Configuration System
Manages application configuration including:
- Font configuration (title and text fonts)
- Color scheme management using Solarized-Dark palette
- Font loading and downloading from Google Fonts
- Path resolution for font files

### drawing.d - Visual Rendering
Implements the visual rendering of the Kanban board using the Parin game engine:
- Initializes fonts and color palettes
- Draws cards with mathematical background patterns
- Handles visual positioning and layout
- Implements item rendering with strikethrough for checked items

## Key Technologies

### D Programming Language
The application is written in D, a systems programming language with C-like syntax. Key D features used:
- Garbage collection for memory management
- Templates for generic programming
- Uniform Function Call Syntax (UFCS)
- Built-in unit testing capabilities
- Rich standard library (std.*) modules

### Parin Game Engine
A local package dependency that provides:
- Cross-platform windowing and rendering
- Input handling (keyboard, mouse)
- Audio playback
- Asset management
- Game loop infrastructure

The engine uses a mixin-based approach for setting up the main application loop.

## Building and Running

### Prerequisites
- D compiler (dmd recommended)
- Parin game engine dependencies
- Internet connection for font downloading (optional)

### Running the Application
```bash
# Run the main application
./app.d [filename.kantban]

# Run with a specific file
./app.d TODO.kantban
```

### Compiling Individual Files
```bash
# Quick compilation check
dmd -c filename.d

# Compile and run
dmd -run filename.d
```

### Using Tools
The tools directory contains utility programs:
```bash
# Run a tool
./tools/toolname.d [arguments]
```

## Development Workflow

### Code Style
Follows a minimal spacing style guide:
- Tabs for indentation (not spaces)
- Minimal spacing around operators (`x=y+z;` not `x = y + z;`)
- No spaces after keywords (`if(condition)` not `if (condition)`)
- Compact formatting with minimal whitespace

### AI Development Process
The project uses a structured AI development workflow documented in `ai_thoughts/`:
1. Planning Phase - Requirement analysis and design documentation
2. Implementation Phase - Coding with incremental verification
3. Review Phase - Self-review and documentation updates
4. Pull Request Phase - PR preparation and submission
5. Clean Up Phase - Post-merge cleanup and knowledge transfer

### Testing
- Unit tests integrated throughout the codebase
- Syntax tests in `syntaxtest/` directory for validating concepts
- Manual testing through direct execution of .d files

## File Format Specification

### Structure
The .kantban format uses a simple hierarchical structure:
- Columns start with `# `
- Cards start with `## `
- Items start with `- `
- Checkboxes can be `[ ]` (unchecked) or `[x]` (checked)

### Example
```
# To Do
## Research
- [ ] Investigate new libraries
- [x] Read documentation
## Implementation
- [ ] Set up project structure
- [x] Create basic components

# Done
## Completed
- [x] Project setup
- [x] Initial commit
```

## Configuration System

### Fonts
- Default fonts: Noto Sans
- Automatic font downloading from Google Fonts
- Local font storage in `~/.local/share/fonts/`

### Colors
- Solarized-Dark color scheme by default
- 16-color palette system
- Mathematical background patterns for visual appeal

## Tools and Utilities

### Available Tools
- `corrupt.d` - Randomly corrupts text files for testing
- `randomtoggle.d` - Randomly toggles completion status of items
- `validate.d` - Validates kanban file format and structure
- `fix_formatting.d` - Fixes whitespace formatting according to style guide

### Usage
Tools can be run directly:
```bash
./tools/randomtoggle.d file.kantban
./tools/validate.d file.kantban
./tools/corrupt.d file.txt 10 corrupted.txt
```

## Development Resources

### Documentation
- `docs/file_format.md` - Complete specification of .kantban file format
- `docs/configuration.md` - Documentation of configuration system
- `parin_package/CHEATSHEET.md` - Parin engine reference
- `ai_thoughts/` - AI planning documents and workflow documentation

### Testing and Validation
- Syntax tests in `syntaxtest/` directory
- Unit tests integrated throughout the codebase
- Manual testing through direct execution

## Common Development Tasks

### Adding a New Feature
1. Create a planning document in `ai_thoughts/`
2. Follow the standardized workflow process
3. Implement with incremental verification
4. Document the feature in appropriate documentation files
5. Archive planning documents in `ai_thoughts/`

### Fixing Formatting Issues
1. Use the `fix_formatting.d` tool for automatic fixes
2. Follow the style guide for manual adjustments
3. Verify with `dmd -c` compilation checks

### Adding New Tools
1. Create new .d files in the `tools/` directory
2. Follow the shebang pattern for direct execution
3. Use existing functions from format.d for file operations
4. Add usage instructions and examples

## Troubleshooting

### Common Issues
1. **Font Loading Failures**: Check internet connection and font paths
2. **Compilation Errors**: Verify D compiler installation and dependencies
3. **Runtime Errors**: Check file permissions and format validity

### Debugging Tips
1. Use `dmd -c` for quick compilation checks
2. Run tools with sample files to isolate issues
3. Check parin engine documentation for rendering problems
4. Use syntax tests to validate assumptions about behavior