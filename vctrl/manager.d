module vctrl.manager;

import std.stdio, std.file;
import vctrl.vfile;
import vctrl.add_control, vctrl.commit_control, vctrl.revert_control;

class Manager
{
public:
    this()
    {
        loadStageFile();
        ac = new AddControl(stage);
        cc = new CommitControl();
        rc = new RevertControl();
    }

    ~this(){}

    /*****************************************************************
    ***************************MANAGER CONTROLS***********************
    *****************************************************************/

    // Init a VCtrl project
    void initVCtrl()
    {
        const auto cwd = getcwd();
        const auto vctrlFolderLoc = cwd~"/"~vctrlFolder;

        try
        {
            assert(vctrlFolderLoc.isDir);
            writeln("VCtrl Folder already exists!");

        }
        catch(Exception e)
        {
            mkdir(vctrlFolderLoc);
            chdir(vctrlFolderLoc);
            auto log = File("log.vctrl", "w");
            log.write("// LogFile for VCtrl Projects");
            log.close(); 
            mkdir("current_stage");
        }
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

    // Saves the stage to a file
    void saveStage()
    {
        ac.saveStage();
    }

    /*****************************************************************
    ****************************COMMIT SECTION************************
    *****************************************************************/    

    // Commits the saved stage file with the passed message
    void commit(string msg)
    {
        cc.commit(msg);
    }

    /*****************************************************************
    ****************************REVERT SECTION************************
    *****************************************************************/  

    // Reverts the commit mathcing the ID, getting the files back
    void revert(string id)
    {
        rc.revert(id);
    }

private:
    VFile[] stage;

    AddControl ac;
    CommitControl cc;
    RevertControl rc;

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