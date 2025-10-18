#!/usr/bin/env -S dmd -i -run
import std;

/// Test program to validate how CLI arguments work in parin
/// This tests the theory about AI mode flag implementation

void main(string[] args) {
    writeln("Testing CLI argument parsing in parin");
    writeln("=====================================");
    
    writeln("All arguments: ", args);
    writeln("Argument count: ", args.length);
    
    // Test different ways of parsing arguments
    foreach(i, arg; args) {
        writeln("Arg[", i, "]: ", arg);
    }
    
    // Test specific argument detection
    bool foundAiFlag = false;
    string fileName = "";
    
    for(int i = 1; i < args.length; i++) {
        string arg = args[i];
        writeln("Processing: ", arg);
        
        if(arg == "--ai" || arg == "--ai-mode") {
            foundAiFlag = true;
            writeln("Found AI mode flag!");
        }
        else if(arg.startsWith("--")) {
            writeln("Found other flag: ", arg);
        }
        else {
            // Assume it's a filename
            fileName = arg;
            writeln("Assuming filename: ", fileName);
        }
    }
    
    writeln("\nResults:");
    writeln("AI Mode Enabled: ", foundAiFlag);
    writeln("Filename: ", fileName);
    
    // Test envArgs() function if available
    writeln("\nTesting envArgs():");
    try {
        import parin;
        auto envArgs = envArgs();
        writeln("envArgs count: ", envArgs.length);
        foreach(i, arg; envArgs) {
            writeln("envArg[", i, "]: ", arg);
        }
    }
    catch(Exception e) {
        writeln("parin not available or envArgs() failed: ", e.msg);
    }
    
    writeln("\nTest completed successfully!");
}