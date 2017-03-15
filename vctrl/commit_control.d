module vctrl.commitcontrol;

import std.stdio, std.file, std.conv, std.string, std.algorithm;

class CommitControl
{
public:
    this(){}
    ~this(){}

    // Writes the stage to a commit folder with a message
    void commitWithMessage(string msg)
    {
        const string stageContents = getStage();
        const string commitID = generateCommitID();

        if(stageContents == "")
        {
            writeln("Unable to find stage file.");
            return;
        }

        mkdir(commitID);
        chdir(commitID);
        auto commitFile = File(commitID~".vfile", "w");
        commitFile.write(stageContents);
        commitFile.close();

        writeLog(commitID, msg);
    }

    // Writes the stage to a commit folder without a message - uses the current date of commit
    void commitWithoutMessage()
    {

    }


private:
    const string opFolder = ".vctrl";
    const string stageFolder = "current_stage";
    const string stageFile = "stage.vctrl";
    const int[] idDigits = [0,1,2,3,4,5,6,7,8,9];
    const string[] idLetters = ["a", "b", "c", "d", "e", "f"];

    // Generates a "unique" commit ID
    string generateCommitID()
    {
        import std.random : uniform;

        string id;
        const ushort length = 8;
        for(int i = 0; i < length; i++)
        {
            const auto choice = uniform(0,2);
            if(choice == 0)
            {
                auto pickLetter = uniform(0, idLetters.length);
                id~=idLetters[pickLetter];
            }
            else 
            {
                auto pickDigit = uniform(0, idDigits.length);
                id~=to!string(idDigits[pickDigit]);
            }
        }

        return id;
    }

    // Gets the stage file from the curent_stage folder
    string getStage()
    {
        try
        {
            moveDir(opFolder);
            moveDir(stageFolder);
            const string stageContents = to!string(read(stageFile));
            chdir("..");
            return stageContents;
        }
        catch(Exception e)
        {
            writefln("Unable to locate stage file in .vctrl/current stage folder!");
            return "";
        }

        return "";
    }

    // Writes the log file for the commit
    void writeLog(string cID, string msg)
    {
        auto datetime = formatDateTime();

        const auto logTitle = format("Log for commit %s\n\n", cID);
        const auto logDate = format("Date of commit: %s\n", datetime[0]);
        const auto logTime = format("Time of commit: %s\n", datetime[1]);
        const auto logMessage = format("Commit message: %s\n", msg);

        const auto fullLog = logTitle~logDate~logTime~logMessage;

        auto log = File(cID~".log", "w");
        log.write(fullLog);
        log.close();
    }

    // Scan for a directory
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

    // Formats the date and time nicely
    // UGLY IMPLEMENTATION BUT MEH
    string[] formatDateTime()
    {
        import std.datetime : Clock;

        auto datetime = Clock.currTime().toString();
        auto dt = datetime.split(" ");
        auto date = dt[0];
        auto fullTtime = dt[1];
        auto stripTime = time.split(".");
        auto actualTime = stripTime[0];

        string[] niceDateTime;
        niceDateTime~=date;
        niceDateTime~=actualTime;

        return niceDateTime;
    }
}