#!opend -unittest -main -run app.d
import parin;
import std;
//hard fail
int[] x;
int y;
Rect[][] sizes;
void ready() {
	foreach(i;0..uniform(3,10)){
		sizes~=new Rect[](uniform(3,10));
		x~=0;
		foreach(ref e;sizes[$-1]){
			e.size.y=uniform(30.0,100);
			e.size.x=300;
		}
	}
	sizes.writeln;
}
bool update(float dt) {
	//auto rects=sizes.copystructure!Rect;
	y+=Keyboard.down.isPressed-Keyboard.up.isPressed;
	x[y]+=Keyboard.right.isPressed-Keyboard.left.isPressed;
	foreach(ref y_,ref list,ref oldlist;sizes.insideout(y)){
	foreach(ref x_,ref e,ref other;list.insideout(x[y])){
		float offset=0;
		if(y==0){
			offset=300;
		} else {
			offset=other.y+sign(y_)*40+10;
			if(sign(y)==1){
				offset+=other.size.y;
			} else {
				offset-=other.size;
			}
		}
		e=Rect((x+1)*300,offset,280,sizes[y_][x_]);
		drawrounded(rects[y][x],white);
	}}
	return false;
}
void finish() {}
mixin runGame!(ready, update, finish);
//---
enum roundness=90.0;
enum background=black;
void drawrounded(Rect r, Color c){
	float round=roundness/parin.min(r.size.x,r.size.y);
	rl.DrawRectangleRounded(r.toRl,round,9,background.toRl);
	rl.DrawRectangleRoundedLinesEx(r.toRl,round,9, 10,c.toRl);
}
Color[8] colors=[red,green,blue,yellow,pink,cyan,orange,brown];
auto insideout(R,I)(R r,I i){
	struct foreach_{
		R r;
		I i;
		alias E=typeof(r[i]);
		int opApply(int delegate(ref I i,ref E a,ref E b) dg){
			int result=dg(i,r[i],r[i]);
			I j=i+1;
			if(result>1) {goto exit;}
			while(j<r.length){
				result=dg(j,r[j],r[j-1]);
				if(result){
					if(result==1){break;}
					goto exit;
				}
				j++;
			}
			j=i-1;
			while(j>=0){
				result=dg(j,r[j],r[j+1]);
				if(result){
					break;
				}
				j--;
			}
			exit:return result;
		}
	}
	return foreach_(r,i);
}
S[][] copystructure(S,T)(T[][] a){
	S[][] o;
	foreach(e;a){
		o~=new S[](e.length);
	}
	return o;
}