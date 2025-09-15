#!/bin/env -S opend -run app.d
import parin;
//import std;
void ready() {
	//lockResolution(320, 180);
}
enum roundness=90.0;
enum background=cyan;
void drawrounded(Rect r, Color c){
	float round=roundness/min(r.size.x,r.size.y);
	rl.DrawRectangleRounded(r.toRl,round,9,background.toRl);
	rl.DrawRectangleRoundedLinesEx(r.toRl,round,9, 10,c.toRl);
}

bool update(float dt) {
	auto r=Rect(20,20,mouse.x,mouse.y);
	drawrounded(r,black);
	return false;
}
void finish() {}
mixin runGame!(ready, update, finish);
