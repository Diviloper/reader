# Reader
A library that allows reading single strings, ints and doubles from stdin in a simple and straightforward way.

## Usage

```dart
import 'package:reader/reader.dart';

main() {
  final Reader reader = Reader.stdin();
  // Input: Hey 1 2.3
  final String s = reader.nextString(); // Hey 
  final int i = reader.nextInt(); // 1
  final double d = reader.nextDouble(); // 2.3 
}
```

Complete example at [example](example/reader_example.dart).

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/Diviloper/reader/issues