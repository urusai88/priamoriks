// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactEntity _$ContactEntityFromJson(Map<String, dynamic> json) {
  return ContactEntity(
    id: json['id'] as int,
    ownerId: json['owner_id'] as int,
    contactUserId: json['contact_user_id'] as int,
  );
}

Map<String, dynamic> _$ContactEntityToJson(ContactEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner_id': instance.ownerId,
      'contact_user_id': instance.contactUserId,
    };
