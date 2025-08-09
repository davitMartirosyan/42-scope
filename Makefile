# Compiler and flags
CC := clang
CXX := clang++
CFLAGS := -Ivendor/genGlad/include -Ivendor/glfw/include
CXXFLAGS := -Ivendor/genGlad/include -Ivendor/glfw/include
LDFLAGS := -Lvendor/glfw/build_shared/src -Wl,-rpath=vendor/glfw/build_shared/src
LDLIBS := -lglfw -lGL -lpthread -ldl

# Files
TARGET := scop
SRC_CXX := src/main.cpp
SRC_C := vendor/genGlad/src/gl.c
OBJ_CXX := $(SRC_CXX:.cpp=.o)
OBJ_C := $(SRC_C:.c=.o)

# Default target
all: $(TARGET)

# Build GLFW shared library
vendor/glfw/build_shared/src/libglfw.so:
	cd vendor/glfw && \
    cmake -S . -B build_shared \
        -DGLFW_BUILD_EXAMPLES=OFF \
        -DGLFW_BUILD_TESTS=OFF \
        -DGLFW_BUILD_DOCS=OFF \
        -DGLFW_LIBRARY_TYPE=SHARED && \
    cmake --build build_shared

# Generate GLAD loader
vendor/genGlad/src/gl.c:
	cd vendor/glad && \
    python3 -m glad --api gl:compatibility=4.6 --out-path=../genGlad --reproducible c

# Build object files
%.o: %.cpp
	$(CXX) -c $< -o $@ $(CXXFLAGS)

%.o: %.c
	$(CC) -c $< -o $@ $(CFLAGS)

# Build executable
$(TARGET): vendor/glfw/build_shared/src/libglfw.so vendor/genGlad/src/gl.c $(OBJ_CXX) $(OBJ_C)
	$(CXX) $(OBJ_CXX) $(OBJ_C) -o $@ $(LDFLAGS) $(LDLIBS)

# Clean
clean:
	rm -rf $(TARGET) $(OBJ_CXX) $(OBJ_C) vendor/genGlad vendor/glfw/build_shared

.PHONY: all clean
