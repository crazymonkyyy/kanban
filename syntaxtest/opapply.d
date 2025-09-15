#!opend -unittest -main -run app.d
import std;

struct foo(T){
	T[] forward;
	T[] back;
	int opApply(int delegate(T) dg){
		assert(forward.length<=back.length);
		int result;
		int i;
		while(i<forward.length){
			result=dg(forward[i++]);
			if(result){break;}
		}
		if(result>1){return result;}
		while(i-->0){
			result=dg(back[i]);
			if(result){break;}
		}
		return result;
}}
unittest{
	foreach(e;foo!int([1,2,3],[4,5,6])){
		e.writeln;
}}
unittest{
	"---".writeln;
	foreach(e;foo!int([1,2,3],[4,5,6])){
		e.writeln;
		if(e==2){break;}
}}
unittest{
	"---".writeln;
	loop:foreach(e;foo!int([1,2,3],[4,5,6])){
		e.writeln;
		if(e==2){break loop;}
}}
unittest{
	"---".writeln;
	loop:foreach(e;foo!int([1,2,3],[4,5,6])){
		e.writeln;
		if(e==3){
			foreach(f;foo!float([12.34,23.45],[34.56,45.67])){
				f.writeln;
		}}
	}
}
unittest{
	"---".writeln;
	loop:foreach(e;foo!int([1,2,3],[4,5,6])){
		e.writeln;
		if(e==3){
			foreach(f;foo!float([12.34,23.45],[34.56,45.67])){
				f.writeln;
				if(f>20){break;}
		}}
	}
}
unittest{
	"---".writeln;
	loop:foreach(e;foo!int([1,2,3],[4,5,6])){
		e.writeln;
		if(e==2){
			loop2: foreach(f;foo!float([12.34,23.45],[34.56,45.67])){
				f.writeln;
				if(f>20){break loop2;}
		}}
	}
}
unittest{
	"---".writeln;
	loop:foreach(e;foo!int([1,2,3],[4,5,6])){
		e.writeln;
		if(e==2){
			loop2: foreach(f;foo!float([12.34,23.45],[34.56,45.67])){
				f.writeln;
				if(f>20){break loop;}
		}}
	}
}
