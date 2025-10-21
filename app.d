#!/bin/env -S opend -run app.d
import parin;//game engine
import format;//io of .kantban
import drawing;
import std;

string file="TODO.kantban";
todolist[][] data;
int[] x;
int y;
void ready(){
	// Check for command line arguments
	auto args=envArgs();
	if(args.length>1){
		file=args[1].to!string;
	}

	// Check if file exists before attempting to open
	if(!std.file.exists(file)) {
		writeln("WARNING: File does not exist: ", file);
		writeln("Creating empty data structure and continuing...");
		data = []; // Initialize as empty array
	} else {
		data=openkantban(file);
		writeln("INFO: Loaded ", data.length, " columns from ", file);
		
		// Additional warnings for empty data
		if(data.length == 0) {
			writeln("WARNING: File is empty or contains no valid columns");
		} else {
			int totalCards = 0;
			int totalItems = 0;
			foreach(column; data) {
				totalCards += column.length;
				foreach(card; column) {
					totalItems += card.items.length;
				}
			}
			writeln("INFO: Loaded ", totalCards, " cards and ", totalItems, " items");
		}
	}
	
	// Initialize drawing after checking data
	initdrawing;
	x.length=data.length;
	
	// Check if x array was properly initialized
	if(x.length != data.length) {
		writeln("ERROR: Failed to initialize x array properly");
		writeln("WARNING: Attempting to fix x array length");
		x.length = data.length;
	}
}

bool update(float dt){
	// Check for data consistency
	if(x.length != data.length) {
		writeln("ERROR: x.length (", x.length, ") != data.length (", data.length, ") - inconsistent state");
		// Try to recover by resizing x to match data
		x.length = data.length;
	}
	
	y+=Keyboard.down.isPressed-Keyboard.up.isPressed;
	
	// Clamp y to valid range
	if(y<0) y=0;
	if(y>=cast(int)data.length) {
		writeln("WARNING: y clamped from ", y, " to ", cast(int)data.length-1);
		y=cast(int)data.length-1;
	}
	
	// Only try to access x[y] if y is valid and x array is not empty
	if(y>=0 && y<cast(int)x.length && x.length>0){
		x.clampindex(y)+=Keyboard.right.isPressed-Keyboard.left.isPressed;
	} else {
		if(x.length == 0) {
			writeln("WARNING: x array is empty, navigation disabled");
		} else {
			writeln("WARNING: Invalid index access attempt: y=", y, ", x.length=", x.length);
		}
	}

	// Clamp x index to valid range for the current column
	if(y>=0 && y<cast(int)data.length && x.length>0 && y<x.length){
		if(x[y]<0) {
			writeln("WARNING: x[", y, "] clamped from ", x[y], " to 0");
			x[y]=0;
		}
		if(x[y]>=cast(int)data[y].length) {
			writeln("WARNING: x[", y, "] clamped from ", x[y], " to ", cast(int)data[y].length-1);
			x[y]=cast(int)data[y].length-1;
		}
	} else {
		if(data.length == 0) {
			writeln("WARNING: No data available to display");
		} else if(y >= data.length) {
			writeln("WARNING: y index (", y, ") out of bounds for data (length ", data.length, ")");
		}
	}

	// Ensure y is within bounds before drawing
	if(y>=0 && y<cast(int)data.length){
		if(data.length > 0 && y < data.length && data[y].length > 0) {
			draw(data,x,y);
		} else {
			writeln("WARNING: Attempting to draw with empty data at index y=", y);
			// Draw with valid index if possible
			if(data.length > 0) {
				// Find first non-empty column to draw
				int firstValidColumn = -1;
				for(int i = 0; i < cast(int)data.length; i++) {
					if(data[i].length > 0) {
						firstValidColumn = i;
						break;
					}
				}
				if(firstValidColumn >= 0) {
					draw(data, x, firstValidColumn);
				} else {
					writeln("WARNING: All columns are empty, nothing to draw");
				}
			}
		}
	} else {
		// If y is out of bounds, draw with a valid index
		if(data.length>0){
			writeln("WARNING: y out of bounds (", y, "), drawing with index 0");
			draw(data,x,0);
		} else {
			writeln("WARNING: No data to draw");
		}
	}
	return false;
}

void finish(){
}

mixin runGame!(ready, update, finish);

// Helper function
ref clampindex(T, I)(T[] a, ref I i){
	if(i<0||i==I.max){
		writeln("WARNING: clampindex called with negative or max value: ", i);
		i=0;
	}
	if(a.length==0){
		// If array is empty, just set i to 0 and extend the array with a default element
		writeln("WARNING: clampindex called with empty array, extending with default element");
		i=0;
		a ~= T.init;  // Append a default-initialized element
	}
	if(cast(size_t)i >= a.length){
		if(a.length == 0){
			i = 0;
		} else {
			writeln("WARNING: clampindex clamping index ", i, " to ", cast(I)(a.length - 1));
			i = cast(I)(a.length - 1);
		}
	}
	return a[i];
}