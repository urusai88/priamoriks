import 'package:json_annotation/json_annotation.dart';

part 'contact_entity.g.dart';

@JsonSerializable()
class ContactEntity {
  final int id;
  @JsonKey(name: 'owner_id')
  final int ownerId;
  @JsonKey(name: 'contact_user_id')
  final int contactUserId;

  ContactEntity({this.id, this.ownerId, this.contactUserId});

  factory ContactEntity.fromJson(Map<String, dynamic> json) =>
      _$ContactEntityFromJson(json);
}
