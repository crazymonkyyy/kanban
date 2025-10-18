#!/usr/bin/env -S dmd -i -run
import std;
import std.algorithm : canFind;

void main(string[] args){
	if(args.length < 2){
		writeln("Usage: fix_formatting <file.d>");
		writeln("Fixes whitespace formatting according to the style guide:");
		writeln("- Converts leading spaces to tabs");
		writeln("- Ensures opening braces are on the same line as declarations");
		return;
	}

	string filename = args[1];

	if(!exists(filename)){
		writeln("Error: File does not exist: ", filename);
		return;
	}

	// Read the file
	string content = cast(string)read(filename);
	string[] lines = content.splitter("\n").array;

	// Process braces - look for declarations followed by a line with just an opening brace
	for(int i = 0; i < lines.length - 1; i++){
		string currentLine = lines[i].strip;
		
		// Check if current line looks like a function/conditional declaration (ends with parenthesis or keyword)
		// and the next line is an opening brace
		if(currentLine.length > 0 && 
		   (currentLine.endsWith(")") || currentLine.endsWith("else") || 
		    currentLine.endsWith("struct") || currentLine.endsWith("class") || currentLine.endsWith("interface") ||
		    currentLine.endsWith("unittest") || currentLine.endsWith("version") || currentLine.endsWith("import") ||
		    currentLine.indexOf("void ") != -1 || currentLine.indexOf("int ") != -1 || currentLine.indexOf("bool ") != -1 ||
		    currentLine.indexOf("string ") != -1 || currentLine.indexOf("auto ") != -1 || currentLine.indexOf("enum ") != -1)){
			
			// Look ahead for the next non-empty line to see if it's just an opening brace
			for(int j = i + 1; j < lines.length; j++){
				string nextLine = lines[j].strip;
				if(nextLine.length == 0) continue; // Skip empty lines
				if(nextLine == "{"){
					// Move the brace to the current line
					lines[i] = lines[i].strip ~ " {";
					lines[j] = ""; // Clear the line with the brace
					break;
				} else {
					break; // Found a non-brace line, stop looking
				}
			}
		}
	}

	// Process each line for space-to-tab conversion
	for(int i = 0; i < lines.length; i++){
		string line = lines[i];
		
		// Convert leading spaces to tabs (every 4 spaces becomes 1 tab)
		int leadingSpaceCount = 0;
		for(int j = 0; j < line.length && line[j] == ' '; j++){
			leadingSpaceCount++;
		}
		
		if(leadingSpaceCount > 0){
			int tabCount = leadingSpaceCount / 4;
			int remainingSpaces = leadingSpaceCount % 4;
			
			string newIndent = "";
			foreach(_; 0..tabCount){
				newIndent ~= "\t";
			}
			
			// Keep remaining spaces if less than 4
			foreach(_; 0..remainingSpaces){
				newIndent ~= " ";
			}
			
			line = newIndent ~ line[leadingSpaceCount..$];
		}
		
		lines[i] = line;
	}

	// Write the fixed content back to file, removing any lines that became empty
	string[] finalLines;
	foreach(line; lines){
		finalLines ~= line;
	}
	
	// Remove trailing empty lines but keep internal structure
	while(finalLines.length > 0 && finalLines[$-1].strip.length == 0){
		finalLines = finalLines[0..$-1];
	}
	
	string fixedContent = join(finalLines, "\n");
	std.file.write(filename, fixedContent);

	writeln("Formatting fixed for: ", filename);
}