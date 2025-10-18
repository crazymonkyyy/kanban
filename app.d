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

	data=openkantban(file);
	initdrawing;
	x.length=data.length;
}

bool update(float dt){
	assert(x.length==data.length);
	y+=Keyboard.down.isPressed-Keyboard.up.isPressed;
	
	// Clamp y to valid range
	if(y<0) y=0;
	if(y>=cast(int)data.length) y=cast(int)data.length-1;
	
	x.clampindex(y)+=Keyboard.right.isPressed-Keyboard.left.isPressed;

	// Clamp x index to valid range for the current column
	if(y>=0&&y<cast(int)data.length){
		if(x[y]<0) x[y]=0;
		if(x[y]>=cast(int)data[y].length) x[y]=cast(int)data[y].length-1;
	}

	draw(data,x,y);
	return false;
}

void finish(){
}

mixin runGame!(ready, update, finish);

// Helper function
ref clampindex(T, I)(T[] a, ref I i){
	if(i<0||i==I.max){
		i=0;
	}
	if(i>=a.length){
		i=cast(I)a.length-1;
	}
	return a[i];
}