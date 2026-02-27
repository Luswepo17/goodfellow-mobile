class APPValidator {
  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    // if (value.length < 5) {
    //   return 'Password must be at least 5 characters long';
    // }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required.';
    }

    final phoneRegExp = RegExp(r'^(95|96|97|76|77|75|55|56|57)[0-9]{7}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Invalid phone number format. Ex: 9xxxxxxxx 0r 7xxxxxxxx';
    }

    return null;
  }

  static String? validateCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'Card number is required.';
    }

    final visaRegExp = RegExp(
        r'^(?:4[0-9]{12}(?:[0-9]{3})?|[25][1-7][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})$');

    if (!visaRegExp.hasMatch(value)) {
      return 'Invalid card number';
    }

    return null;
  }

  static String? validateCvv(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV is required.';
    }

    final cvvRegExp = RegExp(r'^[0-9]{3,4}$');

    if (!cvvRegExp.hasMatch(value)) {
      return 'Invalid CVV number';
    }

    return null;
  }

  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required.';
    }

    final amountRegExp = RegExp(r'^\d*\.?\d*$');

    if (!amountRegExp.hasMatch(value)) {
      return 'Invalid amount number';
    }

    if (double.parse(value) < 1.00) {
      return 'Amount cannot be less than K1';
    }

    if (double.parse(value) > 10000.00) {
      return 'You have exceeded the limit of K10,000';
    }

    if (value.contains('.')) {
      if (value.split('.')[1].length > 2) {
        return 'Only two decimal place are allowed';
      }
    }
    return null;
  }

  static String? validateMonthYear(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required.';
    }

    final cvvRegExp = RegExp(r'^[0-9]{2}$');

    if (!cvvRegExp.hasMatch(value)) {
      return 'Invalid $fieldName';
    }

    return null;
  }

  static String? validateNRC(String? value) {
    if (value == null || value.isEmpty) {
      return 'NRC or passport number is required.';
    }

    final phoneRegExp = RegExp(r'^(ZN[0-9]{6}|[0-9]{6}/[0-9]{2}/[1]{1})$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Invalid NRC or passport number';
    }

    return null;
  }
}
