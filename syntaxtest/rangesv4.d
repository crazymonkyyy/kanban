#!opend -unittest -main -run app.d
import std;
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
unittest{
	//insideoutcounter2(3,5).map!(a=>a+3).writeln;
}
float[][] randomarray(){
	float[][] o;
	foreach(i;0..uniform(3,10)){
		o~=new float[](uniform(3,10));
		foreach(ref e;o[$-1]){
			e=uniform(10.0,99);
	}}
	return o;
}
int[] randomindexes(T)(T[][] a){
	int[] o;
	foreach(list;a){
		o~=uniform(0,cast(int)list.length);
	}
	return o;
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
bool between(I,J,K)(I a,J b,K c){
	return a>=b && a<c;
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
			foreach(y,x;
					insideoutcounter2(yindex,array.length)
					.map!(a=>zip(repeat(a),
						insideoutcounter2(indexes[a+yindex],array[a+yindex].length)))
					.array.transposed.joiner){
				result=dg(x,y,refget(x,y));
				if(result){break;}
			}
			return result;
		}
	}
	return transposed(array_,indexes_,y_);
}
unittest{
	auto foo=randomarray;
	auto bar=randomindexes(foo);
	foo.each!writeln;
	bar.writeln;
	
	zip(foo,bar.map!(a=>repeat("       |").take(7-a)))
		.each!((a){a[1].joiner.write;a[0].each!writefloat;writeln;});
	auto foobar=offsettransposed(foo,bar,2);
	//foobar[0,0].writeln;
	//foobar[-1,-1].writeln;
	//foobar[0,-1].writeln;
	//foobar[1,-1].writeln;
	//foobar[1,1].writeln;
	foreach(x,y,ref me;foobar){
		me.writefloat;
	}
}
void writefloat(float f){
	auto w1 = appender!string();
	formatValue(w1, f,singleSpec("%.3f"));
	std.stdio.write(w1.data,", ");
}
unittest{
	3.14.writefloat;
}