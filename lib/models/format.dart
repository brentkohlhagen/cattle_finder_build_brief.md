/// Formats a number with thousands separators, en-AU style (e.g. 1490 ->
/// "1,490"), matching the prototype's `toLocaleString("en-AU", ...)`.
String fmtMoney(num n) {
  final rounded = n.round();
  final negative = rounded < 0;
  final digits = rounded.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final fromEnd = digits.length - i;
    buffer.write(digits[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return negative ? '-$buffer' : buffer.toString();
}
