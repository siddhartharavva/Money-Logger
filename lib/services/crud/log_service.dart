import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:money_logger/services/crud/crud_exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

class LogsService {
  Database? _db;

  List<Databaselog> _logs = [];

  static final LogsService _shared = LogsService._sharedInstance();
  LogsService._sharedInstance();
  factory LogsService() => _shared;

  final _logsStreamController =
      StreamController<List<Databaselog>>.broadcast();

  Stream<List<Databaselog>> get allLogs => _logsStreamController.stream;

  Future<DatabaseUser> getOrCreateUser({required String email}) async {
    try {
      final user = await getUser(email: email);
      debugPrint(user.toString());
      return user;
    } on CouldnotfindUser {
      final createdUser = await createUser(email: email);
      debugPrint(createdUser.toString());
      return createdUser;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> _cachelogs() async {
    final allLogs = await getallLogs();
    _logs = allLogs.toList();
    _logsStreamController.add(_logs);
  }

  Future<Databaselog> updatelog({
    required Databaselog log,
    required String text,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    // make sure log exists
    await getlog(id: log.id);

    // update DB
    final updatesCount = await db.update(logsTable, {
      textColumn: text,
      isSyncedWithCloudColumn: 0,
    });

    if (updatesCount == 0) {
      throw CouldNotUpdateLog();
    } else {
      final updatedlog = await getlog(id: log.id);
      _logs.removeWhere((log) => log.id == updatedlog.id);
      _logs.add(updatedlog);
      _logsStreamController.add(_logs);
      return updatedlog;
    }
  }

  Future<Iterable<Databaselog>> getallLogs() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final logs = await db.query(logsTable);

    return logs.map((logRow) => Databaselog.fromRow(logRow));
  }

  Future<Databaselog> getlog({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final logs = await db.query(
      logsTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (logs.isEmpty) {
      throw CouldnotfindUser();
    } else {
      final log = Databaselog.fromRow(logs.first);
      _logs.removeWhere((log) => log.id == id);
      _logs.add(log);
      _logsStreamController.add(_logs);
      return log;
    }
  }

  Future<int> deleteallLogs() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeletions = await db.delete(logsTable);
    _logs = [];
    _logsStreamController.add(_logs);
    return numberOfDeletions;
  }

  Future<void> deletelog({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      logsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteLog();
    } else {
      _logs.removeWhere((log) => log.id == id);
      _logsStreamController.add(_logs);
    }
  }

  Future<Databaselog> createlog({required DatabaseUser owner}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    // make sure owner exists in the database with the correct id
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldnotfindUser();
    }

    const text = '';
    // create the log
    final logId = await db.insert(logsTable, {
      userIdColumn: owner.id,
      textColumn: text,
      isSyncedWithCloudColumn: 1,
    });

    final log = Databaselog(
      id: logId,
      userId: owner.id,
      text: text,
      isSyncedWithCloud: true,
    );

    _logs.add(log);
    _logsStreamController.add(_logs);

    return log;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (results.isEmpty) {
      throw CouldnotfindUser();
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExists();
    }

    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });

    return DatabaseUser(
      id: userId,
      email: email,
    );
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      // empty
    }
  }

  Future<void> open() async {
    if (_db != null) {
      //throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      // create the user table
      await db.execute(createUserTable);
      // create log table
      await db.execute(createLogsTable);
      await _cachelogs();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;
  const DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'Person, ID = $id, email = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class Databaselog {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  Databaselog({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,
  });

  Databaselog.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      'log, ID = $id, userId = $userId, isSyncedWithCloud = $isSyncedWithCloud, text = $text';

  @override
  bool operator ==(covariant Databaselog other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
const dbName = 'Logs.db';
const logsTable = 'log';
const userTable = 'user';

const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
        "id"	INTEGER NOT NULL,
        "email"	TEXT NOT NULL UNIQUE,
        PRIMARY KEY("id" AUTOINCREMENT)
      );''';
const createLogsTable = '''CREATE TABLE IF NOT EXISTS "log" (
        "id"	INTEGER NOT NULL,
        "user_id"	INTEGER NOT NULL,
        "text"	TEXT,
        "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY("user_id") REFERENCES "user"("id"),
        PRIMARY KEY("id" AUTOINCREMENT)
      );''';
