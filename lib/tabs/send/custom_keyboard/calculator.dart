const operators = [
  '✖️',
  '*',
  '-',
  '➕',
  '+',
  '➗',
  '/',
];

const numbers = [
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '.',
];

double takeNumbers(List<String> stack) {
  final number = StringBuffer(); // Always add a leasing zero. Prevents
  // invalid doubles when only a period is entered.
  while (stack.isNotEmpty) {
    final maybeNumber = stack.removeLast();
    final isNumber = numbers.indexOf(maybeNumber);
    if (isNumber == -1) {
      stack.add(maybeNumber);
      break;
    }
    number.write(maybeNumber);
  }
  if (number.length == 0) {
    return double.nan;
  }
  return double.parse(number.toString(), (value) {
    stack.addAll(value.split(''));
    return double.nan;
  });
}

typedef BinaryDoubleFunction = double Function(double left, double right);

void evaluateExpression(List<String> stack) {
  final reversedStack = stack.reversed.toList();
  final validSymbols =
      [numbers, operators].expand((element) => element).toList();
  final output = <double>[];

  final operate = (BinaryDoubleFunction operator) => (String peek) {
        reversedStack.removeLast();
        final right = takeNumbers(reversedStack);
        if (right.isNaN) {
          reversedStack.add(peek);
          throw Exception('Failed parsing');
        }
        final left = output.removeLast();
        output.add(operator(left, right));
      };

  try {
    OUTER:
    while (reversedStack.isNotEmpty) {
      final peek = reversedStack[reversedStack.length - 1];
      if (!validSymbols.contains(peek)) {
        throw Exception('Invalid math symbol `${peek}`');
      }

      switch (peek) {
        case '✖️':
          operate((l, r) => l * r)(peek);
          break;
        case '*':
          operate((l, r) => l * r)(peek);
          break;
        case '-':
          operate((l, r) => l - r)(peek);
          break;
        case '➕':
          operate((l, r) => l + r)(peek);
          break;
        case '+':
          operate((l, r) => l + r)(peek);
          break;
        case '➗':
          operate((l, r) => l / r)(peek);
          break;
        case '/':
          operate((l, r) => l / r)(peek);
          break;
        default:
          final number = takeNumbers(reversedStack);
          if (number.isNaN) {
            break OUTER;
          }
          output.add(number);
      }
    }
  } catch (err) {
    // Something happened, we are able to just continue though
    // due to the way the list collapsing happens below.
  }
  stack.clear();
  assert(output.length < 2, 'Invalid output length');
  if (output.length == 1) {
    stack.addAll(output.removeLast().truncate().toString().split(''));
  }
  stack.addAll(reversedStack.reversed);
  if (stack.isEmpty) {
    stack.add('0');
  }
}
