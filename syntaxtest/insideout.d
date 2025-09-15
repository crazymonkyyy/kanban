#!opend -unittest -main -run app.d
import std;
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

unittest{
	lable: foreach(ref index,ref me,ref other;[1,2,3,4,5,6,7,8].insideout(2)){
		writeln(me,',',other);
		if(me==5){break;}
	}
	"end".writeln;
}

unittest{
	int[] output;
	foreach(ref index,ref me,ref other;iota(10).insideout(3)){
		output~=me;
	}
	assert(output==[3, 4, 5, 6, 7, 8, 9, 2, 1, 0]);
}
