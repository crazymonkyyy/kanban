#!/usr/bin/env -S dmd -i -run
import std;

void main(string[] args){
	if(args.length<2||args.length>4){
		writeln("Usage: corrupt <file> [corruption_rate] [output_file]");
		writeln("  file            - Input file to corrupt");
		writeln("  corruption_rate - Percentage chance per character (default: 5)");
		writeln("  output_file     - Output file (default: <file>.corrupted)");
		writeln("");
		writeln("Examples:");
		writeln("  corrupt TODO.kantban           # 5% corruption, saves to TODO.kantban.corrupted");
		writeln("  corrupt TODO.kantban 10        # 10% corruption");
		writeln("  corrupt TODO.kantban 15 bad.kantban  # 15% corruption to bad.kantban");
		return;
	}

	string inputFile=args[1];
	int corruptionRate=args.length>=3?args[2].to!int:5;
	string outputFile=args.length>=4?args[3]:inputFile~".corrupted";

	// Minimal error handling following original style
	assert(exists(inputFile),"Input file not found");
	assert(corruptionRate>=0&&corruptionRate<=100,"Corruption rate must be between 0 and 100");

	writeln("Corrupting file: ",inputFile);
	writeln("Corruption rate: ",corruptionRate,"%");
	writeln("Output file: ",outputFile);

	string content=readText(inputFile);
	string corrupted=corruptText(content,corruptionRate);

	std.file.write(outputFile,corrupted);

	writeln("Corruption complete!");
	writeln("Original size: ",content.length," characters");
	writeln("Corrupted size: ",corrupted.length," characters");
	writeln("Size change: ",cast(int)corrupted.length-cast(int)content.length);
}

string corruptText(string text,int corruptionRate){
	string result;
	int insertions=0;
	int deletions=0;
	int substitutions=0;

	// ASCII printable characters for random insertions
	string printableASCII=" !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";

	foreach(i,char c;text){
		// Random corruption chance per character
		if(uniform(0,100)<corruptionRate){
			int corruptionType=uniform(0,4);

			switch(corruptionType){
			case 0: // Delete character
				deletions++;
				// Skip adding this character (deletion)
				break;

			case 1: // Insert random character before
				char randomChar=printableASCII[uniform(0,printableASCII.length)];
				result~=randomChar;
				result~=c;
				insertions++;
				break;

			case 2: // Substitute character
				char randomChar=printableASCII[uniform(0,printableASCII.length)];
				result~=randomChar;
				substitutions++;
				break;

			case 3: // Insert after
				char randomChar=printableASCII[uniform(0,printableASCII.length)];
				result~=c;
				result~=randomChar;
				insertions++;
				break;

			default:
				result~=c;
				break;
			}
		}
		else{
			// No corruption, keep original character
			result~=c;
		}
	}

	writeln("Corruptions applied:");
	writeln("  Insertions: ",insertions);
	writeln("  Deletions: ",deletions);
	writeln("  Substitutions: ",substitutions);
	writeln("  Total: ",insertions+deletions+substitutions);

	return result;
}
