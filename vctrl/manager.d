module vctrl.manager;

import std.stdio, std.file;
import vctrl.vfile;
import vctrl.addcontrol; //, vctrl.commitcontrol, vctrl.revertcontrol, vctrl.diffcontrol;

class Manager
{
public:
    this()
    {
        loadStageFile();
        ac = new AddControl(stage);
    }
    ~this(){}

    /*****************************************************************
    ***************************MANAGER CONTROLS***********************
    *****************************************************************/

    // Init a VCtrl project
    void initVCtrl()
    {
        const auto cwd = getcwd();
        const auto vctrlFolderLoc = cwd~vctrlFolder;

        if(!(vctrlFolderLoc.isDir))
        {
            mkdir(vctrlFolderLoc);
            chdir(vctrlFolderLoc);
            auto log = File(".vctrl", "w");
            log.write("// LogFile for VCtrl Projects");
            log.close(); 
            mkdir("current_stage");
            // TODO: More folders?
        }
        else
            writeln("VCtrl Project already exists!");
    }

    /*****************************************************************
    ****************************ADD SECTION***************************
    *****************************************************************/
    
    // Adds all files in the CWD and all subfolders to the stage
    void addFromCWD()
    {
        ac.addFromCWD();
    }

    // Adds all files from the project root src to the stage
    void addFromRoot()
    {
        ac.addFromRoot();
    }

    // Add a file to the stage
    void addFile(string filename)
    {
        ac.addFile(filename);
    }


private:
    VFile[] stage;

    AddControl ac;
    // CommitControl cc;
    // RevertControl rc;
    // DiffControl dc;

    const string vctrlFolder = ".vctrl";

    /*****************************************************************
    ************************** MANAGER CONTROLS **********************
    *****************************************************************/

    // Loads the stage from the stage file, if it exists
    void loadStageFile()
    {
        // TODO: Implement
        this.stage = null;
    }

    // Removes the saved stage file -- AFTER COMMITS --
    void removeStageFile()
    {
        // TODO: Implement
    }
}