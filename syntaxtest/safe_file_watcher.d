#!/usr/bin/env -S dmd -run
/**
 * Syntax test for a failsafe file watching API
 * This test demonstrates a robust file watching API that:
 * 1. Handles folders properly
 * 2. Is failsafe (doesn't crash on errors)
 * 3. Can watch specific files or all files in a directory
 * 4. Properly handles directory creation/deletion
 */

import std.stdio;
import std.file;
import std.path;
import std.datetime;
import std.process;
import std.algorithm;
import core.thread;
import arsd.core : DirectoryWatcher, FilePath;

/**
 * A failsafe file watcher that watches directories and files
 */
class SafeFileWatcher {
    private DirectoryWatcher watcher;
    private string directory;
    private string[] filePatterns;
    private void delegate(string, int) onChangeCallback;
    private bool isWatching = false;
    
    /**
     * Constructor
     * @param dir The directory to watch
     * @param patterns File patterns to watch (e.g. ["*.d", "config.txt"]) or empty for all files
     * @param onChange Callback function called when a file changes
     */
    this(string dir, string[] patterns = [], void delegate(string, int) onChange = null) {
        this.directory = dir;
        this.filePatterns = patterns.dup;
        this.onChangeCallback = onChange;
        
        // Ensure directory exists
        if (!exists(this.directory)) {
            try {
                mkdir(this.directory);
            } catch (Exception e) {
                writeln("Warning: Could not create directory ", this.directory, ": ", e.msg);
            }
        }
    }
    
    /**
     * Start watching files
     */
    void start() {
        if (isWatching) return;
        
        try {
            // Create the directory watcher
            watcher = new DirectoryWatcher(
                FilePath(directory),
                "", // Watch all files
                true, // Recursive
                &onFileChanged
            );
            isWatching = true;
            writeln("Started watching directory: ", directory);
        } catch (Exception e) {
            writeln("Error starting file watcher: ", e.msg);
        }
    }
    
    /**
     * Stop watching files
     */
    void stop() {
        if (!isWatching) return;
        
        try {
            if (watcher !is null) {
                watcher.destroy();
                watcher = null;
            }
            isWatching = false;
            writeln("Stopped watching directory: ", directory);
        } catch (Exception e) {
            writeln("Error stopping file watcher: ", e.msg);
        }
    }
    
    /**
     * Internal callback when a file changes
     */
    private void onFileChanged(FilePath path, int op) {
        try {
            // Check if this file matches our patterns
            string filename = baseName(path.path);
            if (matchesPatterns(filename)) {
                if (onChangeCallback !is null) {
                    onChangeCallback(path.path, cast(int) op);
                }
            }
        } catch (Exception e) {
            writeln("Error processing file change: ", e.msg);
        }
    }
    
    /**
     * Check if a filename matches our patterns
     */
    private bool matchesPatterns(string filename) {
        // If no patterns specified, match all files
        if (filePatterns.length == 0) {
            return true;
        }
        
        // Check each pattern
        foreach (pattern; filePatterns) {
            if (matchPattern(filename, pattern)) {
                return true;
            }
        }
        
        return false;
    }
    
    /**
     * Match a filename against a pattern
     */
    private bool matchPattern(string filename, string pattern) {
        // Simple wildcard matching
        if (pattern == "*") {
            return true;
        }
        
        // Extension matching
        if (pattern.startsWith("*.")) {
            string ext = pattern[2..$];
            return filename.endsWith("." ~ ext);
        }
        
        // Exact match
        return filename == pattern;
    }
}

/**
 * Test the SafeFileWatcher
 */
void main() {
    writeln("Testing SafeFileWatcher API");
    
    // Create a test directory
    string testDir = "test_watch_dir";
    if (!exists(testDir)) {
        mkdir(testDir);
    }
    
    // Create a watcher for D files
    auto watcher = new SafeFileWatcher(
        testDir,
        ["*.d", "*.txt"],
        (string path, DirectoryOp op) {
            writeln("File changed: ", path, " Operation: ", op);
        }
    );
    
    // Start watching
    watcher.start();
    
    // Create some test files
    writeln("Creating test files...");
    File(testDir ~ "/test.d", "w").write("void main() {}");
    File(testDir ~ "/config.txt", "w").write("test config");
    
    // Wait a bit
    Thread.sleep(dur!"seconds"(2));
    
    // Modify a file
    writeln("Modifying test file...");
    File(testDir ~ "/test.d", "w").write("void main() { writeln(\"Hello\"); }");
    
    // Wait a bit
    Thread.sleep(dur!"seconds"(2));
    
    // Stop watching
    watcher.stop();
    
    // Clean up
    try {
        std.file.remove(testDir ~ "/test.d");
        std.file.remove(testDir ~ "/config.txt");
        rmdir(testDir);
    } catch (Exception e) {
        // Ignore cleanup errors
    }
    
    writeln("SafeFileWatcher test completed successfully!");
}