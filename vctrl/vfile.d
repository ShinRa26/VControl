module vctrl.vfile;

import std.string, std.stdio, std.file, std.conv;

class VFile
{
public:
    this(string filename, string loc, const ubyte[] contents)
    {   
        this.filename = filename;
        this.loc = loc;
        this.contents = contents;
    }
    ~this(){}

    const string filename;
    const string loc;
    const ubyte[] contents;
}