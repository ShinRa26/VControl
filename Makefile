.DEFAULT_GOAL := all

DCC = dmd
DFLAGS = -w
CFLAG = -c
OUT = -oftest
SRC = *.d

INCLUDES = -I/home/group/Dropbox/DProj/versionctrl/vctrl/ -I/home/group/Dropbox/DProj/versionctrl/serialize/

SERIALIZE = /home/group/Dropbox/DProj/versionctrl/serialize/
VCTRL = /home/group/Dropbox/DProj/versionctrl/vctrl/

all:
	clear
	$(DCC) $(DFLAGS) $(INCLUDE) $(SRC) $(SERIALIZE)$(SRC) $(VCTRL)$(SRC) $(OUT)
	rm *.o
	
