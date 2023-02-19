import 'package:intl/intl.dart';

class FormatNumbers {
  static String getNumberAverage(double firstValue, double secondValue) {
    return ((firstValue + secondValue) / 2).toStringAsFixed(2).replaceAll('.', ',');
  }

  static String scoreIntNumber(int? value) {
    if (value == null) {
      return "0";
    }
    var formatter = NumberFormat.decimalPattern();
    return formatter.format(value).replaceAll(',', '*').replaceAll('.', ',').replaceAll('*', '.');
  }

  static String numbersToString(double? value) {
    if (value != null) {
      return value.toStringAsFixed(2).replaceAll('.', ',');
    }
    return "";
  }

  static String formatVideoTime(int minutes, int seconds) {
    String formatedMinutes = "";
    String formatedSeconds = "";

    if (minutes < 10) {
      formatedMinutes += "0" + minutes.toString();
    } else {
      formatedMinutes += minutes.toString();
    }

    if (seconds < 10) {
      formatedSeconds += "0" + seconds.toString();
    } else {
      formatedSeconds += seconds.toString();
    }

    return formatedMinutes + ":" + formatedSeconds;
  }

  static String numbersToMoney(double? value) {
    if (value == null) return "";

    return NumberFormat.currency(
      name: 'R\$',
      locale: 'pt_BR',
      decimalDigits: 2,
    ).format(value);
  }

  static String intToMoney(int? value) {
    if (value == null) return "";

    return NumberFormat.currency(
      name: 'R\$',
      locale: 'pt_BR',
      decimalDigits: 2,
    ).format(value);
  }

  static String stringToMoney(String? value) {
    try {
      if (value == null) return "";

      double doubleValue = double.parse(value.replaceAll(',', '.'));

      return NumberFormat.currency(
        name: 'R\$',
        locale: 'pt_BR',
        decimalDigits: 2,
      ).format(doubleValue);
    } catch (_) {
      return "";
    }
  }

  static double stringToNumber(String? value) {
    if (value != null) {
      try {
        return double.tryParse(value.replaceAll('R\$', '').replaceAll(".", "").replaceAll(",", ".").trim()) ?? 0;
      } catch (_) {
        return 0;
      }
    }
    return 0;
  }

  static String stringToCpf(String? value) {
    if (value != null) {
      try {
        return value[0] +
            value[1] +
            value[2] +
            "." +
            value[3] +
            value[4] +
            value[5] +
            "." +
            value[6] +
            value[7] +
            value[8] +
            "-" +
            value[9] +
            value[10];
      } catch (_) {
        return "";
      }
    }
    return "";
  }

  static String removeNumbersRegex(String value) {
    return value.replaceAll(RegExp(r'[0-9]'), '');
  }
}
