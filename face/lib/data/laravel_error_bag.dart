import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'laravel_error_bag.g.dart';

@JsonSerializable()
class LaravelErrorBag {
  final String message;
  final Map<String, List<String>> errors;

  LaravelErrorBag({@required this.message, @required this.errors});

  static String getError(String name, LaravelErrorBag errorBag) {
    if (errorBag == null || errorBag.errors == null) return null;
    if (!errorBag.errors.containsKey(name)) return null;
    if (errorBag.errors[name].isEmpty) return null;

    return errorBag.errors[name].first;
  }

  factory LaravelErrorBag.fromJson(Map<String, dynamic> json) =>
      _$LaravelErrorBagFromJson(json);
}
