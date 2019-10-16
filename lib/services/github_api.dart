import 'package:flutter/foundation.dart';
import 'package:github_search/models/repo.dart';
import 'package:github_search/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GithubApi with ChangeNotifier {
  final String apiURL = 'https://api.github.com/';
  User user;
  GithubApi();
  List<Repo> repos = [];
  String _jsonResponse = '';
  bool _isFetching = false;
  bool _hasData = false;
  bool _hasRepoData = false;
  int _currentPage = 1;

  bool get isFetching => _isFetching;
  String get getResponseText => _jsonResponse;
  User get getUser => user;
  List<Repo> get getRepo => repos;
  bool get hasData => _hasData;
  bool get hasRepoData => _hasRepoData;
  int get currentPage => _currentPage;

  Future<void> fetchUserData({String query, String category}) async {
    _isFetching = true;
    notifyListeners();

    var response = await http.get(apiURL + category + '/' + query);

    _jsonResponse = response.body;

    user = User.fromJson(json.decode(_jsonResponse));
    _hasData = true;
    _isFetching = false;
    notifyListeners();
  }

  Future<void> fetchRepoData({String query}) async {
    _isFetching = true;
    repos.clear();
    _currentPage = 1;
    notifyListeners();

    var response = await http.get(query + '?page=1');
    _jsonResponse = response.body;

    if (_jsonResponse.isNotEmpty) {
      List<dynamic> json = jsonDecode(_jsonResponse);
      for (int i = 0; i < json.length; ++i) {
        Repo temp = Repo.fromJson(json[i]);
        repos.add(temp);
      }
    }
    _hasRepoData = true;
    _isFetching = false;
    notifyListeners();
  }

  Future<void> fetchNextRepoData({String query, int page}) async {
    _isFetching = true;
    notifyListeners();

    var response = await http.get(query + '?page=' + page.toString());
    _jsonResponse = response.body;

    if (_jsonResponse.isNotEmpty) {
      List<dynamic> json = jsonDecode(_jsonResponse);
      for (int i = 0; i < json.length; ++i) {
        Repo temp = Repo.fromJson(json[i]);
        repos.add(temp);
      }
    }
    _currentPage = page;
    _hasRepoData = true;
    _isFetching = false;
    notifyListeners();
  }

  void clearData() {
    _currentPage = 1;
    _hasData = false;
    _hasRepoData = false;
    repos.clear();
  }
}
