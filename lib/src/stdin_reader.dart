import 'dart:convert';
import 'dart:io';

/// Class that allows the easy read of single strings, ints and doubles
/// from stdin
class Reader {
  final Stdin _source;

  /// Creates a new Reader of the given stdin. Usually, [Reader.stdin] is the
  /// constructor to use
  Reader(this._source);

  /// Creates a new Reader that wraps the system [stdin]
  Reader.stdin() : this(stdin);

  /// Reads the next [String] in the source until the next whitespace, tab
  /// or end of line. Preceding whitespaces and tabs are ignored
  String nextString({Encoding encoding = systemEncoding}) {
    // Separators are tab and whitespace
    final separators = [9, 32];
    const CR = 13;
    const LF = 10;
    final chars = <int>[];
    // On Windows, if lineMode is disabled, only CR is received.
    final crIsNewline = Platform.isWindows &&
        (stdioType(_source) == StdioType.terminal) &&
        !_source.lineMode;
    if (crIsNewline) {
      // CR and LF are both chars terminators, neither is retained.
      while (true) {
        var byte = _source.readByteSync();
        if (byte < 0 && chars.isEmpty) return '';
        if (byte == LF || byte == CR) break;
        if (separators.contains(byte)) {
          if (chars.isNotEmpty) break;
        } else {
          chars.add(byte);
        }
      }
    } else {
      // Case having to handle CR LF as a single unretained chars terminator.
      outer:
      while (true) {
        var byte = _source.readByteSync();
        if (separators.contains(byte)) {
          if (chars.isEmpty) continue;
          break;
        }
        if (byte == LF) break;
        if (byte == CR) {
          do {
            byte = _source.readByteSync();
            if (byte == LF) break outer;
            chars.add(CR);
          } while (byte == CR);
        }
        if (byte < 0) {
          if (chars.isEmpty) return '';
          break;
        }
        chars.add(byte);
      }
    }
    return encoding.decode(chars);
  }

  /// Reads the next [int] in the source, ignoring preceding whitespaces and
  /// tabs.
  ///
  /// The [radix] must be in the range 2..36. The digits used are
  /// first the decimal digits 0..9, and then the letters 'a'..'z' with
  /// values 10 through 35. Also accepts upper-case letters with the same
  /// values as the lower-case ones.
  ///
  /// If no [radix] is given then it defaults to 10. In this case, the read
  /// digits may also start with `0x`, in which case the number is interpreted
  /// as a hexadecimal integer literal.
  ///
  /// If [raiseOnError] is true and the read value is not valid, this throws a
  /// [FormatException]. If is false and the read value is not valid, it
  /// returns `null`.
  int nextInt({
    bool raiseOnError = false,
    Encoding encoding = systemEncoding,
    int radix,
  }) =>
      raiseOnError
          ? int.parse(nextString(encoding: encoding), radix: radix)
          : int.tryParse(nextString(encoding: encoding), radix: radix);

  /// Reads the next [double] in the source, ignoring preceding whitespaces and
  /// tabs.
  ///
  /// If [raiseOnError] is true and the read value is not valid, this throws a
  /// [FormatException]. If is false and the read value is not valid, it
  /// returns `null`.
  double nextDouble({
    bool raiseOnError = false,
    Encoding encoding = systemEncoding,
  }) =>
      raiseOnError
          ? double.parse(nextString(encoding: encoding))
          : double.tryParse(nextString(encoding: encoding));

  /// Reads the input until next whitespace, tab or end of line and applies
  /// [convert]
  T next<T>(
    T Function(String raw) convert, {
    Encoding encoding = systemEncoding,
  }) =>
      convert(nextString(encoding: encoding));
}
