all:
	@cd vendor/glfw ;\
	cmake -S . -B build_shared -DGLFW_BUILD_EXAMPLES=OFF -DGLFW_BUILD_TESTS=OFF -DGLFW_BUILD_DOCS=OFF -DGLFW_LIBRARY_TYPE=SHARED ;\
	cmake --build build_shared ; \
	@cd vendor/glad ;\
	glad --profile="compatibility" --generator="c" --out-path="../genGlad" --api gl="4.6"
	c++ src/main.cpp vendor/genGlad/src/glad.c -o scop -Ivendor/genGlad/include -Ivendor/glfw/include -Lvendor/glfw/build_shared/src -Wl,-rpath=vendor/glfw/build_shared/src -lglfw -lGL -lpthread -ldl