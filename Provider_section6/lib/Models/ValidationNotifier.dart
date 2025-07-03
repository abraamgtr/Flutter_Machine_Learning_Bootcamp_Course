import 'package:flutter/cupertino.dart';

class ValidationNotifier extends ChangeNotifier {
  bool _isValid = false;
  String _validationMessage = "It is not valid";
  bool get isValid => this._isValid;
  String get validationMessage => this._validationMessage;

  void checkForValidation(String value) {
    if (value.contains("@")) {
      _isValidCheck();
    } else {
      _isNotValidCheck();
    }
  }

  _isValidCheck() {
    this._isValid = true;
    this._validationMessage = "Entered email address is valid!";
    notifyListeners();
  }

  _isNotValidCheck() {
    this._isValid = false;
    this._validationMessage = "Entered email address is not valid!";
    notifyListeners();
  }
}
