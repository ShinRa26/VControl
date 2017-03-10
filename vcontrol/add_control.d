module vctrl.addcontrol;

import std.stdio, std.string, std.file;
import vctrl.vfile;

class AddControl
{
public:
    this(VFile[] s)
    {
        this.stage = s;
    }
    ~this(){}

private:
    VFile[] stage;
}