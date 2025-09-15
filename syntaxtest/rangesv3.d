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
S[][] copystructure(S,T)(T[][] a){
	S[][] o;
	foreach(e;a){
		o~=new S[](e.length);
	}
	return o;
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
unittest{
	//randomarray.each!writeln;
}
int[] randomindexes(T)(T[][] a){
	int[] o;
	foreach(list;a){
		o~=uniform(0,cast(int)list.length);
	}
	return o;
}
unittest{
	//randomarray.randomindexes.writeln;
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
	
auto grabby(T)(T[][] array,int[] indexes){
	return (int x,int y){
		if(y>=indexes.length){return nullable!T();}
		if(indexes[y]+x<0 || indexes[y]+x>=array[y].length){return nullable!T();}
		return nullable!T(array[y][x+indexes[y]]);
	};
}
auto iterate2d_(T)(T[][] array_,int[] indexes,int y_){
	assert(array_.length==indexes.length);
	//auto get_=grabby(array_,indexes);
	struct foreach_{
		T[][] array;
		int y;
		//typeof(get_) get;
		int opApply(int delegate(int,int,int,int) dg){
			int result;
			foreach(y,x;
					insideoutcounter(y,0,indexes.length)
						.map!(a=>zip(repeat(a),
							insideoutcounter(indexes[a[1]],0,array[a[1]].length)))
						.array
						.transposed
						.joiner){
				result=dg(x[0],y[0],//xsign, ysign
						x[1],y[1]);//xindex,yindex
				if(result){break;}
			}
			return result;
		}
	}
	return foreach_(array_,y_);//,get_);
}
auto iterate2d(T)(T[][] array_,int[] indexes_,int y_){
	auto get_=grabby(array_,indexes_);
	struct foreach_{
		T[][] array;
		int[] indexes;
		int y;
		typeof(get_) get;
		int opApply(int delegate(int,int,int,int,ref T,T,T,T,nullable!T) dg){
			int result;
			foreach(xsign,ysign,xindex,yindex;iterate2d_(array,indexes,y)){
				result=dg(xsign,ysign,xindex,yindex,
					array[yindex][xindex],//me
					get(xindex,yindex-ysign).assertget,get(xindex-xsign,yindex).assertget,//xother,yother
					get(xindex-xsign,yindex-ysign).assertget,get(xindex-xsign,yindex+ysign));//cornerbehind,cornerahread
				if(result){break;}
			}
			return result;
	}}
	return foreach_(array_,indexes_,y_,get_);
}
unittest{
	auto foo=randomarray;
	foo.each!writeln;
	auto bar=randomindexes(foo);
	bar.writeln;
	//foreach(xsign,ysign,xindex,yindex;iterate2d(foo,bar,2)){
	//	writeln("xsign:",xsign," ysign:",ysign," xindex:",xindex," yindex",yindex);
	//}
	foreach(xsign,ysign,xindex,yindex,ref me,xother,yother,cornerbehind,cornerahread;iterate2d(foo,bar,2)){
	}
}
