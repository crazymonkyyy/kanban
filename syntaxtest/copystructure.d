#!opend -unittest -main -run app.d

S[][] copystructure(S,T)(T[][] a){
	S[][] o;
	foreach(e;a){
		o~=new S[](e.length);
	}
	return o;
}
unittest{
	import std;
	[[1,2,3],[4,5],[],[9]].copystructure!bool.writeln;
}
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
	//auto forwardthenback()=>chain(forward,back);
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
unittest{
	cursor!(cursor!int) foo;
	foo.data~=cursor!int([1,2,3],1);
	foo.data~=cursor!int([4,5,6,7],2);
	foo.data~=cursor!int([8,9],1);
	foo.index=1;
	auto bar=foo.copystructure!bool;
	bar.writeln;
	bar.index.writeln;
	bar[-1].index.writeln;
}
