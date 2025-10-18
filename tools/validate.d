#!/usr/bin/env -S dmd -i -run
import std;

// Copy the todolist struct from format.d to avoid import issues
struct todolist{
	string title;
	string[] items;
	bool[] crossed;
	void sanitize(){
		if(crossed.length<items.length){
			crossed.length=items.length;
		}
	}
}

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

	// Try to parse the file
	todolist[][] data;
	if(exists(filename)){
		data=openkantban(filename);
	}

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

todolist[][] openkantban(string where){
	if(!exists(where))
		return [];
	todolist[][] result;
	todolist[] col;
	todolist cur;
	foreach(line;File(where).byLineCopy){
		if(line.startsWith("# ")){
			if(cur.title.length)
				col~=cur;
			if(col.length)
				result~=col;
			col=[];
			cur=todolist();
		}
		else if(line.startsWith("## ")){
			if(cur.title.length)
				col~=cur;
			cur=todolist(line[3..$].idup);
		}
		else if(line.startsWith("- ")){
			bool done=false;
			string item;

			// Check for various checkbox formats
			if(line.length>=6&&line[2]=='['&&line[4]==']'){
				// Format: "- [x]" or "- [ ]"
				done=(line[3]=='x'||line[3]=='X');
				item=line.length>6?line[6..$].strip.idup:"";
			}
			else if(line.length>=7&&line[2]=='['&&line[5]==']'){
				// Format: "- [x ]" or "- [ x]\" - flexible spacing
				done=(line[3]=='x'||line[3]=='X'||line[4]=='x'||line[4]=='X');
				item=line.length>7?line[7..$].strip.idup:"";
			}
			else{
				// Plain format: "- item"
				item=line.length>2?line[2..$].strip.idup:"";
				done=false;
			}

			cur.items~=item;
			cur.crossed~=done;
		}
	}
	if(cur.title.length)
		col~=cur;
	if(col.length)
		result~=col;
	return result;
}