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
	initpalette();
}

int colorindex(int x,int y)=>x+y*2;

void draw(todolist[][] data,int[] xs,int ys){
	auto r=estimate(data[0][0]);
	foreach(int y,list;data){
	foreach(int x,e;list){
		e.draw(Vec2((r.x+r.x/5)*(x-xs[ys]),(r.y+r.y/5)*(y-ys)),colorindex((x-xs[ys]),(y-ys)));
	}}
	//data[0][0].draw(Vec2(300,300));
}
Vec2 estimate(todolist data)=>Vec2(300,400);
void draw(todolist data, Vec2 where, int colorindex){
	data.sanitize;
	auto e=estimate(data);
	auto r=Rect(where.x,where.y,e.x,e.y);
	drawrounded(r,red,cyan);
	data.title.drawtitle(r);
	import std;
	foreach(i;0..cast(int)data.items.length){
		drawitem(i,data.items[i],data.crossed[i],r);
	}
}
enum roundness=90.0;
//enum background=cyan;
void drawrounded(Rect r, Color c1,Color c2){
	float round=roundness/min(r.size.x,r.size.y);
	rl.DrawRectangleRounded(bk.toRl(r),round,9,bk.toRl(c2));
	rl.DrawRectangleRoundedLinesEx(bk.toRl(r),round,9, 10,bk.toRl(c1));
}
void drawtitle(string s,Rect r){
	//drawRect(Rect(r.x+15,r.y+15,300,30));
	drawText(titlefont,s,Vec2(r.x+15,r.y+15));//,palette[7]);
}
void drawitem(int i,string s,bool crossed,Rect r){
	Vec2 where=Vec2(r.x+20,r.y+i*25+40);
	drawText(textfont,s,where);
}
