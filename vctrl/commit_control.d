module vctrl.commit_control;

import std.stdio, std.file, std.conv, std.string, std.algorithm;

class CommitControl
{
public:
    this(){}
    ~this(){}

    // Writes the stage to a commit folder with a message
    void commit(string msg)
    {

        // Gets the stage and generates an ID
        const string stageContents = getStage();
        const string commitID = generateCommitID();

        if(stageContents == "")
        {
            writeln("Unable to find stage file.");
            return;
        }

        // Make the Commit folder and move to it
        mkdir(commitID);
        chdir(commitID);

        // Write the commit file
        auto commitFile = File(commitID~".vfile", "w");
        commitFile.write(stageContents);
        commitFile.close();

        writefln("Stage committed under Commit ID: %s", commitID);

        // Write the log
        writeLog(commitID, msg);
    }


private:
    const string opFolder = ".vctrl";
    const string stageFolder = "current_stage";
    const string stageFile = "stage.vfile";
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
            remove(stageFile);
            chdir("..");

            return stageContents;
        }
        catch(Exception e)
        {
            writefln("Unable to locate stage file in .vctrl/current_stage folder!\nHave you added any files?");
            return "";
        }
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
        auto fullTime = dt[1];
        auto stripTime = fullTime.split(".");
        auto actualTime = stripTime[0];

        string[] niceDateTime;
        niceDateTime~=date;
        niceDateTime~=actualTime;

        return niceDateTime;
    }
}