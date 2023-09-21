class MyValidators {
  static String? nameValidator(value) {
    if (value!.isEmpty) {
      return '* name is required';
    } else if (value.length < 3) {
      return '* name must be at least 3 digits';
    }
    return null;
  }

  static String? phoneValidator(value) {
    if (value!.isEmpty) {
      return '* phone is required';
    } else if (value.length != 11) {
      return '* phone must be at least 11 digits';
    } else if (!value.startsWith("01")) {
      return '* phone must be start with 01';
    }
    return null;
  }

  static String? emailValidator(value) {
    if (value!.isEmpty) {
      return '* Email is required';
    } else if (!value.endsWith("@gmail.com")) {
      return '* Email must be end with @gmail.com';
    } else if (value.length < 13) {
      return '* Email must be at least 13 digits';
    }
    return null;
  }

  static String? passwordValidator(value) {
    if (value!.isEmpty) {
      return '* Password is required';
    } else if (value.length < 7) {
      return '* Password must be at least 7 chars and numbers';
    }
    return null;
  }

  static String? confirmPasswordValidator({value, String? password}) {
    if (value != password) {
      return '* Confirm password is Wrong';
    } else if (value.length < 7) {
      return '* Password must be at least 7 chars and numbers';
    }
    return null;
  }
}
