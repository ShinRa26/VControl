module serialize.vserialize;

import std.stdio, std.conv, std.file, std.format, std.string, std.algorithm;
import vctrl.vfile;

/**
 * Class for "serializing" a VFile object and "deserializing" a commit file
 */
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
        // TODO: Implement a check for duplicate files
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
    VFile[] deserialize(string fileData)
    {
        auto fileSplit = fileData.split("</File>");
        foreach(file; fileSplit)
        {
            VFile rFile = parseSingleFile(file);
            if(rFile is null)
                continue;
            revertFiles~=rFile;
        }

        return revertFiles;
    }

private:
    VFile[] revertFiles;
    const string stageFile = "stage.vfile";

    // Parses a data string to extract the necessary information to build a VFile -- For Revert only
    VFile parseSingleFile(string data)
    {
        ubyte[] fileContents;
        auto dataSplit = data.split("\n");
        string filename, fileLocation, stringContents;

        try
        {
            for(int i = 0; i < dataSplit.length; i++)
            {
                if(canFind(dataSplit[i], "<Filename>"))
                {
                    const auto tabSplit = dataSplit[i+1].split("\t");
                    filename = tabSplit[tabSplit.length-1];
                }
                else if(canFind(dataSplit[i], "<FileLocation>"))
                {
                    if(canFind(dataSplit[i+1], "''"))
                    {
                        auto loc = stripLocation(filename);
                        auto tabSplit = loc.split("\t");
                        auto markSplit = tabSplit[tabSplit.length-1].split("'");
                        fileLocation = markSplit[markSplit.length-2];
                    }
                    else
                    {
                        auto tabSplit = dataSplit[i+1].split("\t");
                        auto markSplit = tabSplit[tabSplit.length-1].split("'");
                        fileLocation = markSplit[markSplit.length-2];
                    }
                }
                else if(canFind(dataSplit[i], "<Contents>"))
                    stringContents = dataSplit[i+1];
            }
        }
        catch(core.exception.RangeError)
        {
            writeln("Error in parsing the file contents. Have you been fucking about with the commit file!?");
        }

        fileContents = parseBytes(stringContents);

        if(filename == "" || fileLocation == "" || fileContents is null)
            return null;

        return new VFile(filename, fileLocation, fileContents);
    }

    // Parses the file contents string back into bytes
    const ubyte[] parseBytes(string contents)
    {
        ubyte[] contentBytes;
        auto cSplit = contents.split(",");
        
        foreach(c; cSplit)
        {
            if(canFind(c, "\t"))
            {
                auto tabSplit = c.split("\t");
                auto toInt = to!int(tabSplit[tabSplit.length-1]);
                contentBytes ~= cast(ubyte)toInt;
            }
            else if(c == "")
                break;
            else
            {
                auto toInt = to!int(c);
                contentBytes ~= cast(ubyte)toInt;
            }
        }

        return contentBytes;
    }

    // Strips the location from the filename if the location is empty -- ONLY IN SOME CASES
    string stripLocation(string fullName)
    {
        import std.system;

        version(Windows)
        {
            auto splitPath = fullName.split("\\");
            string path;
            for(int i = 0; i < splitPath.length; i++)
            {
                if(i == splitPath.length-1)
                    break;
                
                auto build = splitPath[i]~="\\";
                path~=build;
            }

            return path;
        }

        version(Posix)
        {
            auto splitPath = fullName.split("/");
            string path;
            for(int i = 0; i < splitPath.length; i++)
            {
                if(i == splitPath.length-1)
                    break;
                
                auto build = splitPath[i]~="/";
                path~=build;
            }

            return path;
        }
    }
}
