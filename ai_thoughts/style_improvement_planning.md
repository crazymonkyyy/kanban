# Style Improvement and Feature Implementation Planning

## Overview
This document outlines the planned improvements to address style issues and implement new features in the Kanban project.

## Style Issues Identified
1. Inconsistent spacing around operators (some places have spaces, others don't)
2. Tabs used for indentation instead of spaces
3. Inconsistent spacing after keywords like `if`, `while`, `for`
4. The project follows a minimal spacing style guide as mentioned in the Qwen.md file

## Tasks to Implement

### 1. Tool to Print Todo Card by Index
- Create a new tool in the tools directory
- Tool should accept a .kantban file path and x,y coordinates
- Tool should print the specific card at those coordinates
- Should handle out-of-bounds errors gracefully

### 2. Factor Out Clamp Index Function
- Extract the `clampindex` function from app.d
- Create a new utility.d file
- Move the function to the new file with proper imports
- Update app.d to import from utility.d

### 3. Write Fuzzing Unittest for Clamp Function
- Create comprehensive unit tests for the clamp function
- Test edge cases like negative indices, max values, empty arrays
- Add fuzzing tests with random inputs
- Ensure all code paths are covered

## Implementation Approach

### Style Consistency
The project follows a specific style guide mentioned in Qwen.md:
- Tabs for indentation (not spaces)
- Minimal spacing around operators (`x=y+z;` not `x = y + z;`)
- No spaces after keywords (`if(condition)` not `if (condition)`)
- Compact formatting with minimal whitespace

### File Structure
- New tool: `tools/print_card.d`
- New utility file: `utility.d`
- Tests will be added to the utility.d file using D's unittest feature

## Testing Strategy
- Each feature will include proper unit tests
- The clamp function will have extensive fuzzing tests
- The print card tool will be tested with various input files