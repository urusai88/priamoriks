// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactsListItem _$ContactsListItemFromJson(Map<String, dynamic> json) {
  return ContactsListItem(
    user: json['user'] == null
        ? null
        : UserEntity.fromJson(json['user'] as Map<String, dynamic>),
    contact: json['contact'] == null
        ? null
        : ContactEntity.fromJson(json['contact'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ContactsListItemToJson(ContactsListItem instance) =>
    <String, dynamic>{
      'user': instance.user,
      'contact': instance.contact,
    };

ContactsListItemsResponse _$ContactsListItemsResponseFromJson(
    Map<String, dynamic> json) {
  return ContactsListItemsResponse(
    items: (json['items'] as List)
        ?.map((e) => e == null
            ? null
            : ContactsListItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    count: json['count'] as int,
  );
}

Map<String, dynamic> _$ContactsListItemsResponseToJson(
        ContactsListItemsResponse instance) =>
    <String, dynamic>{
      'items': instance.items,
      'count': instance.count,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _ContactsService implements ContactsService {
  _ContactsService(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= '/contacts';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<ContactsListItemsResponse> list(
      {offset = 0, onlyFavorite = false}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'offset': offset,
      r'only_favorite': onlyFavorite
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ContactsListItemsResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<ContactEntity> make({userId}) async {
    ArgumentError.checkNotNull(userId, 'userId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {'user_id': userId};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/make',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ContactEntity.fromJson(_result.data);
    return value;
  }

  @override
  Future<void> remove({userId}) async {
    ArgumentError.checkNotNull(userId, 'userId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {'user_id': userId};
    _data.removeWhere((k, v) => v == null);
    await _dio.request<void>('/remove',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    return null;
  }
}
