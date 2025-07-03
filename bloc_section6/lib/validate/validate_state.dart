class ValidateState {
  ValidateState({bool? isValid, String? validationMessage}) {
    this.isValid = isValid;
    this.validationMessage = validationMessage;
  }

  bool? isValid;
  String? validationMessage;

  ValidateState? copyWith({bool? isValid, String? validationMessage}) {
    return ValidateState(
        isValid: isValid ?? false,
        validationMessage:
            validationMessage ?? "Entered email address is wrong!");
  }
}
