#!opend -unittest -main -run app.d
import std;

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
void print(R)(R r){
	while( ! r.empty){
		writeln(r.index,":",r.front);
		r.popFront;
}}
unittest{
	auto foo=cursor!int([1,2,4,3,5],2);
	foo[0].writeln;
	foo.index++;
	foo[0].writeln;
	foo[-1].writeln;
	foo.forward.writeln;
	foo.back.writeln;
	foo.forwardthenback.writeln;
	foo.forwardthenback.print;
	foo.index=0;
	foo.forward.writeln;
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
unittest{
	cursor!(cursor!int) foo;
	foo.data~=cursor!int([1,2,3],1);
	foo.data~=cursor!int([4,5,6,7],2);
	foo.data~=cursor!int([8,9],1);
	foo.index=1;
	foreach(y,list;foo.forwardthenback.foreachhack){
	foreach(x,e;list.forwardthenback.foreachhack){
		writeln('(',x,',',y,')',e,foo[y][x]==e);
	}}
}