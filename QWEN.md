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

## External Dependencies
- The `parin` game engine is a local package dependency for this project
- The cheatsheet for the parin package can be found at `parin_package/CHEATSHEET.md`
- When working with GUI functionality, be aware that the application depends on the parin engine
- The parin package may require additional setup beyond standard D compilation

## Compilation and Testing
- Always run the compiler to verify changes work correctly: `dmd -c <filename.d>`
- When making changes to formatting or structure, test compilation before and after
- Especially when explicitly asked to test, always verify with the actual compiler
- Use `dmd -c` for quick compilation checks without linking
- For full functionality tests, run with appropriate parameters including dependencies

## AI Development Guidelines
- When explicitly instructed to test, verify actual functionality rather than assuming success
- Always verify that source files execute as expected, especially when they have shebangs allowing direct execution
- Do not make assumptions about file execution mechanisms without verification
- Understand the difference between source code and compiled binaries
- When creating tools that modify code, test thoroughly on sample files before applying to production code
- Respect original formatting styles completely - "minimal spacing" means no spaces around operators
- Verify all claims about functionality before stating them as facts
- Use incremental changes with verification at each step when modifying code
- When fixing broken tools or code, ensure complete understanding of the original requirements
- Avoid defensive responses when errors are identified; instead, immediately work on correcting them
- Recognize when assumptions about file behavior or system responses are incorrect
- Test the actual execution model of files before making claims about executability
- Validate automated tools against known good examples before applying broadly
- Perform thorough error analysis - don't just fix surface symptoms but understand root causes
- Understand data flow between functions and how different variables interact
- Don't assume correct initial states - consider all boundary conditions
- Test boundary conditions thoroughly, especially for array access and index calculations
- Trace execution flow to understand when and why errors occur
- Prioritize correctness over cleverness - simple, working solutions are better than complex ones that fail
- When implementing new features, first understand the existing codebase architecture and integration points
- Research existing documentation and examples before proposing implementation approaches
- Create detailed implementation plans that consider technical constraints and integration requirements
- Propose implementation approaches that align with existing code patterns and conventions
- When adding command-line flags or modes, follow existing patterns in the codebase
- Consider both functional and user experience aspects when designing new features
- When disagreeing with factual claims, always run code to validate rather than arguing without evidence
- Delete emotional validation content and focus on technical accuracy

## Workflow Process
- All AI development work should follow a structured workflow with clear phases
- Create detailed implementation plans before beginning any coding work
- Store all planning documents and reflections in the `ai_thoughts` folder
- Follow a feedback loop process: action plans → implementation → PR → review → clean up passes
- Document all decisions and rationale in planning documents
- Move completed work to appropriate locations in the codebase
- Archive planning documents in the `ai_thoughts` folder for future reference