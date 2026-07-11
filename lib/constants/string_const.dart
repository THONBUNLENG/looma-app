extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this);
  }
}

extension PhoneValidator on String {
  bool isPhoneNumber() {
    return RegExp(r'^[+]*[(]?[0-9]{1,3}[)]?[-\s./]?[0-9]{3,14}').hasMatch(this);
  }
}

extension StringExtension on String {
  String get obfuscateContact {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    final phoneRegex = RegExp(r'^\d+$');

    final input = this;

    if (emailRegex.hasMatch(input)) {
      final parts = input.split('@');
      final name = parts[0];
      final domain = parts[1];

      if (name.length <= 2) {
        return '${name[0]}*****@$domain';
      } else {
        final visible = name.substring(0, 3);
        return '$visible*****@$domain';
      }
    } else if (phoneRegex.hasMatch(input) && input.length >= 4) {
      final first = input.substring(0, 3);
      final last = input.substring(input.length - 2);
      return '$first****$last';
    }

    return input;
  }

  String get capitalize {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
