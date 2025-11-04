CPP_FILES := $(wildcard src/*.cpp)
OBJ_FILES := $(addprefix obj/,$(notdir $(CPP_FILES:.cpp=.o)))
LD_FLAGS := `root-config --cflags --glibs` -lMinuit  -lMinuit2 
CC_FLAGS := -fPIC -Wall `root-config --cflags`
CC_FLAGS += -I./include -O2  -g

# add a flag if we are on a mac and add -arch x86_64
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
	CC_FLAGS += -arch x86_64
	LD_FLAGS += -arch x86_64
endif

ifeq ($(USE_MP),true)
	CC_FLAGS +=-fopenmp -DUSE_MP
else
	
endif

all: $(patsubst bin/%.cpp, %, $(wildcard bin/*.cpp)) libconvino.so




%: bin/%.cpp Makefile $(OBJ_FILES)
	g++ $(CC_FLAGS) $(LD_FLAGS) $(OBJ_FILES) $< -o $@ 

libconvino.so: $(OBJ_FILES)
	g++ -shared $(LD_FLAGS) -o $@ $^

obj/%.o: src/%.cpp
	g++ $(CC_FLAGS) -c -o $@ $<


clean: 
	rm -f obj/*.o obj/*.d
	touch bin/*


.PHONY: test
test_simple:
	@bash test/run_tests.sh simple

.PHONY: test
test_advanced:
	@bash test/run_tests.sh advanced