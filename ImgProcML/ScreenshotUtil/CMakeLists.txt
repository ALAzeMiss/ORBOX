cmake_minimum_required(VERSION 3.2)

project(ScreenshotUtil)

find_package(OpenCV REQUIRED)
find_package(Threads REQUIRED)

if(OpenCV_VERSION VERSION_LESS "4.0")
  message(FATAL_ERROR "OpenCV >= 4.0 required")
endif()

add_subdirectory(../Common shared_lib)
include_directories(${SHARED_LIB_INCLUDE_DIR})

# pigpio daemon interface
find_path(PIGPIODIF2_INCLUDE_DIR pigpiod_if2.h)
find_library(PIGPIODIF2_LIBRARY pigpiod_if2)
find_library(RT_LIBRARY rt)

if(NOT PIGPIODIF2_INCLUDE_DIR OR NOT PIGPIODIF2_LIBRARY)
  message(FATAL_ERROR "pigpiod_if2 introuvable. (sudo apt install pigpio)")
endif()

include_directories(${PIGPIODIF2_INCLUDE_DIR})

set(SOURCE_FILES main.cpp App.cpp App.h)
add_executable(screenshotUtil ${SOURCE_FILES})

target_link_libraries(screenshotUtil
  shared_lib
  ${OpenCV_LIBS}
  Threads::Threads
  ${PIGPIODIF2_LIBRARY}
  ${RT_LIBRARY}
)
