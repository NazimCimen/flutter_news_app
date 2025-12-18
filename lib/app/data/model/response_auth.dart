import 'package:flutter_news_app/app/data/model/user_model.dart';

/// RESPONSE RESPONSE MODEL
class ResponseAuth {
  final String accessToken;
  final UserModel user;

  ResponseAuth({required this.accessToken, required this.user});
}
