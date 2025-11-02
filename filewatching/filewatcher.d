module filewatching;

import std.file;
import std.datetime;
import std.path;
import arsd.core;

/**
 * Helper function to prevent excessive triggering of file watch events
 */
bool maxwatch(T, S)(ref T a, T b, S c) {
    if (a + c >= b) {
        return false;
    }
    a = b;
    return true;
}

/**
 * FileWatcher class that watches a directory for changes to specific files
 */
class FileWatcher {
    private DirectoryWatcher watcher;
    private string[] watchedFiles;
    private Duration ioLimit;
    private SysTime lastTrigger;
    private void delegate() onChangeCallback;
    
    this(string directory, string[] files, Duration ioLimit = dur!"msecs"(500), void delegate() onChange = null) {
        this.watchedFiles = files.dup;
        this.ioLimit = ioLimit;
        this.onChangeCallback = onChange;
        this.lastTrigger = SysTime.min;
        
        // Create the directory watcher
        watcher = new DirectoryWatcher(
            FilePath(directory),
            "", // Watch all files
            true, // Recursive
            &onDirectoryChange
        );
    }
    
    private void onDirectoryChange(FilePath path, DirectoryOp op) {
        // Check if the changed file is one we're watching
        string fileName = path.name;
        bool isWatched = false;
        
        foreach (watchedFile; watchedFiles) {
            if (fileName == baseName(watchedFile) || fileName == watchedFile || 
                path.path.endsWith(watchedFile)) {
                isWatched = true;
                break;
            }
        }
        
        // If it's a D file and we're watching D files, trigger the callback
        if (!isWatched && fileName.length > 2 && fileName[fileName.length-2..$] == ".d") {
            foreach (watchedFile; watchedFiles) {
                if (watchedFile.length > 2 && watchedFile[watchedFile.length-2..$] == ".d") {
                    isWatched = true;
                    break;
                }
            }
        }
        
        if (isWatched) {
            // Get the file's last modified time
            try {
                auto fullPath = path.path;
                auto fileTime = fullPath.timeLastModified;
                
                // Use maxwatch to prevent excessive triggering
                if (maxwatch(lastTrigger, fileTime, ioLimit)) {
                    if (onChangeCallback !is null) {
                        onChangeCallback();
                    }
                }
            } catch (Exception e) {
                // Ignore errors, file might have been deleted
            }
        }
    }
    
    /**
     * Start watching for file changes
     */
    void start() {
        // The watcher is already started in the constructor
    }
    
    /**
     * Stop watching for file changes
     */
    void stop() {
        if (watcher !is null) {
            watcher.destroy();
            watcher = null;
        }
    }
}