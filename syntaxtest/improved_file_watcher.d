#!/usr/bin/env -S dmd -run
/**
 * Simple syntax test for improved file watching API
 * Demonstrates a more robust approach to file watching
 */

import std.stdio;
import std.file;
import std.path;
import std.datetime;
import std.process;
import core.thread;
import arsd.core : DirectoryWatcher, FilePath;

/**
 * Simple improved file watcher that handles common edge cases
 */
class ImprovedFileWatcher {
    private DirectoryWatcher watcher;
    private string directory;
    private string[] watchedFiles;
    private bool isWatching = false;
    
    /**
     * Constructor with improved error handling
     */
    this(string dir, string[] files = []) {
        this.directory = dir;
        this.watchedFiles = files.dup;
        
        // Ensure directory exists with proper error handling
        ensureDirectoryExists();
    }
    
    /**
     * Ensure the directory exists, creating it if needed
     */
    private void ensureDirectoryExists() {
        try {
            if (!exists(directory)) {
                mkdir(directory);
                writeln("Created directory: ", directory);
            }
        } catch (FileException e) {
            writeln("Warning: Could not create directory ", directory, ": ", e.msg);
        }
    }
    
    /**
     * Start watching with improved error handling
     */
    void start(void delegate(string path) onChange) {
        if (isWatching) return;
        
        try {
            // Create the directory watcher with proper error handling
            watcher = new DirectoryWatcher(
                FilePath(directory),
                "", // Watch all files
                true, // Recursive
                (FilePath path, int op) {
                    // Improved file matching and error handling
                    try {
                        string fullPath = path.path;
                        if (shouldNotify(fullPath)) {
                            onChange(fullPath);
                        }
                    } catch (Exception e) {
                        writeln("Error in file change handler: ", e.msg);
                    }
                }
            );
            isWatching = true;
            writeln("Started watching directory: ", directory);
        } catch (Exception e) {
            writeln("Error starting file watcher: ", e.msg);
        }
    }
    
    /**
     * Determine if we should notify about a file change
     */
    private bool shouldNotify(string path) {
        // If no specific files to watch, notify about all files
        if (watchedFiles.length == 0) {
            return true;
        }
        
        // Check if this is one of the files we're watching
        string fileName = baseName(path);
        foreach (file; watchedFiles) {
            if (fileName == file) {
                return true;
            }
        }
        
        return false;
    }
    
    /**
     * Stop watching
     */
    void stop() {
        if (!isWatching) return;
        
        try {
            if (watcher !is null) {
                // Proper cleanup
                watcher.destroy();
                watcher = null;
            }
            isWatching = false;
            writeln("Stopped watching directory: ", directory);
        } catch (Exception e) {
            writeln("Error stopping file watcher: ", e.msg);
        }
    }
}

/**
 * Test the improved file watcher
 */
void main() {
    writeln("Testing improved file watcher API");
    
    // Create a test directory
    string testDir = "test_watch_dir";
    
    // Create watcher
    auto watcher = new ImprovedFileWatcher(testDir, ["test.d"]);
    
    // Start watching
    watcher.start((string path) {
        writeln("File changed: ", path);
    });
    
    // Give it a moment to start
    Thread.sleep(dur!"seconds"(1));
    
    // Stop watching
    watcher.stop();
    
    writeln("Improved file watcher test completed!");
}