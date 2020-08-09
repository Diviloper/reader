import 'dart:io';

import 'package:mockito/mockito.dart';

class StdinMock extends Mock implements Stdin {
  @override
  bool get hasTerminal => true;
}
