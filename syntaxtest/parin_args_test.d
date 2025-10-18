#!/usr/bin/env -S dmd -run
import std;

/// Simple test to understand parin argument handling

void ready() {
    writeln("Ready function called");
    auto args = envArgs();
    writeln("Arguments received: ", args.length);
    foreach(i, arg; args) {
        writeln("  [", i, "]: ", arg);
    }
}

bool update(float dt) {
    writeln("Update called, dt=", dt);
    
    // Test if we can detect specific arguments
    auto args = envArgs();
    bool aiMode = false;
    string fileName = "TODO.kantban";
    
    foreach(arg; args) {
        if(arg == "--ai" || arg == "--ai-mode") {
            aiMode = true;
        } else if(!arg.startsWith("-") && arg.endsWith(".kantban")) {
            fileName = arg;
        }
    }
    
    writeln("AI Mode: ", aiMode);
    writeln("File: ", fileName);
    
    return false; // Don't exit
}

void finish() {
    writeln("Finish function called");
}

// Test the mixin approach
mixin runGame!(ready, update, finish);