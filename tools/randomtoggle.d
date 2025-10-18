#!/usr/bin/env -S dmd -i -run
import std;
import format;  // Import from format.d to follow single source of truth principle

void main(string[] args){
	if(args.length!=2){
		writeln("Usage: randomtoggle <file.kantban>");
		writeln("Randomly toggles completion status of items in kanban file");
		return;
	}

	string filename=args[1];

	// Minimal error handling following original style
	assert(exists(filename),"File not found");

	if(!filename.endsWith(".kantban")){
		writeln("Warning: File doesn't have .kantban extension");
	}

	// Load the kanban data using the function from format.d
	todolist[][] data=openkantban(filename);
	
	if(data.length==0){
		writeln("No data found in file");
		return;
	}

	int totalItems=0;
	int toggledItems=0;

	// Count total items first
	foreach(col;data){
		foreach(card;col){
			totalItems+=cast(int)card.items.length;
		}
	}

	writeln("Found ",totalItems," items across ",cast(int)data.length," columns");

	// Randomly toggle items (30% chance each)
	foreach(ref col;data){
		foreach(ref card;col){
			card.sanitize(); // Ensure crossed array is right size

			foreach(i,ref crossed;card.crossed){
				if(uniform(0,100)<30) // 30% chance to toggle
				{
					crossed=!crossed;
					toggledItems++;

					string status=crossed?"[x]":"[ ]";
					writeln("  ",status," ",card.title,": ",card.items[i]);
				}
			}
		}
	}

	writeln("\nToggled ",toggledItems," out of ",totalItems," items");

	// Save back to file using the function from format.d
	savekantban(data,filename);
	writeln("Saved changes to ",filename);
}
