// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'laravel_error_bag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LaravelErrorBag _$LaravelErrorBagFromJson(Map<String, dynamic> json) {
  return LaravelErrorBag(
    message: json['message'] as String,
    errors: (json['errors'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, (e as List)?.map((e) => e as String)?.toList()),
    ),
  );
}

Map<String, dynamic> _$LaravelErrorBagToJson(LaravelErrorBag instance) =>
    <String, dynamic>{
      'message': instance.message,
      'errors': instance.errors,
    };
