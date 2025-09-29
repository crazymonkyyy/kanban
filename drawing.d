import format;
import parin;
void draw(todolist[][] data,int[] x,int y){
	data[0][0].draw(Vec2(300,300));
}
Vec2 estimate(todolist data)=>Vec2(450,900);
void draw(todolist data, Vec2 where){
	auto e=estimate(data);
	auto r=Rect(where.x,where.y,e.x,e.y);
	drawrounded(r,red);
	data.title.drawtitle(r);
}
enum roundness=90.0;
enum background=cyan;
void drawrounded(Rect r, Color c){
	float round=roundness/min(r.size.x,r.size.y);
	rl.DrawRectangleRounded(r.toRl,round,9,background.toRl);
	rl.DrawRectangleRoundedLinesEx(r.toRl,round,9, 10,c.toRl);
}
void drawtitle(string s,Rect r){
	drawRect(Rect(r.x+15,r.y+15,300,30));
}
void drawitem(int i,string s,bool crossed,Rect r){
	
}
