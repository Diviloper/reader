import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:reader/reader.dart';
import 'package:test/test.dart';

import 'stdin_mock.dart';

void main() {
  StdinMock mock;
  Reader reader;

  void simulateInput(String message) {
    final encoded = systemEncoding.encode(message);
    var i = 0;
    when(mock.readByteSync()).thenAnswer((_) => encoded[i++]);
  }

  setUp(() {
    mock = StdinMock();
    reader = Reader(mock);
  });

  group('nextString', () {
    test('returns string until whitespace', () {
      simulateInput('Hello there!\n');
      expect(reader.nextString(), 'Hello');
      expect(reader.nextString(), 'there!');
    });

    test('returns string until tab', () {
      simulateInput('Hello\tthere!\n');
      expect(reader.nextString(), 'Hello');
      expect(reader.nextString(), 'there!');
    });

    test('returns empty string if cannot read input', () {
      when(mock.readByteSync()).thenReturn(-1);
      expect(reader.nextString(), '');
    });

    test('ignores preceding whitespaces', () {
      simulateInput('   Hello   there!\n');
      expect(reader.nextString(), 'Hello');
      expect(reader.nextString(), 'there!');
    });

    test('ignores preceding tabs', () {
      simulateInput('\t\t\tHello\t\t\tthere!\n');
      expect(reader.nextString(), 'Hello');
      expect(reader.nextString(), 'there!');
    });
  });

  group('nextInt', () {
    test('returns parsed int', () {
      simulateInput('12 23\n');
      expect(reader.nextInt(), 12);
      expect(reader.nextInt(), 23);
    });

    test('returns parsed hexadecimal', () {
      simulateInput('0xA\n');
      expect(reader.nextInt(), 10);
    });

    test('returns parsed int with different bases', () {
      simulateInput('1001 a3j\n');
      expect(reader.nextInt(radix: 2), 9);
      expect(reader.nextInt(radix: 21), 10 * 21 * 21 + 3 * 21 + 19);
    });

    test('returns null with invalid input if raiseOnError is false', () {
      simulateInput('1.2a\n');
      expect(reader.nextInt(), null);
    });

    test('raises format exception with invalid input if raiseOnError is true',
        () {
      simulateInput('1.2a\n');
      expect(() => reader.nextInt(raiseOnError: true),
          throwsA(isA<FormatException>()));
    });
  });

  group('nextDouble', () {
    test('returns parsed double', () {
      simulateInput('12 23.23\n');
      expect(reader.nextDouble(), 12.0);
      expect(reader.nextDouble(), 23.23);
    });

    test('returns null with invalid input if raiseOnError is false', () {
      simulateInput('1.2a\n');
      expect(reader.nextDouble(), null);
    });

    test('raises format exception with invalid input if raiseOnError is true',
        () {
      simulateInput('1.2a\n');
      expect(() => reader.nextDouble(raiseOnError: true),
          throwsA(isA<FormatException>()));
    });
  });

  group('next', () {
    test('returns parsed object', () {
      List<int> convert(String raw) =>
          raw.substring(1, raw.length - 1).split(',').map(int.parse).toList();
      simulateInput('[1,2,3,4,5]\n');
      expect(reader.next(convert), [1, 2, 3, 4, 5]);
    });
  });
}
