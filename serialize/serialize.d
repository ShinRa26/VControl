module serialize.serialize;

import std.stdio, std.conv, std.file, std.format;
import vfile;

class Serialize
{
public:
    this(){}
    ~this(){}

    void serialize(VFile f)
    {
        auto header = "<File>\n\t";
        auto filename = "<Filename>\n\t\t%s\n\t</Filename>\n\t".format(f.filename);
        auto loc = "<FileLocation>\n\t\t\'%s\'\n\t</FileLocation>\n\t".format(f.loc);
        auto contents = "<Contents>\n\t\t";
        foreach(b;f.contents)
        {
            auto temp = "%s,".format(to!string(b));
            contents~=temp;
        }
        auto endContents = "\n\t</Contents>\n";
        auto endHeader = "</File>";

        auto fullFile = header~filename~loc~contents~endContents~endHeader;


        // TODO: Point towards the .vctrl folder
        auto file = File(f.filename~=fileExt, "w");
        file.write(fullFile);
        file.close();
    }

    // "Deserialise the generated files" -- Mainly for revert
    void deserialize()
    {
        // TODO: Implement
    }

private:
    const string fileExt = ".vfile";
}
