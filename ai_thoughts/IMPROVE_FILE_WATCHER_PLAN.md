# Action Plan: Improve File Watcher in odrun and odrun2

## Objective
Improve the incomplete file watcher implementation in odrun and odrun2 to provide better file watching capabilities.

## Current State Analysis

### odrun.d
- Uses `DirectoryWatcher` from `arsd.core`
- Watches a single file for changes
- Has basic functionality but lacks sophistication
- Uses polling mechanism with 500ms interval
- Has commented out debug output
- Has some hardcoded paths and assumptions

### odrun2.d
- Similar to odrun but with slight variations
- Also uses `DirectoryWatcher` from `arsd.core`
- Has incomplete implementation with commented out sections
- Uses different polling approach
- Has some filtering logic for .d files

### Common Issues
1. **Incomplete Implementation**: Both files have commented out sections and TODO comments
2. **Hardcoded Paths**: Assumptions about file locations and directory structure
3. **Basic Polling**: Simple polling mechanism without sophisticated event handling
4. **Limited Filtering**: Basic file filtering without comprehensive pattern matching
5. **Debug Output**: Commented out debug information that could be useful
6. **Error Handling**: Minimal error handling and recovery mechanisms
7. **Performance**: Polling-based approach may not be optimal for large directories

## Improvement Goals

### Functional Improvements
1. **Robust File Watching**: Implement comprehensive file watching with proper event handling
2. **Flexible Configuration**: Allow configuration of watched directories and file patterns
3. **Enhanced Filtering**: Implement sophisticated file filtering with regex patterns
4. **Improved Error Handling**: Add comprehensive error handling and recovery mechanisms
5. **Performance Optimization**: Optimize polling intervals and event processing
6. **Debug Capabilities**: Enable configurable debug output for troubleshooting
7. **Cross-Platform Support**: Ensure compatibility across different operating systems

### Technical Improvements
1. **Modular Design**: Refactor into reusable modules with clear interfaces
2. **Configurable Intervals**: Allow adjustment of polling intervals based on use case
3. **Event Queue**: Implement event queue for handling multiple file changes
4. **Throttling**: Add throttling to prevent excessive rebuilds on rapid file changes
5. **Graceful Degradation**: Handle cases where file watching fails gracefully
6. **Memory Management**: Optimize memory usage for long-running file watchers
7. **Thread Safety**: Ensure thread-safe operation in multi-threaded environments

## Implementation Approach

### Phase 1: Analysis and Design (1 day)
1. **Requirements Gathering**: Document all use cases and requirements
2. **Architecture Design**: Design modular architecture with clear interfaces
3. **API Design**: Define clean APIs for file watching functionality
4. **Configuration System**: Design configuration system for flexibility
5. **Error Handling Strategy**: Define comprehensive error handling approach

### Phase 2: Core Implementation (2 days)
1. **File Watcher Module**: Implement core file watching functionality
2. **Event Processing**: Implement event queue and processing logic
3. **Filtering System**: Implement sophisticated file filtering with patterns
4. **Configuration System**: Implement configuration loading and validation
5. **Error Handling**: Implement comprehensive error handling and recovery

### Phase 3: Integration and Testing (1 day)
1. **Integration with odrun**: Integrate improved file watcher with odrun (directly on main branch, NO BRANCHES)
2. **Integration with odrun2**: Integrate improved file watcher with odrun2 (directly on main branch, NO BRANCHES)
3. **Unit Testing**: Write comprehensive unit tests for all functionality
4. **Integration Testing**: Test integration with existing codebase
5. **Performance Testing**: Test performance with various file change scenarios

### Phase 4: Documentation and Deployment (0.5 days)
1. **Documentation**: Document usage and configuration options
2. **Examples**: Create example configurations and usage scenarios
3. **Deployment**: Deploy improved file watcher to production (direct commits to main branch)
4. **Monitoring**: Set up monitoring for file watcher performance

## Detailed Implementation Steps

### Step 1: File Watcher Module
```d
// Enhanced file watcher with improved event handling
module filewatcher;

import std;
import arsd.core;

class EnhancedDirectoryWatcher {
    private DirectoryWatcher watcher;
    private string[] watchedPatterns;
    private Duration pollInterval;
    private bool isWatching;
    
    this(string path, string[] patterns, Duration interval = dur!"msecs"(500)) {
        watchedPatterns = patterns;
        pollInterval = interval;
        // Initialize directory watcher with improved configuration
        watcher = new DirectoryWatcher(FilePath(path), "", true, &onFileChange);
    }
    
    private void onFileChange(FilePath path, DirectoryOp op) {
        // Enhanced file change handling with pattern matching
        if (matchesPattern(path.path)) {
            // Process file change event
            processFileChange(path, op);
        }
    }
    
    private bool matchesPattern(string filename) {
        // Implement sophisticated pattern matching
        foreach(pattern; watchedPatterns) {
            if (filename.match(pattern)) {
                return true;
            }
        }
        return false;
    }
    
    private void processFileChange(FilePath path, DirectoryOp op) {
        // Process file change with throttling and queuing
        // Implementation details...
    }
    
    public void start() {
        isWatching = true;
        // Start watching with improved error handling
        try {
            getThisThreadEventLoop().run(() => !isWatching);
        } catch (Exception e) {
            // Handle file watching errors gracefully
            writeln("File watching error: ", e.msg);
        }
    }
    
    public void stop() {
        isWatching = false;
        // Clean up resources
        watcher.destroy();
    }
}
```

