import 'dart:async';
import 'dart:io';

import 'package:github_search/models/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ghsearch3.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE User ("
          "id INTEGER PRIMARY KEY,"
          "login TEXT,"
          "avatar_url TEXT,"
          "html_url TEXT,"
          "followers_url TEXT,"
          "following_url TEXT,"
          "starred_url TEXT,"
          "subscriptions_url TEXT,"
          "organizations_url TEXT,"
          "repos_url TEXT,"
          "events_url TEXT,"
          "name TEXT,"
          "company TEXT,"
          "bio TEXT,"
          "blog TEXT,"
          "public_repos INTEGER,"
          "UNIQUE(id)"
          ")");
    });
  }

  newClient(User newClient) async {
    final db = await database;
    //get the biggest id in the table

    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT OR IGNORE Into User (id,login,avatar_url,html_url,followers_url,following_url,"
        "starred_url,subscriptions_url,organizations_url,repos_url,events_url,name,company,bio,blog,public_repos)"
        " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
        [
          newClient.id,
          newClient.username,
          newClient.avatar,
          newClient.htmlUrl,
          newClient.followersUrl,
          newClient.followingUrl,
          newClient.starredUrl,
          newClient.subscriptionUrl,
          newClient.organizationsUrl,
          newClient.reposUrl,
          newClient.eventsUrl,
          newClient.name,
          newClient.company,
          newClient.bio,
          newClient.blog,
          newClient.publicRepos
        ]);
    return raw;
  }

  updateClient(User newClient) async {
    final db = await database;
    var res = await db.update("User", newClient.toMap(),
        where: "id = ?", whereArgs: [newClient.id]);
    return res;
  }

  getClient(int id) async {
    final db = await database;
    var res = await db.query("User", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? User.fromJson(res.first) : null;
  }

  Future<List<User>> getAllClients() async {
    final db = await database;
    var res = await db.query("User");
    List<User> list =
        res.isNotEmpty ? res.map((c) => User.fromJson(c)).toList() : [];
    return list;
  }

  deleteClient(int id) async {
    final db = await database;
    return db.delete("User", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from User");
  }
}
