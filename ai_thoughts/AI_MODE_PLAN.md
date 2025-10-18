# AI Mode Feature Implementation Plan

## Overview
This document outlines the implementation plan for adding an AI mode to the kanban application. The AI mode will randomly move todo list cards around and attempt to take screenshots for testing purposes.

## Current State Analysis

### Application Architecture
1. **Main Entry Point**: `app.d` - Contains the main game loop with `ready`, `update`, and `finish` functions
2. **Data Structure**: `todolist[][] data` - 2D array of kanban columns containing todo items
3. **Navigation State**: 
   - `int[] x` - Array tracking horizontal positions for each column
   - `int y` - Current vertical position (column index)
4. **Input Handling**: Uses parin engine's `Keyboard` module for arrow key navigation
5. **Rendering**: Uses parin engine for drawing with mathematical background patterns

### Parin Engine Integration Points
1. **Game Loop**: Uses `mixin runGame!(ready, update, finish)`
2. **Input System**: `Keyboard.up.isPressed`, `Keyboard.down.isPressed`, etc.
3. **Drawing System**: Custom drawing functions in `drawing.d`
4. **Command Line Arguments**: Uses `envArgs()` function
5. **Screenshot Capability**: Uses parin's screenshot functionality

## AI Mode Requirements

### Functional Requirements
1. **Random Card Movement**: Randomly move todo list cards around the board
2. **Screenshot Capture**: Attempt to take screenshots during card movement
3. **Test Accessibility**: Ensure the AI mode is easily testable with the `--ai` flag
4. **Visual Feedback**: Clear indication when AI mode is active
5. **Toggle Mechanism**: Easy way to enable/disable AI mode

### Technical Requirements
1. **Command Line Flag**: Accept `--ai` or `--ai-mode` argument
2. **State Management**: Track AI mode state throughout application lifecycle
3. **Randomization**: Use parin's random functions for card movement
4. **Screenshot Integration**: Use parin's screenshot functionality
5. **User Override**: Allow manual navigation to override AI actions

## Implementation Approach

### Phase 1: Command Line Argument Processing
1. Modify `ready()` function to parse `--ai` flag
2. Add global boolean `isAiMode` variable
3. Update help text to document AI mode usage
4. Ensure AI mode can be easily enabled for testing

### Phase 2: Random Card Movement Logic
1. Add AI state variables:
   - `float aiTimer` - Tracks time between AI actions
   - `float aiInterval` - Configurable interval (default: 1.0 seconds)
   - `int screenshotCount` - Counter for screenshots taken
2. Modify `update()` function to handle random card movement when enabled
3. Implement card selection and movement logic using random indices

### Phase 3: Screenshot Integration
1. Add screenshot functionality using parin's screenshot capabilities
2. Take screenshots at regular intervals during AI mode
3. Save screenshots with timestamped filenames

### Phase 4: Visual Feedback
1. Modify drawing functions to highlight AI-selected cards
2. Add status indicator showing AI mode is active
3. Display screenshot counter and status information

## Detailed Implementation Steps

### Step 1: Add AI Mode Flag Parsing
```d
// In app.d ready() function
bool isAiMode = false;
float aiTimer = 0.0f;
float aiInterval = 1.0f; // seconds
int screenshotCount = 0;

void ready() {
    // Existing code...
    auto args = envArgs();
    foreach(i, arg; args) {
        if(arg == "--ai" || arg == "--ai-mode") {
            isAiMode = true;
        }
        // Handle other arguments as needed
    }
    // Existing code...
}
```