### Step 2: Configuration System
```d
// Configuration system for file watcher
module filewatcher.config;

struct FileWatcherConfig {
    string[] watchPaths;
    string[] filePatterns;
    Duration pollInterval;
    bool enableDebug;
    int maxRetries;
    
    static FileWatcherConfig load(string configFile) {
        // Load configuration from file or use defaults
        // Implementation details...
        return FileWatcherConfig();
    }
}
```

### Step 3: Integration with odrun
```d
// Updated odrun with improved file watcher
void watchfile(Duration iolimit = dur!"msecs"(500), F)(string file, F func) {
    import filewatcher;
    import std;
    
    string folder = ".";
    if (file.startsWith("syntaxtest")) {
        folder = "syntaxtest";
    }
    
    // Use enhanced file watcher
    auto config = FileWatcherConfig(
        watchPaths: [folder],
        filePatterns: [file[folder.length + 1 .. $]],
        pollInterval: iolimit,
        enableDebug: false,
        maxRetries: 3
    );
    
    auto watcher = new EnhancedDirectoryWatcher(folder, config.filePatterns, config.pollInterval);
    watcher.start();
    
    // Register callback function
    registerCallback(func);
}
```

## Integration Considerations

### Backward Compatibility
1. **API Compatibility**: Maintain backward compatibility with existing API
2. **Configuration Compatibility**: Support existing configuration formats
3. **Behavioral Compatibility**: Preserve existing behavior while adding improvements
4. **Migration Path**: Provide clear migration path for existing users

### Performance Optimization
1. **Polling Intervals**: Optimize polling intervals based on file change frequency
2. **Event Throttling**: Implement throttling to prevent excessive rebuilds
3. **Memory Management**: Optimize memory usage for long-running watchers
4. **CPU Usage**: Minimize CPU usage during idle periods

### Error Handling
1. **Graceful Degradation**: Handle file watching failures gracefully
2. **Retry Logic**: Implement intelligent retry logic for transient failures
3. **Error Reporting**: Provide clear error messages for debugging
4. **Recovery Mechanisms**: Implement automatic recovery from errors

## Testing Plan

### Unit Tests
1. **File Pattern Matching**: Test various file pattern matching scenarios
2. **Event Processing**: Test event queue and processing logic
3. **Configuration Loading**: Test configuration loading and validation
4. **Error Handling**: Test error handling and recovery mechanisms

### Integration Tests
1. **odrun Integration**: Test integration with odrun application
2. **odrun2 Integration**: Test integration with odrun2 application
3. **Performance Testing**: Test performance with various file change scenarios
4. **Cross-Platform Testing**: Test on different operating systems

### User Acceptance Tests
1. **Usability Testing**: Test ease of use and configuration
2. **Reliability Testing**: Test reliability under various conditions
3. **Performance Testing**: Test performance with real-world workloads
4. **Compatibility Testing**: Test compatibility with existing workflows

## Risk Mitigation

### Technical Risks
1. **Performance Impact**: File watching could impact application performance
   - Mitigation: Profile code and optimize hot paths
   - Mitigation: Implement throttling and queuing mechanisms

2. **Complexity**: Enhanced file watcher could make codebase harder to maintain
   - Mitigation: Keep implementation modular and well-documented
   - Mitigation: Follow existing code patterns and conventions

3. **Compatibility**: Changes could break existing functionality
   - Mitigation: Maintain backward compatibility with existing API
   - Mitigation: Provide clear migration path for existing users

### User Experience Considerations
1. **Confusion**: Users might not understand new features or configuration options
   - Solution: Provide clear documentation and examples
   - Solution: Include helpful error messages and guidance

2. **Testing Access**: Users need to be able to test and interact with the enhanced file watcher
   - Solution: Ensure enhanced file watcher is easily accessible and controllable
   - Solution: Design clear override mechanisms that allow users to take control when needed

## Timeline
1. **Phase 1** (Analysis and Design): 1 day
2. **Phase 2** (Core Implementation): 2 days
3. **Phase 3** (Integration and Testing): 1 day
4. **Phase 4** (Documentation and Deployment): 0.5 days

Total estimated time: 4.5 days for complete implementation

## Success Metrics
1. **Performance**: File watching should not impact application performance significantly
2. **Reliability**: File watcher should handle errors gracefully and recover automatically
3. **Usability**: Configuration should be intuitive and well-documented
4. **Compatibility**: Existing functionality should continue to work without changes
5. **Maintainability**: Code should be modular and well-documented for future maintenance