# Kanban File Format Documentation

## Overview
The Kanban application uses a custom text-based file format with a `.kantban` extension to store kanban board data. This format is designed to be human-readable and editable with any text editor.

## File Structure

### Basic Syntax
The file is organized in a hierarchical structure:
```
# Column
## Card Title
- [ ] Item 1
- [x] Item 2
- [ ] Item 3

# Another Column
## Another Card
- [ ] Task 1
- [ ] Task 2
```

### Elements

#### Columns
Columns are represented by lines starting with `# ` (hash followed by space):
```
# Column Name
```

#### Cards
Cards are represented by lines starting with `## ` (double hash followed by space):
```
## Card Title
```

#### Items
Items within cards can have different formats:

1. **Plain format** (no checkbox):
   ```
   - Item text
   ```

2. **Checked format**:
   ```
   - [x] Completed item
   ```

3. **Unchecked format**:
   ```
   - [ ] Pending item
   ```

4. **Flexible spacing formats**:
   ```
   - [x ] Completed item
   - [ x] Completed item
   ```

### Parsing Logic

The parser in `format.d` handles the following:

1. **Column Detection**: Lines starting with `# ` indicate the beginning of a new column
2. **Card Detection**: Lines starting with `## ` indicate the beginning of a new card within the current column
3. **Item Detection**: Lines starting with `- ` indicate items within the current card
4. **Checkbox Parsing**: Items can have various checkbox formats:
   - `- [x]` or `- [X]`: Checked item
   - `- [ ]`: Unchecked item
   - `- [x ]` or `- [ x]`: Flexible checked format
   - `- item`: Plain item (no checkbox)

### Data Structure

The parsed data is stored in a two-dimensional array of `todolist` structures:

```d
struct todolist {
    string title;      // Card title
    string[] items;    // Array of item texts
    bool[] crossed;    // Array indicating if items are checked (true) or unchecked (false)
    void sanitize();   // Ensures crossed array matches items array length
}
```

The outer array represents columns, and each column contains an array of cards.

## Example File

```
# To Do
## Research
- [ ] Investigate new libraries
- [ ] Read documentation
## Implementation
- [ ] Set up project structure
- [x] Create basic components

# In Progress
## Development
- [x] Core functionality
- [ ] UI components

# Done
## Completed
- [x] Project setup
- [x] Initial commit
```

## Usage

### Reading Files
The `openkantban(string where)` function reads and parses a `.kantban` file, returning a `todolist[][]` structure.

### Writing Files
The `savekantban(todolist[][] data, string where)` function writes a `todolist[][]` structure to a `.kantban` file.

## Best Practices

1. **Consistent Naming**: Use descriptive names for columns and cards
2. **Regular Updates**: Keep items checked/unchecked as work progresses
3. **Logical Grouping**: Organize items into logical cards and columns
4. **Clear Descriptions**: Write clear, concise item descriptions