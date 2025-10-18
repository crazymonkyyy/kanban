#!/usr/bin/env -S dmd -i -run
import std;
import format;  // Import from format.d to follow single source of truth principle

void main(string[] args){
	if(args.length!=2){
		writeln("Usage: validate <file.kantban>");
		writeln("Validates the format and structure of a kanban file");
		return;
	}

	string filename=args[1];

	writeln("Validating: ",filename);
	writeln("="~"=".replicate(filename.length+12));

	// Use minimal validation following original style
	// Instead of complex validation with multiple error types, just check basic things
	if(!exists(filename)){
		writeln("File does not exist: ",filename);
		return;
	}

	// Try to parse the file using the function from format.d
	todolist[][] data=openkantban(filename);

	// Simple validation - just check if we could parse it
	if(data.length==0){
		writeln("File appears to be empty or invalid format");
		return;
	}

	// Count basic stats
	int columns=cast(int)data.length;
	int cards=0;
	int items=0;
	foreach(col;data){
		cards+=cast(int)col.length;
		foreach(card;col){
			items+=cast(int)card.items.length;
		}
	}

	writeln("✓ File appears valid");
	writeln();
	writeln("Statistics:");
	writeln("  Columns: ",columns);
	writeln("  Cards:   ",cards);
	writeln("  Items:   ",items);

	writeln();
	writeln("File is valid! ✓");
}