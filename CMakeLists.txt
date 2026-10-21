# RawProps, RawPropsParser and RawPropsKeyMap from React Native's ReactCommon,
# built for the host under AddressSanitizer against the third-party sources
# ReactAndroid's prepare tasks unpack, with folly built the way Fantom's tester
# builds it.
cmake_minimum_required(VERSION 3.13)
project(rawprops_freed_key C CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

set(REACT_NATIVE_DIR ${REACT_NATIVE_REPOSITORY}/packages/react-native)
set(REACT_COMMON_DIR ${REACT_NATIVE_DIR}/ReactCommon)
set(REACT_THIRD_PARTY_NDK_DIR ${REACT_NATIVE_DIR}/ReactAndroid/build/third-party-ndk)
set(FANTOM_THIRD_PARTY_DIR ${REACT_NATIVE_REPOSITORY}/private/react-native-fantom/tester/third-party)

add_compile_options(-stdlib=libc++ -fsanitize=address -fno-omit-frame-pointer -g -O1)
add_link_options(-stdlib=libc++ -fsanitize=address)

include(${REACT_COMMON_DIR}/cmake-utils/react-native-flags.cmake)

add_subdirectory(${FANTOM_THIRD_PARTY_DIR}/boost boost)
add_subdirectory(${REACT_THIRD_PARTY_NDK_DIR}/glog glog)
add_subdirectory(${REACT_THIRD_PARTY_NDK_DIR}/double-conversion double-conversion)
add_subdirectory(${REACT_THIRD_PARTY_NDK_DIR}/fast_float fast_float)
add_subdirectory(${REACT_THIRD_PARTY_NDK_DIR}/fmt fmt)

# Fantom's prepareFolly task puts its folly CMakeLists.txt beside the folly sources.
set(FOLLY_SOURCE_DIR ${CMAKE_BINARY_DIR}/folly-source)
file(COPY ${FANTOM_THIRD_PARTY_DIR}/folly/CMakeLists.txt DESTINATION ${FOLLY_SOURCE_DIR})
file(CREATE_LINK ${REACT_THIRD_PARTY_NDK_DIR}/folly/folly ${FOLLY_SOURCE_DIR}/folly SYMBOLIC)
add_subdirectory(${FOLLY_SOURCE_DIR} folly)

add_executable(rawprops_freed_key
  main.cpp
  ${REACT_COMMON_DIR}/jsi/jsi/JSIDynamic.cpp
  ${REACT_COMMON_DIR}/jsi/jsi/jsi.cpp
  ${REACT_COMMON_DIR}/react/renderer/core/RawProps.cpp
  ${REACT_COMMON_DIR}/react/renderer/core/RawPropsKeyMap.cpp
  ${REACT_COMMON_DIR}/react/renderer/core/RawPropsParser.cpp)
target_compile_definitions(rawprops_freed_key PRIVATE RN_BUILDING)
target_include_directories(rawprops_freed_key PRIVATE
  ${REACT_COMMON_DIR}
  ${REACT_COMMON_DIR}/callinvoker
  ${REACT_COMMON_DIR}/cxxreact
  ${REACT_COMMON_DIR}/jsi
  ${REACT_COMMON_DIR}/react/debug
  ${REACT_COMMON_DIR}/react/renderer/core
  ${REACT_COMMON_DIR}/react/renderer/debug
  ${REACT_COMMON_DIR}/react/renderer/graphics
  ${REACT_COMMON_DIR}/react/renderer/graphics/platform/cxx
  ${REACT_COMMON_DIR}/react/renderer/mapbuffer
  ${REACT_COMMON_DIR}/react/utils
  ${REACT_COMMON_DIR}/runtimeexecutor)
target_link_libraries(rawprops_freed_key folly_runtime glog)
