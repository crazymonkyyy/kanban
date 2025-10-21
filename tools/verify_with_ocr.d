#!/usr/bin/dmd -run
import std.stdio;
import std.process;
import std.file;
import std.string;
import std.array;
import std.path;
import std.typecons;

void main(string[] args) {
    if (args.length < 2) {
        writeln("Usage: ", baseName(args[0]), " <file.kantban>");
        writeln("  <file.kantban> - Path to the .kantban file to test");
        return;
    }

    string filePath = args[1];

    // Check if file exists
    if (!exists(filePath)) {
        writeln("Error: File '", filePath, "' does not exist.");
        return;
    }

    // First, check if the app.d compiles correctly
    writeln("Checking if app.d compiles correctly...");
    string[] compileCmd = [
        "dmd", 
        "-c", 
        "/home/monkyyy/src/kanban/app.d",
        "/home/monkyyy/src/kanban/format.d",
        "/home/monkyyy/src/kanban/drawing.d", 
        "/home/monkyyy/src/kanban/configs.d",
        "/home/monkyyy/src/kanban/utility.d",
        "-I/home/monkyyy/src/kanban/parin_package/source"
    ];
    
    try {
        auto compileResult = execute(compileCmd);
        int compileExitCode = compileResult[0];
        
        if (compileExitCode != 0) {
            writeln("ERROR: app.d failed to compile with exit code: ", compileExitCode);
            writeln("Compilation output: ", compileResult[1]);
            writeln("Verification FAILED - app.d has compilation errors!");
            return;
        } else {
            writeln("SUCCESS: app.d compiles without errors.");
        }
    } catch (Exception e) {
        writeln("Error during compilation check: ", e.msg);
        return;
    }
    
    // First, test if app.d can be compiled without errors (syntax and basic checks)
    writeln("Checking if app.d compiles correctly...");
    string[] compileCmd2 = [
        "dmd", 
        "-c", 
        "/home/monkyyy/src/kanban/app.d",
        "/home/monkyyy/src/kanban/format.d",
        "/home/monkyyy/src/kanban/drawing.d", 
        "/home/monkyyy/src/kanban/configs.d",
        "/home/monkyyy/src/kanban/utility.d",
        "-I/home/monkyyy/src/kanban/parin_package/source"
    ];
    
    try {
        auto compileResult = execute(compileCmd2);
        int compileExitCode = compileResult[0];
        
        if (compileExitCode != 0) {
            writeln("ERROR: app.d failed to compile with exit code: ", compileExitCode);
            writeln("Compilation output: ", compileResult[1]);
            writeln("Overall verification: FAILED - app.d has compilation errors!");
            return;
        } else {
            writeln("SUCCESS: app.d compiles without syntax errors.");
        }
    } catch (Exception e) {
        writeln("Error during compilation check: ", e.msg);
        writeln("Overall verification: FAILED - compilation check failed.");
        return;
    }
    
    // For runtime testing, we'll use the opend command which properly handles the Parin engine
    writeln("Testing runtime behavior with opend...");
    
    // Remove any existing screenshot using std.file.remove
    import std.file;
    if (exists("kanban_screenshot.png")) {
        std.file.remove("kanban_screenshot.png");
    }
    
    // Use opend to run the app with -ai flag (the way we know works)
    string[] cmd = [
        "/home/monkyyy/bin/opend_/bin/opend",
        "-run",
        "/home/monkyyy/src/kanban/app.d",
        "--",
        "-ai",
        filePath
    ];
    
    try {
        auto result = execute(cmd);
        int exitCode = result[0];
        
        if (exitCode != 0) {
            writeln("ERROR: App execution failed with exit code: ", exitCode);
            writeln("Overall verification: FAILED - app runtime execution failed.");
            return;
        } else {
            writeln("App executed successfully.");
        }
        
        // Check if the screenshot file was created
        if (!exists("kanban_screenshot.png")) {
            writeln("ERROR: Screenshot file 'kanban_screenshot.png' was not created.");
            writeln("Overall verification: FAILED - no screenshot was generated.");
            return;
        } else {
            writeln("Screenshot file 'kanban_screenshot.png' was created successfully.");
            
            // Verify that the file has content
            ulong fileSize = getSize("kanban_screenshot.png");
            if (fileSize > 0) {
                writeln("Screenshot verification: File has ", fileSize, " bytes.");
            } else {
                writeln("ERROR: Screenshot file is empty.");
                writeln("Overall verification: FAILED - screenshot file is empty.");
                return;
            }
        }
        
        // Run OCR on the screenshot to verify content
        writeln("Running OCR on the screenshot to verify content...");
        import std.process : executeShell;
        
        // Run tesseract OCR on the screenshot
        string ocrCmd = "tesseract kanban_screenshot.png stdout";
        string ocrOutput;
        try {
            auto ocrResult = executeShell(ocrCmd);
            ocrOutput = ocrResult[1]; // Get the output
            writeln("OCR output: ", ocrOutput);
            
            // Verify that the OCR output contains expected content from TODO.kantban
            import std.string : indexOf;
            // Use more flexible matching since OCR might not be perfect
            bool hasShopping = ocrOutput.indexOf("Shopping") != -1 || ocrOutput.indexOf("Gopping") != -1;
            bool hasMilk = ocrOutput.indexOf("milk") != -1;
            bool hasLearning = ocrOutput.indexOf("Learning") != -1;
            bool hasProjects = ocrOutput.indexOf("Projects") != -1;
            bool hasWorkTasks = ocrOutput.indexOf("Work Tasks") != -1 || (ocrOutput.indexOf("Work") != -1 && ocrOutput.indexOf("Tasks") != -1);
            
            if (hasShopping && hasMilk && hasLearning && hasProjects && hasWorkTasks) {
                writeln("OCR verification: SUCCESS - Expected content found in screenshot.");
            } else {
                writeln("ERROR: OCR verification: Expected content not found in screenshot.");
                writeln("OCR Output: ", ocrOutput);
                writeln("Checks: Shopping/Gopping: ", hasShopping, ", Milk: ", hasMilk, 
                        ", Learning: ", hasLearning, ", Projects: ", hasProjects, 
                        ", Work Tasks: ", hasWorkTasks);
                writeln("Overall verification: FAILED - OCR did not detect expected kanban content.");
                return;
            }
        } catch (Exception e) {
            writeln("ERROR: OCR failed with exception: ", e.msg);
            writeln("Overall verification: FAILED - OCR verification failed.");
            return;
        }
        
        writeln("Overall verification: PASSED - app.d compiles correctly, -ai functionality works, and OCR verification passed.");
        
    } catch (Exception e) {
        writeln("Error executing command: ", e.msg);
        writeln("Overall verification: FAILED - runtime test failed.");
    }
}