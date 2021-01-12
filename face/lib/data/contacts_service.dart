import 'package:dio/dio.dart';
import 'package:face/import.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/http.dart';

part 'contacts_service.g.dart';

@JsonSerializable()
class ContactsListItem {
  final UserEntity user;
  final ContactEntity contact;

  ContactsListItem({this.user, this.contact});

  factory ContactsListItem.fromJson(Map<String, dynamic> json) =>
      _$ContactsListItemFromJson(json);

  ContactsListItem withContact(ContactEntity contact) =>
      ContactsListItem(user: user, contact: contact);
}

@JsonSerializable()
class ContactsListItemsResponse extends ItemsResponse<ContactsListItem> {
  final List<ContactsListItem> items;
  final int count;

  ContactsListItemsResponse({@required this.items, @required this.count});

  factory ContactsListItemsResponse.fromJson(Map<String, dynamic> json) =>
      _$ContactsListItemsResponseFromJson(json);
}

@RestApi(baseUrl: '/contacts')
abstract class ContactsService {
  factory ContactsService(Dio dio, {String baseUrl}) = _ContactsService;

  @GET('/')
  Future<ContactsListItemsResponse> list({
    @Query('offset') int offset = 0,
    @Query('only_favorite') bool onlyFavorite = false,
  });

  @POST('/make')
  Future<ContactEntity> make({@required @Field('user_id') int userId});

  @POST('/remove')
  Future<void> remove({@required @Field('user_id') int userId});
}
