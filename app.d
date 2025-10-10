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

