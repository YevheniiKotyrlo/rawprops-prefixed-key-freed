#!/usr/bin/env bash
# Usage: run.sh <react-native checkout>
# Needs clang with libc++, CMake and Ninja, and the checkout's third-party sources:
#   ./gradlew :packages:react-native:ReactAndroid:prepareBoost :packages:react-native:ReactAndroid:prepareDoubleConversion \
#     :packages:react-native:ReactAndroid:prepareFastFloat :packages:react-native:ReactAndroid:prepareFmt \
#     :packages:react-native:ReactAndroid:prepareFolly :packages:react-native:ReactAndroid:prepareGlog
set -euo pipefail

REACT_NATIVE_REPOSITORY=$(cd "${1:?a react-native checkout}" && pwd)
HERE=$(cd "$(dirname "$0")" && pwd)
BUILD="$HERE/build"

cmake -S "$HERE" -B "$BUILD" -G Ninja \
  -DCMAKE_C_COMPILER="${CC:-clang}" -DCMAKE_CXX_COMPILER="${CXX:-clang++}" \
  -DREACT_NATIVE_REPOSITORY="$REACT_NATIVE_REPOSITORY"
cmake --build "$BUILD" --target rawprops_freed_key

echo "== key on the heap"
"$BUILD/rawprops_freed_key" heap || true
echo "== key in std::string's inline buffer"
ASAN_OPTIONS=detect_stack_use_after_return=1 "$BUILD/rawprops_freed_key" || true
