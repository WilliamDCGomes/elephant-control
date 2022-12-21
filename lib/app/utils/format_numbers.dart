import 'package:intl/intl.dart';

class FormatNumbers {
  static String getNumberAverage(double firstValue, double secondValue) {
    return ((firstValue + secondValue)/2).toStringAsFixed(2).replaceAll('.', ',');
  }

  static String numbersToString(double? value) {
    if(value != null) {
      return value.toStringAsFixed(2).replaceAll('.', ',');
    }
    return "";
  }

  static String numbersToMoney(double? value) {
    if(value == null)
      return "";

    return NumberFormat.currency(
      name: 'R\$',
      locale: 'pt_BR',
      decimalDigits: 2,
    ).format(value);
  }

  static String stringToMoney(String? value) {
    try{
      if(value == null)
        return "";

      double doubleValue = double.parse(value.replaceAll(',', '.'));

      return NumberFormat.currency(
        name: 'R\$',
        locale: 'pt_BR',
        decimalDigits: 2,
      ).format(doubleValue);
    }
    catch(_){
      return "";
    }
  }

  static double stringToNumber(String? value) {
    if(value != null) {
      try{
        return double.tryParse(value.replaceAll('R\$', '').replaceAll(',', '.').trim()) ?? 0;
      }
      catch(_){
        return 0;
      }
    }
    return 0;
  }
}