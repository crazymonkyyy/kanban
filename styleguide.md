# D Language Style Guide for Kanban Project (Original Human Format)

This style guide documents the original whitespace and formatting conventions used in this project, based on analysis of the git history before AI formatting changes.

## Indentation
- Use tabs for indentation (not spaces)
- Each level of nesting uses one additional tab

## Braces and Curly Brackets
- Opening brace `{` goes on the same line as the function/conditional declaration
- Closing brace `}` goes on its own line at the same indentation level
- Example:
```d
void function() {
	tabs here
}
```

## Spacing Around Operators
- Minimal spacing around operators: no spaces around `=`, `+`, `-`, `*`, `/`, `==`, etc.
- No space after commas in function calls and parameter lists
- Example: `x=y+z;` instead of `x = y + z;`

## Spacing Around Keywords
- No extra space after keywords like `if`, `for`, `foreach`, `while`, `switch`, etc.
- Example: `if(condition)` instead of `if (condition)`

## Enum Formatting
- No spaces around the `=` in enum declarations
- Example: `enum name=value;` instead of `enum name = value;`

## Function Declarations
- No spaces around parameter commas
- No space after the return type and before the function name
- Example: `int function(int x,int y)`

## Arrow Functions
- No spaces around the arrow operator `=>`
- Example: `auto func(int x)=>x*2;`

## Line Breaks
- Keep related code on the same line when possible
- Break lines only when necessary for readability

## Comments
- Single-line comments with `//` have no space after the slashes
- Multi-line comments are formatted minimally
- Comments are placed inline or on separate lines as needed

## Imports
- One import statement per line
- No blank line required after import section

## Array and Range Operations
- No spaces around range operators `..`
- Example: `array[0..length]` instead of `array[0 .. length]`

## Conditional and Loop Statements
- No space between the keyword and the opening parenthesis
- No space after semicolons in for loops: `for(int i=0;i<10;i++)`

## Function Calls
- No space after commas in function arguments
- Example: `function(arg1,arg2,arg3)` instead of `function(arg1, arg2, arg3)`

## Overall Style
- Compact formatting with minimal whitespace
- Consistent use of tabs for indentation
- Less verbose spacing compared to AI-generated formatting
- More concise and dense code layout

## Git Commit Style
- When committing changes made by AI tools, use "qwen ai" as the commit author
- Keep track of instructions and document them in the style guide
- Use descriptive commit messages that explain the purpose of the changes

## Single Source of Truth Principle
- Avoid duplicating struct definitions across files (e.g., the `todolist` struct should be defined once in format.d and imported where needed)
- Reuse existing functions from format.d rather than reimplementing parsing and saving logic in tools
- Import and use existing functionality instead of creating duplicate implementations
- Maintain one canonical implementation of core data structures and operations

## Error Handling Philosophy
- Use minimal error handling approach similar to the original application
- Prefer simple assertions for critical failures rather than extensive validation
- Let errors propagate naturally rather than implementing comprehensive error reporting systems
- Avoid creating complex error categorization systems (ValidationResult classes, etc.)
- Focus on core functionality rather than extensive error checking and reporting
- Maintain consistency with the minimalistic error handling approach of the original code
- Implement fallback strategies instead of complex error reporting (e.g., try alternative approaches rather than detailed error messages)
- Follow the style demonstrated in the findfont function as a model for error handling approach

## Git and Pull Request Style
- When making changes to align with the style guide, commit changes with descriptive messages
- Use "qwen ai" as the commit author when making AI-assisted changes
- Test all tools and functionality before creating pull requests
- Include documentation of changes made in pull request descriptions
- When creating pull requests, title them descriptively to explain the changes made
- Reference the style guide in pull request descriptions when applying style changes