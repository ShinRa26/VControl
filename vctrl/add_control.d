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
            const ubyte[] fileContents = cast(const ubyte[])read(filename);
            this.stage ~= new VFile(filename, fileContents);
            saveStage();
        }
    }

private:
    VFile[] stage;
    const string stageFilename = "current_stage.vctrl";

    // Saves the stage to a file
    void saveStage()
    {

    }
}