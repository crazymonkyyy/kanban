#!/bin/env -S opend -run app.d
import parin;
//import std;
void ready() {
	//lockResolution(320, 180);
}
bool update(float dt) {
	auto r=Rect(20,20,mouse.x,mouse.y);
	float round=90.0/min(r.size.x,r.size.y);
	rl.DrawRectangleRoundedLinesEx(r.toRl,round,9, 10,white.toRl);
	return false;
}
void finish() {}
mixin runGame!(ready, update, finish);
