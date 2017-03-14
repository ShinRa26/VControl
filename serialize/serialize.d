module serialize.vserialize;

import std.stdio, std.conv, std.file, std.format;
import vctrl.vfile;

class VSerialize
{
public:
    this(){}
    ~this(){}

    // Compacts the data of a VFile and writes it to the .vctrl root folder
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
        auto endHeader = "</File>\n\n";

        auto fullFile = header~filename~loc~contents~endContents~endHeader;

        // If stage file exists, append. If not, create
        if(std.file.exists(stageFile))
        {
            auto file = File(stageFile, "a");
            file.write(fullFile);
            file.close();
        }
        else
        {
            auto file = File(stageFile, "w");
            file.write(fullFile);
            file.close();
        }
    }

    // "Deserialise the generated files" -- Mainly for revert
    void deserialize()
    {
        // TODO: Implement
    }

private:
    const string stageFile = "stage.vfile";
}
