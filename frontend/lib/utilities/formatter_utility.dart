
import 'package:flutter/material.dart';

class FormatterUtility {
  static const String numberSeparator = " ";

  static String getNumberOnly(String numberWithOther) {
    return numberWithOther.replaceAll(RegExp("\\D"), "");
  }

  static String phoneNumberFormatter(String numberOnly) {
    if (numberOnly.isEmpty) {
      return numberOnly;
    }

    // #Case Local Format (010-1234-5678):
    if (numberOnly[0] == "0") {
      return _phoneNumberLocalFormatter(numberOnly, numberSeparator);
    }

    // #Case Global Format (+82 10-1234-5678):
    else {
      return _phoneNumberGlobalFormatter(numberOnly, numberSeparator);
    }
  }

  static String _phoneNumberLocalFormatter(String numberOnly, String separator) {
    // format : 010-1234-5678 ~
    if (numberOnly.length > 10) {
      return numberOnly.replaceAllMapped(
          RegExp(r'(\d{3})(\d{4})(\d)'), (m) => '${m[1]}$separator${m[2]}$separator${m[3]}');
    }

    // format : 010-123-1 ~ 010-123-4567
    else if (numberOnly.length > 6) {
      int tailLength = numberOnly.length - 6;
      return numberOnly.replaceAllMapped(
          RegExp(r'(\d{3})(\d{3})(\d)'), (m) => '${m[1]}$separator${m[2]}$separator${m[3]}');
    }
    // format : 010-1 ~ 010-123
    else if (numberOnly.length > 3) {
      return numberOnly.replaceAllMapped(
          RegExp(r'(\d{3})(\d)'), (m) => '${m[1]}$separator${m[2]}');
    }

    // format : ~ 010
    return numberOnly;
  }

  static String _phoneNumberGlobalFormatter(String numberOnly, String separator) {
    // FIXME : +82 10-1234-5678
    return numberOnly;
  }
}