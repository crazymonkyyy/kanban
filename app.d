#!/bin/env -S opend -run app.d
import parin;//game engine
import format;//io of .kantban
import drawing;
enum file="TODO.kantban";
todolist[][] data;
int[] offsetx;
int offsety;
void ready(){
	data=openkantban(file);
	initdrawing;
	offsetx.length=data.length;
}
bool update(float dt){
	draw(data,offsetx,offsety);
	return false;
}
void finish(){}
mixin runGame!(ready, update, finish);

// Helper function
//NOTE: The original had different function signatures and logic that would need to be reverted
//NOTE: The original app.d had a much simpler implementation without command line arguments, keyboard controls, or the clampindex helper function
ref clampindex(T, I)(T[] a, ref I i){
	if(i<0||i==I.max){
		i=0;
	}
	if(i>=a.length){
		i=cast(I)a.length-1;
	}
	return a[i];
}
