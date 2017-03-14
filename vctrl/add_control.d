module vctrl.addcontrol;

import std.stdio, std.string, std.file, std.algorithm, std.conv;
import vctrl.vfile, serialize.vserialize;

/*
 * Class for dealing with adding files to the stage
 */
class AddControl
{
public:
    this(VFile[] s)
    {
        this.stage = s;
        this.vserialize = new VSerialize();
    }
    ~this(){}

    // Add all files from the root source to the stage
    void addFromRoot()
    {
        findDir(rootFolder);
        addFromCWD();
    }

    // Add all files in the cwd and all subfolders
    void addFromCWD()
    {
        auto entries = dirEntries(getcwd(), "*.*", SpanMode.breadth);
        foreach(e;entries)
        {       
            string name = to!string(e);
            if(confirmFile(name))
            {
                auto split = name.split("/");
                auto rmFile = split[0..split.length-1];
                auto loc = stripFile(rmFile);

                const ubyte[] fileContents = cast(const ubyte[])read(name);
                this.stage ~= new VFile(name, loc, fileContents);
            }
        }
        saveStage();
    }

    // Adds a single file to the stage
    void addFile(string filename)
    {
        if(!(std.file.exists(filename)))
            writefln("Error: File \'%s\' does not exist.", filename);
        else
        {
            const ubyte[] fileContents = cast(const ubyte[])read(filename);
            this.stage ~= new VFile(filename, getcwd(), fileContents);
            saveStage();
        }
    }

private:
    VFile[] stage;
    VSerialize vserialize;
    const string ignoreFile = ".vctrlignore";
    const string rootFolder = ".vctrl";
    const string stageFolder = "current_stage";

    // Saves the stage to a file
    void saveStage()
    {
        // Move to the .vctrl folder
        findDir(rootFolder);
        chdir(rootFolder~"/"~stageFolder);

        // TODO: Find a half-decent serialisation library - Orange throws errors for some reason
        // Technically not serialization...
        foreach(f;stage)
            vserialize.serialize(f);
    }

    // Scan for a directory
    void findDir(string dir)
    {
        auto entries = dirEntries("", dir, SpanMode.breadth);
        foreach(e; entries)
        {
            if(e[0..$] == dir)
                return; //getcwd()~dir; // Does nothing...but moves to the correct directory regardless
        }
        chdir("..");
        findDir(dir);
    }

    /*
     * Confirms that a file is a legit file to be added
     * Checks ignore file if there is one, else just ignores .git adn object files
     */
     bool confirmFile(string file)
     {
         auto ignore = getIgnoreParams();

         if(ignore == null)
         {
             if(file.isDir || canFind(file, ".git") || canFind(file, ".o") || canFind(file, "ignore"))
             {
                writefln("Ignoring file: %s", file);
                return false;
             }
            return true;
         }
         else
         {
             foreach(i; ignore)
             {
                 if(file.isDir || canFind(file, i) || canFind(file, ".vctrlignore"))
                 {
                    writefln("Ignoring file: %s", file);
                    return false;
                 }
             }
             return true;
         }
     }

     // Gets the Ignore file, returning the contents
     string[] getIgnoreParams()
     {
         if(std.file.exists(ignoreFile))
         {
            string[] params;
            auto ignore = File(ignoreFile);
            foreach(line; ignore.byLine())
            {
                auto elem = to!string(line);
                params~=elem;
            }

            return params;
         }
         return null;
     }

     // Strips the file from the path
     string stripFile(string[] split)
     {
         string path;
         foreach(s;split)
         {
             path~=(s~"/");
         }

         return path;
     }
}