import std.stdio, std.file;
import vctrl.vcontrol;

void main(string[] args)
{
    if(args.length == 1)
    {
        writeln("Please enter a valid command!");
        return;
    }
    
    auto vctrl = new VControl(args[1..$]);
}