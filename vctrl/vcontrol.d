module vctrl.vcontrol;

import vctrl.manager;
import std.stdio, std.string, std.file;

/*
 * Main class for dealing with args
 */
class VControl
{
public:
    this(string[] args)
    {
        this.args = args;
        this.mgr = new Manager();
        parseArgs();
    }

    ~this(){}

private:
    string[] args;
    Manager mgr;
    // const string[] kwargs = ["init","add", "commit", "revert", "diff"];
    // const string[] flags = [".", "-A", "-m", "-h"];

    // Parse the arguments and do the appropriate action
    // FIXED: Switch kind of better...
    void parseArgs()
    {
        try
        {
            switch(args[0])
            {
                case "init":
                    mgr.initVCtrl();
                    break;
                case "add":
                    parseAdd(args[1..$]);
                    break;
                case "commit":
                    try
                    {
                        parseCommitWithMessage(args[1..$]);
                    }
                    catch(Exception e)
                    {
                        parseCommit();
                    }
                    break;
                // case "revert":
                //     parseRevert(args[1..$]);
                //     break;
                // case "diff":
                //     parseDiff(args[1..$]);
                default:
                    writeln("That is not a valid command!\n");
                    break;
            }
        }
        catch(core.exception.RangeError e)
        {
            writeln("Please specify details!");
        }
    }

    // Parse Add function
    void parseAdd(string[] addArgs)
    {
        if(addArgs[0] == ".")
            mgr.addFromCWD();
        else if(addArgs[0] == "-A")
            mgr.addFromRoot();
        else
        {
            foreach(f; addArgs)
                mgr.addFile(f);
            mgr.saveStage();
        }
    }

    // Parse Commit args
    void parseCommitWithMessage(string[] commitArgs)
    {
        if(commandArgs[0] == "-m" || commitArgs[0] == "-M")
        {
            try
            {
                mgr.commitWithMessage(commandArgs[1]);
            }
            catch(Exception e)
            {
                writeln("You must pass a commit message!");
            }
        }
        else
            writeln("That is not a valid flag!");
    }

    // Commit passed without message - uses default.
    void parseCommit()
    {
        mgr.commitWithoutMessage();
    }
}