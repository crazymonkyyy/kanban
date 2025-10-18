#!/bin/env -S opend -run app.d
import parin;
import std;
enum speed=300;
struct animatedvec2{
	Vec2 a,b;
	float where=0;
	float total()=>a.distanceTo(b)/speed;
	Vec2 get(){
		return Vec2(
			smoothstep(a.x,b.x,where<total?where/total:1),
			smoothstep(a.y,b.y,where<total?where/total:1)
	);}
	void opAssign(Vec2 o){
		a=get;
		b=o;
		where=0;
	}
	void poke(float dt){where+=dt;}
	alias get this;
}
animatedvec2 foo;
void ready() {
	//lockResolution(320, 180);
}
bool update(float dt) {
	if(Mouse.left.isPressed){
		foo=mouse;
	}
	foo.poke(dt);
	drawCirc(Circ(foo,10));
	return false;
}
void finish() {}
mixin runGame!(ready, update, finish);