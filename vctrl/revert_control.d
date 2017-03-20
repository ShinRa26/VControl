module vctrl.revert_control;

import std.string, std.conv, std.file, std.algorithm, std.stdio, core.thread;
import serialize.vserialize;
import vctrl.vfile;

/**
 * Class for reverting the current files to their previous commit state
 */
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
        import std.concurrency : spawn;

        moveDir(opFolder);
        moveDir(id);
        string commitFile = to!string(read(id~".vfile"));
        parsedFiles = vs.deserialize(commitFile);
        
        foreach(f; parsedFiles)
        {
            if(f.filename == "")
                continue;
            writeFile(f);
        }
        writefln("Restored %d files.\n", parsedFiles.length);
    }

private:
    VSerialize vs;
    VFile[] parsedFiles;
    const string opFolder = ".vctrl";

    // Writes the VFile out to an actual file
    // TODO: Thread this shit
    void writeFile(VFile vf)
    {
        try
        {
            assert(vf.loc.isDir);

            if(!isFilenamePath(vf.filename))
            {
                version(Posix)
                {
                    vf.filename = vf.loc ~ "/" ~ vf.filename;
                }

                version(Windows)
                {
                    vf.filename = vf.loc ~ "\\" ~ vf.filename;
                }
            }

            auto f = File(vf.filename, "w");
            f.write(cast(string)vf.contents);
            f.close();

            writefln("\nSuccessfully restored file: %s", vf.filename);
        }
        catch(Exception e)
        {
            mkdir(vf.loc);
            writefln("Restored directory: %s", vf.loc);

            if(!isFilenamePath(vf.filename))
            {
                version(Posix)
                {
                    vf.filename = vf.loc ~ "/" ~ vf.filename;
                }
                version(Windows)
                {
                    vf.filename = vf.loc ~ "\\" ~ vf.filename;
                }
            }

            auto f = File(vf.filename, "w");
            f.write(cast(string)vf.contents);
            f.close();

            writefln("\nSuccessfully restored file: %s", vf.filename);
        }
    }

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

    // Checks if the filename is a path or not
    bool isFilenamePath(string fn)
    {
        version(Windows)
        {
            auto split = fn.split("\\");
            return split.length != 1;
        }

        version(Posix)
        {
            auto split = fn.split("/");
            return split.length != 1;
        }
    }
}