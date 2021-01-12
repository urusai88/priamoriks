import 'dart:async';
import 'package:face/import.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'auth_service.g.dart';

@JsonSerializable()
class SignupResponse {
  @JsonKey(name: 'api_token')
  final String apiToken;

  SignupResponse({@required this.apiToken});

  factory SignupResponse.fromJson(Map<String, dynamic> json) =>
      _$SignupResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SignupResponseToJson(this);

  @override
  String toString() => '${toJson()}';
}

@RestApi()
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  @POST('/signin')
  Future<SignupResponse> signin({@required @Field() String name});

  @GET('/user')
  Future<UserEntity> user();
}
