import 'number_formatter.dart';

class Calculations {
  static const PERIOD = '.';
  static const MULTIPLY = '×';
  static const SUBTRACT = '−';
  static const ADD = '+';
  static const DIVIDE = '÷';
  // TODO: use Icons.backspace
  static const BACKSPACE = 'BACK';
  static const EQUAL = '=';
  static const OPERATIONS = [
    Calculations.ADD,
    Calculations.MULTIPLY,
    Calculations.SUBTRACT,
    Calculations.DIVIDE,
  ];

  static double add(double val1, val2) {
    return val1 + val2;
  }

  static double subtract(double val1, val2) {
    return val1 - val2;
  }

  static double multiply(double val1, double val2) {
    return val1 * val2;
  }

  static double divide(double val1, double val2) {
    return val1 / val2;
  }
}

class Calculator {
  static String parseString(String text) {
    List<String> numbersToAdd;
    double a, b, result;
    if (text.contains(Calculations.ADD)) {
      numbersToAdd = text.split(Calculations.ADD);
      a = double.parse(numbersToAdd[0]);
      b = double.parse(numbersToAdd[1]);
      result = Calculations.add(a, b);
    } else if (text.contains(Calculations.MULTIPLY)) {
      numbersToAdd = text.split(Calculations.MULTIPLY);
      a = double.parse(numbersToAdd[0]);
      b = double.parse(numbersToAdd[1]);
      result = Calculations.multiply(a, b);
    } else if (text.contains(Calculations.DIVIDE)) {
      numbersToAdd = text.split(Calculations.DIVIDE);
      a = double.parse(numbersToAdd[0]);
      b = double.parse(numbersToAdd[1]);
      result = Calculations.divide(a, b);
    } else if (text.contains(Calculations.SUBTRACT)) {
      numbersToAdd = text.split(Calculations.SUBTRACT);
      a = double.parse(numbersToAdd[0]);
      b = double.parse(numbersToAdd[1]);
      result = Calculations.subtract(a, b);
    } else {
      return text;
    }

    return NumberFormatter.format(result.toString());
  }
}
