#!opend -unittest -main -run app.d
import std;
auto centeriota(T)(T start,T low,T high)=>chain(iota(start,high),iota(low,start).retro);

unittest{
	centeriota(3,0,5).writeln;
	centeriota(4,0,5).writeln;
	centeriota(0,0,5).writeln;
}
auto mapPRO(alias F,R)(R r){
	struct map{
		R r;
		auto front()=>F(r);
		void popFront()=>r.popFront;
		bool empty()=>r.empty;
	}
	return map(r);
}
unittest{
	[1,2,3,4,5].mapPRO!(a=>a.array).writeln;
}
auto debugrange(R)(R r){
	struct dbug{
		R r;
		auto front(){
			writeln("front:",r.front);
			return r.front;
		}
		void popFront(){
			writeln("pop");
			r.popFront;
		}
		bool empty(){
			writeln("empty",r.empty);
			return r.empty;
	}}
	return dbug(r);
}
auto iterate2d(alias FX,alias FY,A)(ref A array){
	auto ys=FY(array).array;
	auto xs=FX(array);
	struct iter{
		typeof(xs) x;
		typeof(ys) y;
		auto front()=>tuple(x.front,y[x.front].front);
		//auto index()=>tuple(x.front,y[x.front].front);
		//ref front()=>array[index[0]][index[1]];
		void popFront(){
			if(x.empty){return;}
			if( ! y[x.front].empty){
				y[x.front].popFront;
				if(y[x.front].empty){
					x.popFront;
				}
				return;
			}
			x.popFront;
		}
		bool empty()=>x.empty;
	}
	return iter(xs,ys);
}
unittest{
	[[1],[2,3],[4,5,6],[7,8,9,10]].iterate2d!(a=>iota(a.length),a=>a.map!(a=>iota(a.length))).writeln;
}
