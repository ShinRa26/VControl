module vctrl.vfile;

import std.string, std.stdio, std.file, std.conv;

class VFile
{
public:
    this(string filename, string loc, string data)
    {   
        this.filename = filename;
        this.loc = loc;
        this.contents = cast(ubyte[])data;
    }
    ~this(){}

private:
    const string filename;
    const string loc;
    const ubyte[] contents;
}