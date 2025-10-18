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
	//---
	auto rects_=copystructure!Rect(sizes);
	auto rects=offsettransposed(rects_,x,y);
	auto sizes_=offsettransposed(sizes,x,y);
	//---
	foreach(x,y,ref me;rects){
		float offsety=0;
		if(sign(y)==0){
			offsety=500;
		} else {
			offsety+=rects[x,y-sign(y)].y;//find relivant other rect, and start with thier position
			offsety+=sign(y)*30;//y gap
			offsety+=(sign(y)>0)?//below?
				rects[x,y-sign(y)].size.y://if below, the height of above matters
				-sizes_[x,y].y;//if above, move myself up
		}
		float offsetx=0;
		if(sign(x)==0){
			offsetx=500;
		} else {
			offsetx+=minmax(//todo: 3 push rects?
				rects[x-sign(x),y].leftorright(sign(x)),
				rects[x-sign(x),y-sign(y).tiebreak].leftorright(sign(x)))
					[sign(x)>0];
			offsetx+=sign(x)*30;
			offsetx+=(sign(x)>0)?
				0://rects[x-sign(x),y].size.x:
				-sizes_[x,y].x;
		}
		me=Rect(offsetx,offsety,sizes_[x,y].x,sizes_[x,y].y);
	}
	foreach(yi,list;rects_){
	foreach(xi,e;list){
		drawrounded(e,colors[(yi*2+xi)%$]);
	}}
	return false;
}
void finish() {}
mixin runGame!(ready, update, finish);
//---
auto minmax(T)(T a,T b){
	if(a<b){return [a,b];}
	return [b,a];
}
bool between(I,J,K)(I a,J b,K c){
	return a>=b && a<c;
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
auto insideoutcounter(I,J,K)(I i,K k,J j){
	int i_=cast(int)i;
	int j_=cast(int)j;
	int k_=cast(int)k;
	return chain(
		zip(repeat(0),iota(i_,i_+1)),
		zip(repeat(1),iota(i_+1,j_)),
		zip(repeat(-1),iota(k_,i_).retro));
}
auto insideoutcounter2(J,K)(K k,J j){
	int i_=0;
	int j_=cast(int)j-cast(int)k;
	int k_=-cast(int)k;
	return chain(
		iota(i_,i_+1),
		iota(i_+1,j_),
		iota(k_,i_).retro);
}
auto insideoutcounter3(J,K)(K k,J j){
	int i_=0;
	int j_=cast(int)j;
	int k_=-cast(int)k;
	return chain(
		iota(i_,i_+1),
		iota(i_+1,j_),
		iota(k_,i_).retro);
}
struct nullable(T){
	T get;alias get this;
	bool isnull=true;
	this(T t){
		get=t;
		isnull=false;
	}
	T assertget(){
		assert( ! isnull);
		return get;
	}
}
auto offsettransposed(T)(T[][] array_,int[] indexes_,int y_){
	assert(array_.length<=indexes_.length,"indexes must be as long as the arrays");
	struct transposed{
		T[][] array;
		int[] indexes;
		int yindex;
		auto opIndex(I,J)(I x,J y){
			y+=yindex;
			if( ! y.between(0,array.length)){return nullable!T();}
			x+=indexes[y];
			if( ! x.between(0,array[y].length)){return nullable!T();}
			return nullable!T(array[y][x]);
		}
		ref refget(I,J)(I x,J y){
			y+=yindex;
			x+=indexes[y];
			return array[y][x];
		}
		auto opApply(int delegate(int,int,ref T) dg){
			int result;
			foreach(x;insideoutcounter3(indexes.maxElement,
					//zip(array,indexes).map!(a=>cast(int)a[0].length-a[1]).maxElement)){
					array.map!(a=>a.length).maxElement)){
				//assert(x<10&&x>-10);
				//x.writeln;
				foreach(y;insideoutcounter2(yindex,array.length)){
					auto me=opIndex(x,y);
					if( ! me.isnull){
						result=dg(x,y,refget(x,y));
						if(result){break;}
					}
				}
			}
			return result;
		}
	}
	return transposed(array_,indexes_,y_);
}
ref clampindex(T,I)(T[] a,ref I i){
	if(i<0 || i==I.max){i=0;}
	if(i>=a.length){i=cast(I)a.length-1;}
	return a[i];
}