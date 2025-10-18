#!/bin/env -S opend -run app.d
import parin;
import std.random;
import std.conv;
void ready() {
	foreach(x;0..5){
	foreach(y;0..5){
		foo[x][y]=uniform(30,300).to!float;
	}}
}
enum roundness=90.0;
enum background=black;
void drawrounded(Rect r, Color c){
	float round=roundness/min(r.size.x,r.size.y);
	rl.DrawRectangleRounded(r.toRl,round,9,background.toRl);
	rl.DrawRectangleRoundedLinesEx(r.toRl,round,9, 10,c.toRl);
}
Color[8] colors=[red,green,blue,yellow,pink,cyan,orange,brown];
float[5][5] foo;
int x_;
int[5] y_;
bool update(float dt) {
	Vec2 pos;
	x_+=wasdPressed.toIVec.y;
	y_[x_]+=wasdPressed.toIVec.x;
	foreach(x;x_..5){
		pos.x=0;
		pos.y+=300;
	foreach(y;y_[x]..5){
		drawrounded(swizzle!("xy1_2_",Rect)(pos,275,foo[x][y]),colors[(x+y*2)%$]);
		pos.y+=foo[x][y]+30;
	}}
	return false;
}
void finish() {}
mixin runGame!(ready, update, finish);



//---
auto swizzleargs(string form){
	string o;
	char which;
	int i;
	char c()=>form[i];
	while(i<form.length){
		which='0';
		if(c>='0'&&c<='9'){
			which=c;//cast(int)(c-'0');
			i++;
		}
		o~="args["~which~"]";
		if(c!='_'){
			o~="."~c;
		}
		o~=",";
		i++;
	}
	return o;
}
S swizzle(string form,S,T...)(T args)=>mixin("S("~swizzleargs(form)~")");