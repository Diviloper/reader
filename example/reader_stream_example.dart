import 'package:reader/reader.dart';

void main() {
  CaresAboutStdin();

  print('Type commands "forward 100" or "backward 50" to move the turtle.');
}

class CaresAboutStdin {
  CaresAboutStdin() {
    Reader.stream.addListener(turtleForward);
    Reader.stream.addListener(turtleBack);
  }

  void turtleForward(String raw, [List<dynamic> args = const []]) {
    if (args.length > 1 && args[0] == 'forward' && args[1] is int) {
      print('Turtle moving forward ${args[1]}');
    }
  }

  void turtleBack(String raw, [List<dynamic> args = const []]) {
    if (args.length > 1 && args[0] == 'backward' && args[1] is int) {
      print('Turtle moving backward ${args[1]}');
    }
  }
}
