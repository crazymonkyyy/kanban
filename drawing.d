import format;
import parin;
import configs;
FontId textfont;
FontId titlefont;
//static this(){
void initdrawing(){
	//setIsUsingAssetsPath(false); //I set to false in engine
	textfont=loadFont(textfontpath(),textsize);
	assert(textfont.isValid);
	titlefont=loadFont(titlefontpath(),textsize+textsize/3);
	assert(titlefont.isValid);
}

void draw(todolist[][] data,int[] xs,int ys){
	foreach(y,list;data){
	foreach(x,e;list){
		e.draw(Vec2(300*(x-xs[ys]),300*(y-ys)));
	}}
	//data[0][0].draw(Vec2(300,300));
}
Vec2 estimate(todolist data)=>Vec2(450,900);
void draw(todolist data, Vec2 where){
	data.sanitize;
	auto e=estimate(data);
	auto r=Rect(where.x,where.y,e.x,e.y);
	drawrounded(r,red);
	data.title.drawtitle(r);
	import std;
	foreach(i;0..cast(int)data.items.length){
		drawitem(i,data.items[i],data.crossed[i],r);
	}
}
enum roundness=90.0;
enum background=cyan;
void drawrounded(Rect r, Color c){
	float round=roundness/min(r.size.x,r.size.y);
	rl.DrawRectangleRounded(r.toRl,round,9,background.toRl);
	rl.DrawRectangleRoundedLinesEx(r.toRl,round,9, 10,c.toRl);
}
void drawtitle(string s,Rect r){
	//drawRect(Rect(r.x+15,r.y+15,300,30));
	drawText(titlefont,s,Vec2(r.x+15,r.y+15));
}
void drawitem(int i,string s,bool crossed,Rect r){
	Vec2 where=Vec2(r.x+20,r.y+i*25+40);
	drawText(textfont,s,where);
}
