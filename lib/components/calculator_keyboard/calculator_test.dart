import 'package:test/test.dart';

import 'calculator.dart';

void main() {
  test('takeNumbers generate a double', () async {
    final numberStack = ['1', '3', '4'].reversed.toList();
    expect(takeNumbers(numberStack), 134.0);
  });

  test('takeNumbers takes only first numbers ', () async {
    final numberStack =
        ['1', '3', '4', 'x', 'y', '1', '2', '3'].reversed.toList();
    expect(takeNumbers(numberStack), 134.0);
  });

  test('takeNumbers handles empty number stack', () async {
    final numberStack = <String>[];
    expect(takeNumbers(numberStack).isNaN, true);
  });

  test('takeNumbers handles stack with no numbers', () async {
    final numberStack = <String>['x', '2'].reversed.toList();
    expect(takeNumbers(numberStack).isNaN, true);
  });

  test('computes multiplication', () async {
    final numberStack = <String>['2', '✖️', '7'];
    evaluateExpression(numberStack);
    expect(numberStack, ['1', '4']);
  });

  test('handles no leading zero on doubles', () async {
    final numberStack = <String>['.', '1'];
    evaluateExpression(numberStack);
    expect(numberStack, ['0']);
  });

  test('doesn not blow up on operation w/ no leading zero float', () async {
    final numberStack = <String>['1', '0', '0', '✖️', '.'];
    evaluateExpression(numberStack);
    expect(numberStack, ['1', '0', '0', '✖️', '.']);
  });

  test('computes sum', () async {
    final numberStack = <String>['2', '➕', '7'];
    evaluateExpression(numberStack);
    expect(numberStack, ['9']);
  });

  test('computes division', () async {
    final numberStack = <String>['8', '➗', '2'];
    evaluateExpression(numberStack);
    expect(numberStack, ['4']);
  });

  test('computes subtraction', () async {
    final numberStack = <String>['8', '-', '2'];
    evaluateExpression(numberStack);
    expect(numberStack, ['6']);
  });

  test('computes complex expression', () async {
    final numberStack = <String>['8', '-', '2', '➕', '3', '✖️', '4'];
    evaluateExpression(numberStack);
    expect(numberStack, ['3', '6']);
  });

  test('does not choke on invalid expression', () async {
    final numberStack = <String>['8', '-', '2', '➕', '3', '✖️', '4'];
    evaluateExpression(numberStack);
    expect(numberStack, ['3', '6']);
  });

  test('does not choke on mismatched operators', () async {
    final numberStack = <String>['8', '-', '2', '➕', '3', '✖️'];
    evaluateExpression(numberStack);
    expect(numberStack, ['9', '✖️']);
  });
}
