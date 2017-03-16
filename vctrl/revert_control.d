module vctrl.revert_control;

import std.string, std.conv, std.file, std.algorithm, std.stdio;
import serialize.vserialize;
import vctrl.vfile;

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
        parsedFiles = vs.deserialize();
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