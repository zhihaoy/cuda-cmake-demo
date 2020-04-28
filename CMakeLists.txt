cmake_minimum_required(VERSION 3.17)

project(cuda-cmake-demo LANGUAGES CXX CUDA)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

include(CudaArchitectureSelector)

if(BUILD_SHARED_LIBS)
	set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL")
else()
	set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
endif()
set(CMAKE_VS_JUST_MY_CODE_DEBUGGING ON)
if(MSVC)
	foreach(flagvar
	    CMAKE_CXX_FLAGS_RELWITHDEBINFO CMAKE_C_FLAGS_RELWITHDEBINFO)
		string(REGEX REPLACE "/Ob1" "/Ob2" ${flagvar} "${${flagvar}}")
	endforeach()
	foreach(flagvar
	    CMAKE_CUDA_FLAGS_RELWITHDEBINFO)
		string(REGEX REPLACE "-Ob1" "-Ob2" ${flagvar} "${${flagvar}}")
	endforeach()
endif()

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_CUDA_STANDARD 14)
set(CMAKE_CUDA_STANDARD_REQUIRED ON)
set(CMAKE_CUDA_EXTENSIONS OFF)

if(MSVC)
	add_compile_options($<$<COMPILE_LANGUAGE:CXX>:/W3>)
	add_compile_options($<$<COMPILE_LANGUAGE:CUDA>:-Xcudafe>)
	add_compile_options($<$<COMPILE_LANGUAGE:CUDA>:--diag_suppress=decl_modifiers_ignored>)
else()
	add_compile_options($<$<COMPILE_LANGUAGE:CXX>:-Wall>)
	add_compile_options($<$<COMPILE_LANGUAGE:CXX>:-Wconversion>)
	add_compile_options($<$<COMPILE_LANGUAGE:CXX>:-Wsign-conversion>)
	add_compile_options($<$<COMPILE_LANGUAGE:CXX>:-Wsign-compare>)
	add_compile_options($<$<COMPILE_LANGUAGE:CXX>:-fdiagnostics-color>)
endif()

add_compile_options("$<$<COMPILE_LANGUAGE:CUDA>:--expt-extended-lambda>")
add_compile_options("$<$<COMPILE_LANGUAGE:CUDA>:--expt-relaxed-constexpr>")

set(cuda-cmake-demo_srcs
	include/cuda-cmake-demo/daxpy.h
	src/daxpy.cu)

add_library(cuda-cmake-demo)

target_sources(cuda-cmake-demo PRIVATE ${cuda-cmake-demo_srcs})
target_include_directories(cuda-cmake-demo PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>
    $<INSTALL_INTERFACE:include>)

add_executable(demo)
target_sources(demo PRIVATE src/main.cc)
target_link_libraries(demo PRIVATE cuda-cmake-demo)
