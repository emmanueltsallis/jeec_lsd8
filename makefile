# Model compilation options
TARGET=lsd
FUN=fun_model_jeec
FUN_EXTRA=jeec_initialisation.h jeec_aggregate.h jeec_banks.h jeec_firms_capital.h jeec_firms_financial.h jeec_firms_rd.h jeec_government.h jeec_households.h jeec_firms_production.h jeec_demand_distribution.h jeec_labour_market.h jeec_entry_exit.h jeec_checks.h jeec_save.h
SWITCH_CC=-O3 -ggdb3
SWITCH_CC_LNK=

# System compilation options
# LSD options
LSDROOT=/Users/italopedrosa/LSD
SRC=src

# Libraries options
PATH_TCL_HEADER=Tcl.framework/Headers
PATH_TK_HEADER=Tk.framework/Headers
PATH_TCLTK_LIB=./$(TARGET).app/Contents/Frameworks
TCLTK_LIB=-framework Tcl -framework Tk
PATH_HEADER=.
PATH_LIB=.
LIB=-lz -lpthread

# Compiler options
CC=g++
GLOBAL_CC=-march=native -std=c++14 -w
SSWITCH_CC=-fnon-call-exceptions -O3

# Body of makefile (from makefile_mac.txt)
# specify where are the sources of LSD
SRC_DIR=$(LSDROOT)/$(SRC)/

# location of tcl/tk and other headers
INCLUDE=-I$(LSDROOT)/$(SRC) -I$(PATH_TCLTK_LIB)/$(PATH_TCL_HEADER) \
-I$(PATH_TCLTK_LIB)/$(PATH_TK_HEADER) -I$(PATH_HEADER)

# macOS package internal location of executable
TARGET_PKG=$(TARGET).app/Contents/MacOS/$(TARGET)

# common dependencies (all source files)
COM_DEP=$(SRC_DIR)decl.h $(SRC_DIR)common.h 
COM_DEP_SYS=$(COM_DEP) $(SRC_DIR)system_options.txt

# OS command to delete files
RM=rm -f -R

# link executable
$(TARGET_PKG): $(FUN).o $(SRC_DIR)common.o $(SRC_DIR)lsdmain.o \
$(SRC_DIR)analysis.o $(SRC_DIR)debug.o $(SRC_DIR)draw.o $(SRC_DIR)edit.o \
$(SRC_DIR)edit_dat.o $(SRC_DIR)file.o $(SRC_DIR)interf.o $(SRC_DIR)nets.o \
$(SRC_DIR)object.o $(SRC_DIR)report.o $(SRC_DIR)runtime.o $(SRC_DIR)set_all.o \
$(SRC_DIR)show_eq.o $(SRC_DIR)util.o $(SRC_DIR)variab.o \
$(TARGET).app/Contents/Info.plist
	$(CC) $(GLOBAL_CC) $(SWITCH_CC) $(FUN).o $(SRC_DIR)common.o \
	$(SRC_DIR)lsdmain.o $(SRC_DIR)analysis.o $(SRC_DIR)debug.o $(SRC_DIR)draw.o \
	$(SRC_DIR)edit.o $(SRC_DIR)edit_dat.o $(SRC_DIR)file.o $(SRC_DIR)interf.o \
	$(SRC_DIR)nets.o $(SRC_DIR)object.o $(SRC_DIR)report.o $(SRC_DIR)runtime.o \
	$(SRC_DIR)set_all.o $(SRC_DIR)show_eq.o $(SRC_DIR)util.o $(SRC_DIR)variab.o \
	$(SWITCH_CC_LNK) -F$(PATH_TCLTK_LIB) $(TCLTK_LIB) -L$(PATH_LIB) $(LIB) \
	-o $(TARGET_PKG)
	touch -c -f $(TARGET).app

# create macOS package
$(TARGET).app/Contents/Info.plist: $(SRC_DIR)LSD.app/Contents/Info.plist \
$(SRC_DIR)LSD.app/Contents/Frameworks/Tcl.framework/libtclstub8.6.a \
$(SRC_DIR)LSD.app/Contents/Frameworks/Tk.framework/libtkstub8.6.a
	$(RM) LSD-APP-DUMMY $(TARGET).app
	cp -R $(SRC_DIR)LSD.app LSD-APP-DUMMY
	mv LSD-APP-DUMMY $(TARGET).app
	rm -f $(TARGET).app/Contents/MacOS/LSD
	sed -e 's/LSD/$(TARGET)/g' -i '' $(TARGET).app/Contents/Info.plist

# compile modules
$(FUN).o: $(FUN).cpp $(FUN_EXTRA) model_options.txt $(SRC_DIR)check.h \
$(SRC_DIR)fun_head.h $(SRC_DIR)fun_head_fast.h $(COM_DEP) $(TARGET).app/Contents/Info.plist
	$(CC) $(GLOBAL_CC) $(SWITCH_CC) $(INCLUDE) -c $(FUN).cpp
	
$(SRC_DIR)common.o: $(SRC_DIR)common.cpp $(SRC_DIR)common.h  $(SRC_DIR)system_options.txt \
$(TARGET).app/Contents/Info.plist
	$(CC) $(GLOBAL_CC) $(SSWITCH_CC) $(INCLUDE) -c $(SRC_DIR)common.cpp -o $(SRC_DIR)common.o

$(SRC_DIR)lsdmain.o: $(SRC_DIR)lsdmain.cpp $(COM_DEP_SYS) $(TARGET).app/Contents/Info.plist
	$(CC) $(GLOBAL_CC) $(SSWITCH_CC) $(INCLUDE) -c $(SRC_DIR)lsdmain.cpp -o $(SRC_DIR)lsdmain.o

