import 'package:flutter/services.dart';

class MoneyMask extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var value = newValue.text.replaceAll(r'\D', '');

    value = (int.tryParse(value) ?? 0).toString();

    if (value.length < 3) {
      value = value.padLeft(3, '0');
    }

    value = value.split('').reversed.join();
    final listCharacters = [];
    var decimalCont = 0;

    for (var i = 0; i < value.length; i++) {
      if (i == 2) {
        listCharacters.insert(0, ',');
      }
      if (i > 2) {
        decimalCont++;
      }
      if (decimalCont == 3) {
        listCharacters.insert(0, '.');
        decimalCont = 0;
      }
      listCharacters.insert(0, value[i]);
    }

    listCharacters.insert(0, 'R\$ ');
    var formatted = listCharacters.join();

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.fromPosition(
        TextPosition(
          offset: formatted.length,
        ),
      ),
    );
  }
}