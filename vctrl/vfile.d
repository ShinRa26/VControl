module vctrl.vfile;

import std.string, std.stdio, std.file;

class VFile
{
public:
    this(string filename, const ubyte[] contents)
    {   
        this.filename = filename;
        this.contents = contents;
    }
    ~this(){}

private:
    const string filename;
    // All the data contained within the file
    const ubyte[] contents;
}