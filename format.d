import std;

struct todolist{
	string title;
	string[] items;
	bool[] crossed;
	void sanitize(){
		if(crossed.length<items.length){
			crossed.length=items.length;
		}
	}
}

todolist[][] openkantban(string where){
	if(!exists(where))
		return [];
	todolist[][] result;
	todolist[] col;
	todolist cur;
	foreach(line;File(where).byLineCopy){
		if(line.startsWith("# ")){
			if(cur.title.length)
				col~=cur;
			if(col.length)
				result~=col;
			col=[];
			cur=todolist();
		}
		else if(line.startsWith("## ")){
			if(cur.title.length)
				col~=cur;
			cur=todolist(line[3..$].idup);
		}
		else if(line.startsWith("- ")){
			bool done=false;
			string item;

			// Check for various checkbox formats
			if(line.length>=6&&line[2]=='['&&line[4]==']'){
				// Format: "- [x]" or "- [ ]"
				done=(line[3]=='x'||line[3]=='X');
				item=line.length>6?line[6..$].strip.idup:"";
			}
			else if(line.length>=7&&line[2]=='['&&line[5]==']'){
				// Format: "- [x ]" or "- [ x]" - flexible spacing
				done=(line[3]=='x'||line[3]=='X'||line[4]=='x'||line[4]=='X');
				item=line.length>7?line[7..$].strip.idup:"";
			}
			else{
				// Plain format: "- item"
				item=line.length>2?line[2..$].strip.idup:"";
				done=false;
			}

			cur.items~=item;
			cur.crossed~=done;
		}
	}
	if(cur.title.length)
		col~=cur;
	if(col.length)
		result~=col;
	return result;
}

void savekantban(todolist[][] data,string where){
	auto f=File(where,"w");
	foreach(col;data){
		f.writeln("# Column");
		foreach(card;col){
			f.writeln("## ",card.title);
			foreach(i,item;card.items){
				bool done=i<card.crossed.length&&card.crossed[i];
				f.writeln(done?"- [x] ":"- [ ] ",item);
			}
		}
	}
}
