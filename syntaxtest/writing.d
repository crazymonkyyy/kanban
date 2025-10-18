#!/bin/env -S opend -run app.d
import parin;
import std;
void ready() {
	//lockResolution(320, 180);
}
string foo="hi";
bool modifystring(ref string s){
	dchar c;
	bool b=false;
	if(Keyboard.backspace.isPressed){
		if(Keyboard.shift.isDown){
			s=[];
		}
		s=s[0..$?$-1:0];
		b=true;
	}
	loop:
	c=dequeuePressedRune;
	if(cast(int)c!=0){
		//c.writeln;
		if(cast(int)c>255){
			s~='?';
		} else {
			s~=cast(char)c;
		}
		b=true;
		goto loop;
	}
	return b;
}
bool update(float dt) {
	drawDebugText(foo, Vec2(8));
	if(foo.modifystring()){
		drawDebugText("modified",Vec2(20));
	}
	drawDebugText(fps.to!string,Vec2(30));
	return false;
}
void finish() {}
mixin runGame!(ready, update, finish);