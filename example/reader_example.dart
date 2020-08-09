import 'package:reader/reader.dart';

// ignore_for_file: omit_local_variable_types
// ignore_for_file: unused_local_variable

void main() {
  final reader = Reader.stdin();

  // Input: Hello there
  final String firstS = reader.nextString(); // Hello
  final String secondS = reader.nextString(); // there

  // Input: 12 0x23 1010 1s2. 1as2
  final int firstI = reader.nextInt(); // 12
  final int secondI = reader.nextInt(); // 35
  final int thirdI = reader.nextInt(radix: 2); // 10
  final int fourthI = reader.nextInt(); // null
  final int fifthI = reader.nextInt(raiseOnError: true); // FormatException

  // Input: 12.2 1 1s2d 2df
  final double firstD = reader.nextDouble(); // 12.2
  final double secondD = reader.nextDouble(); // 1.0
  final double thirdD = reader.nextDouble(); // null
  final double fourthD =
      reader.nextDouble(raiseOnError: true); // FormatException

  // Input [1,2,3,4,5]
  final List<int> list = reader.next((raw) => raw
      .substring(1, raw.length - 1)
      .split(',')
      .map(int.parse)
      .toList()); // <int>[1, 2, 3, 4, 5]
}