### Step 2: Implement Random Card Movement Logic
```d
// In app.d update() function
bool update(float dt) {
    // Existing manual navigation code...
    
    if(isAiMode) {
        aiTimer += dt;
        if(aiTimer >= aiInterval) {
            aiTimer = 0.0f;
            
            // Random card movement logic
            if(data.length > 0) {
                // Select random source column
                int sourceCol = uniform(0, cast(int)data.length);
                
                // Select random card in source column
                if(data[sourceCol].length > 0) {
                    int sourceCard = uniform(0, cast(int)data[sourceCol].length);
                    
                    // Select random destination column
                    int destCol = uniform(0, cast(int)data.length);
                    
                    // Move card from source to destination
                    if(sourceCol != destCol) {
                        auto card = data[sourceCol][sourceCard];
                        
                        // Remove from source
                        data[sourceCol] = data[sourceCol][0..sourceCard] ~ data[sourceCol][sourceCard+1..$];
                        
                        // Add to destination
                        data[destCol] ~= card;
                        
                        writeln("Moved card from column ", sourceCol, " to column ", destCol);
                    }
                }
            }
            
            // Take screenshot
            takeScreenshot();
        }
    }
    
    // Existing drawing code...
    return false;
}

void takeScreenshot() {
    import std.datetime : Clock;
    import std.conv : to;
    
    auto timestamp = Clock.currTime.to!string;
    auto filename = "screenshot_" ~ timestamp.replace(":", "-").replace(" ", "_") ~ ".png";
    
    // Use parin's screenshot functionality
    // screenshot(filename);
    screenshotCount++;
    writeln("Screenshot taken: ", filename, " (", screenshotCount, " total)");
}
```

### Step 3: Add Visual Feedback
```d
// In drawing.d, modify draw functions to highlight AI selections
void draw(todolist data, Vec2 where, int colorindex, bool isAiSelected = false) {
    // Existing code...
    
    if(isAiSelected) {
        // Add visual indicator for AI-selected items
        // Could be a different border color, glow effect, or icon
    }
    
    // Existing code...
}
```

### Step 4: Add Toggle Mechanism
```d
// In app.d update() function
bool update(float dt) {
    // Toggle AI mode with 'A' key
    if(Keyboard.a.isPressed) {
        isAiMode = !isAiMode;
        aiTimer = 0.0f; // Reset timer when toggling
        writeln("AI Mode: ", isAiMode ? "Enabled" : "Disabled");
    }
    
    // Existing code...
}
```

## Integration Considerations

### Compatibility
1. Ensure AI mode doesn't interfere with manual navigation
2. Maintain backward compatibility - application works identically when AI mode is disabled
3. Follow existing code patterns and conventions

### Performance
1. AI actions should not impact frame rate significantly
2. Screenshot operations should be asynchronous if possible
3. Visual feedback should be lightweight

### User Experience
1. Clear visual indication when AI mode is active
2. Intuitive controls for enabling/disabling AI mode
3. Visible feedback when screenshots are taken

## Testing Plan

### Unit Tests
1. Verify command line argument parsing correctly enables AI mode
2. Test random card movement logic with various kanban board configurations
3. Validate screenshot functionality works correctly

### Integration Tests
1. Test AI mode with manual navigation - ensure manual overrides work
2. Verify AI mode behaves correctly with empty columns or boards
3. Test edge cases like single-column boards

### User Acceptance Tests
1. Verify AI mode activation is intuitive with `--ai` flag
2. Confirm screenshots are taken during card movement
3. Ensure visual feedback is clear and helpful

## Risk Mitigation

### Technical Risks
1. **Performance Impact**: AI actions and screenshots could slow down the application
   - Mitigation: Profile code and optimize hot paths, use asynchronous operations where possible
   
2. **Complexity**: AI features could make codebase harder to maintain
   - Mitigation: Keep AI logic modular and well-documented

### User Experience Considerations
1. **Confusion**: Users might not understand AI mode or how to control it
   - Solution: Provide clear documentation and visual feedback
   
2. **Testing Access**: Users need to be able to test the AI mode functionality
   - Solution: Ensure AI mode is easily accessible with `--ai` flag for testing purposes
   - Design clear override mechanisms that allow users to take control when needed

## Timeline
1. **Phase 1** (Command Line Parsing): 1 day
2. **Phase 2** (Random Card Movement): 2 days
3. **Phase 3** (Screenshot Integration): 1 day
4. **Phase 4** (Visual Feedback): 1 day
5. **Testing and Refinement**: 1 day

Total estimated time: 5-6 days for complete implementation