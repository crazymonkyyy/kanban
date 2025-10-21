#!/bin/env -S opend -run app.d
import parin;//game engine
import format;//io of .kantban
import drawing;
import utility;
import std;

string file="TODO.kantban";
todolist[][] data;
int[] x;
int y;
bool aiMode = false;
bool screenshotTaken = false;

void ready(){
	// Check for command line arguments
	auto args=envArgs();
	
	// Parse arguments properly
	for(size_t i = 1; i < args.length; i++) {
		if(args[i] == "-ai") {
			aiMode = true;
		} else if(args[i][0] != '-' && args[i] != "--") {  // Skip flags and separator
			// This should be the file path
			file = args[i].to!string;
		}
	}

	// Load data from file
	data=openkantban(file);
	
	// Initialize drawing
	initdrawing;

	x.length=data.length;
}

bool update(float dt){
	// Handle navigation
	y+=Keyboard.down.isPressed-Keyboard.up.isPressed;
	
	// Use clamptoindex to safely handle y index for both data and x arrays
	// This ensures that if either array is empty, it gets initialized properly
	if(data.length == 0) {
		return true;
	}
	
	// Clamp y to valid range for data array
	y=utility.clamp(y, 0, cast(int)data.length-1);
	
	// Use utility.clamptoindex to ensure safe access to x[y]
	// This will handle empty x array or extend it if needed
	utility.clamptoindex(x, y, 0); // Ensure x has value for index y
	
	// Update the x value for the current column
	x[y] += Keyboard.right.isPressed-Keyboard.left.isPressed;
	
	// Clamp x[y] based on the length of the corresponding column in data
	if(y < data.length && data[y].length > 0) {
		x[y] = utility.clamp(x[y], 0, cast(int)data[y].length-1);
	} else {
		x[y] = 0; // Reset to 0 if no items in this column
	}

	// Draw the board
	if(y < data.length && data[y].length > 0) {
		draw(data, x, y);
	} else {
		assert(0);
		//return true;
	}
	
	// If in AI mode, take a screenshot on the first frame and then exit
	if(aiMode && !screenshotTaken) {
		takeScreenshot();
		screenshotTaken = true;
		//return true; // This will cause the game loop to exit after this frame
	}
	
	return false;
}

void takeScreenshot() {
	// Using parin's takescreenshot function to capture the screen
	takescreenshot("kanban_screenshot.png");
}

void finish(){}
mixin runGame!(ready, update, finish);
