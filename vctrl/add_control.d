module vctrl.addcontrol;

import std.stdio, std.string, std.file;
import vctrl.vfile, serialize.serialize;

class AddControl
{
public:
    this(VFile[] s)
    {
        this.stage = s;
        this.serialize = new Serialize();
    }
    ~this(){}

    // Add all files in the cwd and all subfolders
    void addFromCWD()
    {

    }

    // Add all files from the root source to the stage
    void addFromRoot()
    {

    }

    // Adds a single file to the stage
    void addFile(string filename)
    {
        if(!(exists(filename)))
            writefln("Error: File %s does not exist.", filename);
        else
        {
            // TODO: Fix this for the new string implementation
            const ubyte[] fileContents = cast(const ubyte[])read(filename);
            this.stage ~= new VFile(filename, getcwd(), fileContents);
            saveStage();
        }
    }

private:
    VFile[] stage;
    Serialize serialize;
    const string rootFolder = ".vctrl";
    const string stageFolder = "current_stage";

    // Saves the stage to a file
    void saveStage()
    {
        // Move to the .vctrl folder
        findDir(rootFolder);
        chdir(rootFolder~stageFolder);

        // TODO: Find a half-decent serialisation library
        foreach(f;stage)
            serialize.serialize();
    }

    // Scan for a directory
    void findDir(string dir)
    {
        auto entries = dirEntries("", dir, SpanMode.breadth);
        foreach(e; entries)
        {
            if(e[0..$] == dir)
                return getcwd()~dir;
        }
        chdir("..");
        findDir(dir);
    }
}