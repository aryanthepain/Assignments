# Compiler
CC = g++

# Compiler flags
CXXFLAGS = -Iinclude -Wall -Wextra -pedantic

# Source and object files
OBJDIR = obj
SOURCES = $(wildcard *.cpp)
OBJECTS = $(patsubst %.cpp, $(OBJDIR)/%.o, $(SOURCES))
OBJ_NAME = $(OBJDIR)/object_name

# Default rule
all: #$(OBJ_NAME)
#	@echo "Build complete. Executable: $(OBJ_NAME)"

run: all
	time ./$(OBJ_NAME)

# Link the executable
$(OBJ_NAME): $(OBJECTS)
	$(CC) $(OBJECTS) -o $@
	@echo "Linking complete. Created executable: $@"

# Compile source files to object files
$(OBJDIR)/%.o: %.cpp | $(OBJDIR)
	$(CC) $(CXXFLAGS) -c $< -o $@
	@echo "Compiled: $< -> $@"

# Create the object directory if it doesn't exist
$(OBJDIR):
	mkdir -p $(OBJDIR)
	@echo "Created directory: $(OBJDIR)"

# to add to github repo
# make git m="message" b="your-branch(main by defualt)"
b?=main
m?=$(shell date '+%d-%m-%Y %H:%M:%S')
git:
	git add .
	git commit -m "$(m)"
	git push origin $(b)

push:
	git push origin $(b)

# Clean up generated files
clean:
	rm -rf $(OBJDIR)
	@echo "Cleaned up generated files."

# Phony targets.
.PHONY: all git push clean