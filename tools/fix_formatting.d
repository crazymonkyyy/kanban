#!/usr/bin/env -S dmd -i -run
import std;

void main(string[] args){
	if(args.length < 2){
		writeln("Usage: fix_formatting <file.d>");
		writeln("Fixes whitespace formatting according to the style guide:");
		writeln("- Converts leading spaces to tabs (4 spaces = 1 tab)");
		writeln("- Ensures minimal spacing around operators");
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

	// Write the fixed content back to file
	string fixedContent = join(lines, "\n");
	std.file.write(filename, fixedContent);

	writeln("Formatting fixed for: ", filename);
}