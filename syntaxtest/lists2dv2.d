#!/bin/env -S opend -run app.d
import parin;
import std.random;
import std.conv;
void ready() {
	sizes.data.length=5;
	foreach(x;0..5){
		sizes[x].data.length=5;
	foreach(y;0..5){
		sizes[x][y]=uniform(30,300).to!float;
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
cursor!(cursor!float) sizes;
bool update(float dt) {
	sizes.index+=Keyboard.down.isPressed-Keyboard.up.isPressed;
	sizes[0].index+=Keyboard.right.isPressed-Keyboard.left.isPressed;
	auto rects=sizes.copystructure!Rect;
	foreach(y,list;sizes.forwardthenback.foreachhack){
	foreach(x,e;list.forwardthenback.foreachhack){
		float offset=0;
		if(y==0){
			offset=300;
		} else {
			Rect other=rects[y-sign(y)][x];
			offset=other.y+sign(y)*40+10;
			if(sign(y)==1){
				offset+=other.size.y;
			} else {
				offset-=sizes[y][x];
			}
		}
		rects[y][x]=Rect((x+1)*300,offset,280,sizes[y][x]);
		drawrounded(rects[y][x],white);
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
struct cursor(T){
	T[] data; alias data this;
	int index;
	ref opIndex(int i){
		return data[min($-1,max(0,i+index))];
	}
	auto forward(){
		struct range{
			T[] data;
			int index;
			ref T front()=>data[0];
			void popFront(){
				data=data[1..$];
				index++;
			}
			bool empty()=>data.length==0;
		}
		return range(data[index..$],0);
	}
	auto back(){
		struct range{
			T[] data;
			int index;
			ref T front()=>data[$-1];
			void popFront(){
				data=data[0..$-1];
				index--;
			}
			bool empty()=>data.length==0;
		}
		return range(data[0..index],-1);
	}
	auto forwardthenback()=>chain(forward,back);
}
cursor!(cursor!S) copystructure(S,T)(cursor!(cursor!T) a){
	cursor!(cursor!S) o;
	o.index=a.index;
	foreach(e;a){
		o.data~=cursor!S(new S[](e.data.length),e.index);
		//o[$-1].index=e.index;
	}
	return o;
}
auto foreachhack(R)(R r){
	struct foreach_{
		R r;
		int opApply(int delegate(typeof(r.index()) i,typeof(r.front()) e) dg){
			int result;
			while( ! r.empty){
				result=dg(r.index,r.front);
				if(result){break;}
				r.popFront;
			}
			return result;
		}
	}
	return foreach_(r);
}
auto chain(R1,R2)(R1 r1,R2 r2){
	struct range{
		R1 r1;R2 r2;
		ref front()=>r1.empty?r2.front:r1.front;
		auto index()=>r1.empty?r2.index:r1.index;//difference
		void popFront(){
			if( ! r1.empty){
				r1.popFront;
			} else {
				r2.popFront;
		}}
		bool empty()=>r1.empty&&r2.empty;
	}
	return range(r1,r2);
}