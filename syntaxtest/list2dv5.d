#!opend -unittest -main -run app.d
import parin;
import std;
int[] x;
int y;
Vec2[][] sizes;
void ready() {
	foreach(i;0..uniform(3,10)){
		sizes~=new Vec2[](uniform(3,10));
		x~=0;
		foreach(ref e;sizes[$-1]){
			e.y=uniform(100.0,300);
			e.x=uniform(300.0,400);
		}
	}
	sizes.writeln;
}
bool update(float dt) {
	assert(x.length==sizes.length);
	y+=Keyboard.down.isPressed-Keyboard.up.isPressed;
	x.clampindex(y)+=Keyboard.right.isPressed-Keyboard.left.isPressed;
	drawDebugText(x[y].to!string,Vec2(0,0));
	sizes.clampindex(y).clampindex(x[y]);
	auto rects=sizes.copystructure!Rect;
	ref Rect other(int x_,int y_,int signx,int signy){
		x_-=x[y_];
		y_-=signy;
		x_-=signx;
		x_+=x.clampindex(y_);
		auto output=&rects.clampindex(y_).clampindex(x_);
		assert(output.size.x>0);
		return *output;
	}
	foreach(ysign,yi;insideoutcounter(y,sizes.length)){
	foreach(xsign,xi;insideoutcounter(x[yi],sizes[yi].length)){
		float offsety=0;
		if(ysign==0){
			offsety=500;
		} else {
			offsety+=other(xi,yi,0,ysign).y;//find relivant other rect, and start with thier position
			offsety+=ysign*30;//y gap
			//offsety+=(yi-ysign==y)*50*ysign;//extra gap
			offsety+=(ysign>0)?//below?
				other(xi,yi,0,ysign).size.y://if below, the height of above matters
				-sizes[yi][xi].y;//if above, move myself up
		}
		float offsetx=0;
		if(xsign==0){
			offsetx=500;
		} else {
			offsetx+=minmax(
				other(xi,yi,xsign,0).leftorright(xsign),
				other(xi,yi,xsign,ysign.tiebreak).leftorright(xsign))
					[xsign>0];
			offsetx+=xsign*30;
			//offsetx+=(xsign>0)?
			//	other(xi,yi,xsign,0).size.x:
			//	-sizes[yi][xi].x;
			//offsetx-=(xsign<0)*sizes[yi][xi].x;
		}
		rects[yi][xi]=Rect(offsetx,offsety,sizes[yi][xi].x,sizes[yi][xi].y);
	}}
	foreach(yi,list;rects){
	foreach(xi,e;list){
		drawrounded(e,colors[(yi*2+xi)%$]);
	}}
	if(Keyboard.enter.isPressed){
		rects.joiner.each!(a=>a.position.x.writeln);
		stdout.flush;
	}
	//drawDebugText(x[y].to!string,Vec2(0,0));
	//drawDebugText(y.to!string,Vec2(0,20));
	return false;
}
void finish() {}
mixin runGame!(ready, update, finish);
//---
int opCmp(int a,int b){
	if(a<b){return -1;}
	return a>b;
}
unittest{
	assert(3.opCmp(5)==-1);
	assert(3.opCmp(3)==0);
	assert(3.opCmp(1)==1);
}
auto minmax(T)(T a,T b){
	if(a<b){return [a,b];}
	return [b,a];
}
auto leftorright(Rect r,int sign){
	if(sign>0){
		return r.position.x+r.size.x;
	}
	return r.position.x;
}
auto tiebreak(int i)=>i==0?1:i;
enum roundness=90.0;
enum background=black;
void drawrounded(Rect r, Color c){
	if(r.position.x.isNaN){
		"nan".writeln;
	}
	float round=roundness/parin.min(r.size.x,r.size.y);
	rl.DrawRectangleRounded(r.toRl,round,9,background.toRl);
	rl.DrawRectangleRoundedLinesEx(r.toRl,round,9, 10,c.toRl);
}
Color[8] colors=[red,green,blue,yellow,pink,cyan,orange,brown];
S[][] copystructure(S,T)(T[][] a){
	S[][] o;
	foreach(e;a){
		o~=new S[](e.length);
	}
	return o;
}
auto insideoutcounter(I,J)(I i,J j){
	int i_=cast(int)i;
	int j_=cast(int)j;
	return chain(
		zip(repeat(0),iota(i_,i_+1)),
		zip(repeat(1),iota(i_+1,j_)),
		zip(repeat(-1),iota(0,i_).retro));
}
ref clampindex(T,I)(T[] a,ref I i){
	if(i<0 || i==I.max){i=0;}
	if(i>=a.length){i=cast(I)a.length-1;}
	return a[i];
}