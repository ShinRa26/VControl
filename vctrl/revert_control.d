module vctrl.revert_control;

import std.string, std.conv, std.file, std.algorithm, std.stdio;
import serialize.vserialize;
import vctrl.vfile;

/**
 * Class for reverting the current files to their previous commit state
 */
class RevertControl
{
public:
    this()
    {
        this.vs = new VSerialize();
    }
    ~this(){}

    // Reverts the files back to their original state
    void revert(string id)
    {
        moveDir(opFolder);
        moveDir(id);
        string commitFile = to!string(read(id~".vfile"));
        // parsedFiles = vs.deserialize(fileData);

        auto split = commitFile.split("</File>");
        auto blah = split[0].split("\n");
        string contents;
        for(int i = 0; i < blah.length; i++)
        {
            if(canFind(blah[i], "<Contents>"))
                contents = blah[i+1];
        }
        auto cSplit = contents.split(",");
    }

private:
    VSerialize vs;
    VFile[] parsedFiles;
    const string opFolder = ".vctrl";


    // Scan for a directory - Has to be done in a stepwise fashion
    void moveDir(string dir)
    {
        auto entries = dirEntries("", dir, SpanMode.breadth);
        foreach(e; entries)
        {
            if(e[0..$] == dir)
            {
                chdir(e);
                return;
            } 
        }
        chdir("..");
        moveDir(dir);
    }
}