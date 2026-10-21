#include <string_view>

#include <react/renderer/core/RawProps.h>
#include <react/renderer/core/RawPropsParser.h>

using facebook::react::RawProps;
using facebook::react::RawPropsParser;

// RawPropsParser::prepare<PropsT>() parses an empty RawProps with the parser it
// prepares, then constructs PropsT, whose constructor looks up each prop. These
// are two such lookups through the prefixed overload, with names of one length.
int main(int argc, char **argv) {
  // "border" keeps the key in std::string's inline buffer; the long prefix puts
  // it on the heap.
  const bool heapKey = argc > 1 && std::string_view{argv[1]} == "heap";
  const char *prefix = heapKey ? "accessibilityBorderEnd" : "border";

  RawPropsParser parser;
  RawProps rawProps;
  rawProps.parse(parser);
  rawProps.at("Width", prefix, nullptr);
  rawProps.at("Color", prefix, nullptr);
  return 0;
}
