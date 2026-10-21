# RawProps::at(name, prefix, suffix) reads a destroyed key

A host build of React Native's `RawProps`, `RawPropsParser` and `RawPropsKeyMap` under AddressSanitizer, for [react/react-native#59327](https://github.com/react/react-native/issues/59327).

1. In a react-native checkout, unpack the third-party sources ReactAndroid builds against into `packages/react-native/ReactAndroid/build/third-party-ndk`: its `prepareBoost`, `prepareDoubleConversion`, `prepareFastFloat`, `prepareFmt`, `prepareFolly` and `prepareGlog` tasks do, as any ReactAndroid build does.
2. Run `CC=clang CXX=clang++ ./run.sh <checkout>` with a clang that has libc++.

`main.cpp` makes the two lookups a props constructor makes while its parser is prepared. AddressSanitizer reports a heap-use-after-free in `RawPropsParser::at` for a key on the heap, and a stack-use-after-return for one in `std::string`'s inline buffer.
