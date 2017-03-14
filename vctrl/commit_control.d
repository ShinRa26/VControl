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
        // TODO: Implement
    }

    // Writes the stage to a commit folder without a message - uses the current date of commit
    void commitWithoutMessage()
    {
        // TODO: Implement
    }


private:
    const string stageFile = "stage.vctrl";

    // Generates a "unique" commit ID
    string generateCommitID()
    {
        // TODO: Implement
    }
}