$(SRC_DIR)analysis.o: $(SRC_DIR)analysis.cpp $(SRC_DIR)tables.h $(COM_DEP_SYS) $(TARGET).app/Contents/Info.plist
	$(CC) $(GLOBAL_CC) $(SSWITCH_CC) $(INCLUDE) -c $(SRC_DIR)analysis.cpp -o $(SRC_DIR)analysis.o

$(SRC_DIR)debug.o: $(SRC_DIR)debug.cpp $(COM_DEP_SYS) $(TARGET).app/Contents/Info.plist
	$(CC) $(GLOBAL_CC) $(SSWITCH_CC) $(INCLUDE) -c $(SRC_DIR)debug.cpp -o $(SRC_DIR)debug.o

$(SRC_DIR)draw.o: $(SRC_DIR)draw.cpp $(COM_DEP_SYS) $(TARGET).app/Contents/Info.plist
	$(CC) $(GLOBAL_CC) $(SSWITCH_CC) $(INCLUDE) -c $(SRC_DIR)draw.cpp -o $(SRC_DIR)draw.o

$(SRC_DIR)edit.o: $(SRC_DIR)edit.cpp $(COM_DEP_SYS) $(TARGET).app/Contents/Info.plist
	$(CC) $(GLOBAL_CC) $(SSWITCH_CC) $(INCLUDE) -c $(SRC_DIR)edit.cpp -o $(SRC_DIR)edit.o

$(SRC_DIR)edit_dat.o: $(SRC_DIR)edit_dat.cpp $(COM_DEP_SYS) $(TARGET).app/Contents/Info.plist
	$(CC) $(GLOBAL_CC) $(SSWITCH_CC) $(INCLUDE) -c $(SRC_DIR)edit_dat.cpp -o $(SRC_DIR)edit_dat.o

$(SRC_DIR)file.o: $(SRC_DIR)file.cpp $(COM_DEP_SYS) $(TARGET).app/Contents/Info.plist
	$(CC) $(GLOBAL_CC) $(SSWITCH_CC) $(INCLUDE) -c $(SRC_DIR)file.cpp -o $(SRC_DIR)file.o

$(SRC_DIR)interf.o: $(SRC_DIR)interf.cpp $(COM_DEP_SYS) $(TARGET).app/Contents/Info.plist
	$(CC) $(GLOBAL_CC) $(SSWITCH_CC) $(INCLUDE) -c $(SRC_DIR)interf.cpp -o $(SRC_DIR)interf.o

$(SRC_DIR)nets.o: $(SRC_DIR)nets.cpp $(COM_DEP_SYS) $(TARGET).app/Contents/Info.plist
	$(CC) $(GLOBAL_CC) $(SSWITCH_CC) $(INCLUDE) -c $(SRC_DIR)nets.cpp -o $(SRC_DIR)nets.o

$(SRC_DIR)object.o: $(SRC_DIR)object.cpp $(COM_DEP_SYS) $(TARGET).app/Contents/Info.plist
	$(CC) $(GLOBAL_CC) $(SSWITCH_CC) $(INCLUDE) -c $(SRC_DIR)object.cpp -o $(SRC_DIR)object.o

$(SRC_DIR)report.o: $(SRC_DIR)report.cpp $(COM_DEP_SYS) $(TARGET).app/Contents/Info.plist
	$(CC) $(GLOBAL_CC) $(SSWITCH_CC) $(INCLUDE) -c $(SRC_DIR)report.cpp -o $(SRC_DIR)report.o

$(SRC_DIR)runtime.o: $(SRC_DIR)runtime.cpp $(COM_DEP_SYS) $(TARGET).app/Contents/Info.plist
	$(CC) $(GLOBAL_CC) $(SSWITCH_CC) $(INCLUDE) -c $(SRC_DIR)runtime.cpp -o $(SRC_DIR)runtime.o

$(SRC_DIR)set_all.o: $(SRC_DIR)set_all.cpp $(SRC_DIR)tables.h $(COM_DEP_SYS) $(TARGET).app/Contents/Info.plist
	$(CC) $(GLOBAL_CC) $(SSWITCH_CC) $(INCLUDE) -c $(SRC_DIR)set_all.cpp -o $(SRC_DIR)set_all.o

$(SRC_DIR)show_eq.o: $(SRC_DIR)show_eq.cpp $(COM_DEP_SYS) $(TARGET).app/Contents/Info.plist
	$(CC) $(GLOBAL_CC) $(SSWITCH_CC) $(INCLUDE) -c $(SRC_DIR)show_eq.cpp -o $(SRC_DIR)show_eq.o

$(SRC_DIR)util.o: $(SRC_DIR)util.cpp $(COM_DEP_SYS) $(TARGET).app/Contents/Info.plist
	$(CC) $(GLOBAL_CC) $(SSWITCH_CC) $(INCLUDE) -c $(SRC_DIR)util.cpp -o $(SRC_DIR)util.o

$(SRC_DIR)variab.o: $(SRC_DIR)variab.cpp $(COM_DEP_SYS) $(TARGET).app/Contents/Info.plist
	$(CC) $(GLOBAL_CC) $(SSWITCH_CC) $(INCLUDE) -c $(SRC_DIR)variab.cpp -o $(SRC_DIR)variab.o

# remove compiled files
clean:
	$(RM) -f -R $(SRC_DIR)*.o $(FUN).o $(TARGET).app
