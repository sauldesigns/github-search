import 'package:flutter/foundation.dart';
import 'package:github_search/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GithubApi with ChangeNotifier {
  final String apiURL = 'https://api.github.com/';
  User user;
  GithubApi();

  String _jsonResponse = '';
  bool _isFetching = false;
  bool _hasData = false;

  bool get isFetching => _isFetching;
  String get getResponseText => _jsonResponse;
  User get getUser => user;
  bool get hasData => _hasData;

  Future<void> fetchUserData({String query, String category}) async {
    _isFetching = true;
    notifyListeners();

    var response = await http.get(apiURL + category + '/' + query);

    // if (response.statusCode == 200) {
    _jsonResponse = response.body;
    // }

    print(_jsonResponse);
    user = User.fromJson(json.decode(_jsonResponse));
    _hasData = true;
    _isFetching = false;
    notifyListeners();
  }
}
