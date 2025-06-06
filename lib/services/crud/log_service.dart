// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import 'package:money_logger/extensions/list/filter.dart';
// import 'package:money_logger/services/crud/crud_exceptions.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' show join;

// class LogsService {
//   Database? _db;

//   List<DatabaseLog> _logs = [];

// DatabaseUser? _user;


//   static final LogsService _shared = LogsService._sharedInstance();
//   LogsService._sharedInstance(){
//     _logsStreamController = StreamController<List<DatabaseLog>>.broadcast(
//       onListen: () {
//         _logsStreamController.sink.add(_logs);
//       },
//     );
//   }
//   factory LogsService() => _shared;

//   late final StreamController<List<DatabaseLog>> _logsStreamController ;


//   Stream<List<DatabaseLog>> get allLogs => 
//   _logsStreamController.stream.filter((log){
//   final  currentUser = _user;
//   if(currentUser != null){
//     return log.userId == currentUser.id;
//   }else{
//     throw UserShouldBeSetBeforeReadingAllLogs();
//   }

//   });

// Future<DatabaseUser> getOrCreateUser({
//   required String email,
//   bool setAsCurrentUser = true,
//   }) async {
//   try {
//     final existingUser = await getUser(email: email);
//     if(setAsCurrentUser){
//       _user = existingUser;
//     }
//     return existingUser;
//   } on CouldNotFindUser {

//     final createdUser = await createUser(email: email);
//   if(setAsCurrentUser){
//       _user = createdUser;
//     }
//     return createdUser;
//   } catch (e) {
//           debugPrint('Error in getOrCreateUser: $e');
//     rethrow;
//   }
// }
// Future<DatabaseUser> getUser({required String email}) async {
  

//     await _ensureDbIsOpen();

//     final db = _getDatabaseOrThrow();


//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );

//     if (results.isEmpty) {
//       throw CouldNotFindUser();
//     } else {
//       return DatabaseUser.fromRow(results.first);
//     }
//   }


//     Future<void> close() async {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpen();
//     } else {
//       await db.close();
//       _db = null;
//     }
//   }

//   Future<DatabaseUser> createUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (results.isNotEmpty) {
//       throw UserAlreadyExists();
//     }

//     final userId = await db.insert(userTable, {
//       emailColumn: email.toLowerCase(),
//     });

//     return DatabaseUser(
//       id: userId,
//       email: email,
//     );
//   }

//     Future<void> open() async {
//     if (_db != null) {
//       //throw DatabaseAlreadyOpenException();
//     }
//     try {
//       final docsPath = await getApplicationDocumentsDirectory();

//       final dbPath = join(docsPath.path, dbName);

//       final db = await openDatabase(dbPath);

//       _db = db;

//       // create the user table
//       await db.execute(createUserTable);
//       // create log table

//       await db.execute(createLogsTable);

//       await _cacheLogs(); // some problem fix here
                                      

//     } on MissingPlatformDirectoryException {
//       throw UnableToGetDocumentsDirectory();
//     }

//   }


//   Future<void> _cacheLogs() async {

//     final allLogs = await getAllLogs();

//     _logs = allLogs.toList();
//     _logsStreamController.add(_logs);
//   }

// Future<DatabaseLog> updateLog({
//   required DatabaseLog log,
//   required String text,
// }) async {
//   await _ensureDbIsOpen();
//   final db = _getDatabaseOrThrow();

//   // Update DB
//   final updatesCount = await db.update(logsTable, {
//     textColumn: text,
//     isSyncedWithCloudColumn: 0,

//   }, where: 'id = ?', whereArgs: [log.id]);

//   if (updatesCount == 0) {
//     throw CouldNotUpdateLog();
//   } else {
//     // Create a new DatabaseLog object with the updated properties
//     final updatedLog = DatabaseLog(
//       id: log.id,
//       userId: log.userId,
//       text: text,
//       isSyncedWithCloud: false,
//     );

//     // Update the log in the _logs list
//     final index = _logs.indexWhere((l) => l.id == log.id);
//     if (index != -1) {
//       _logs[index] = updatedLog;
//     }

//     // Notify listeners about the change in logs
//     _logsStreamController.add(_logs);
    
//     return updatedLog;
//   }
// }
// // this is the prev code now the new code is above
// /*
//   Future<DatabaseLog> updateLog({
//     required DatabaseLog log,
//     required String text,
//   }) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();

//     // make sure log exists
//     await getLog(id: log.id);

//     // update DB
//     final updatesCount = await db.update(logsTable, {
//       textColumn: text,
//       isSyncedWithCloudColumn: 0,
//     });

//     if (updatesCount == 0) {
//       throw CouldNotUpdateLog();
//     } else {
//       final updatedLog = await getLog(id: log.id);
//       _logs.removeWhere((log) => log.id == updatedLog.id);
//       _logs.add(updatedLog);
//       _logsStreamController.add(_logs);
//       return updatedLog;
//     }
//   }*/
//     Future<void> _ensureDbIsOpen() async {
//     try {
//       await open();
//     } on DatabaseAlreadyOpenException {
//       // empty
//     }
//   }

//   Future<Iterable<DatabaseLog>> getAllLogs() async {

//     final db = _getDatabaseOrThrow();

//     final logs = await db.query(logsTable);

//     return logs.map((logRow) => DatabaseLog.fromRow(logRow));
//   }

//   Future<DatabaseLog> getLog({required int id}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final logs = await db.query(
//       logsTable,
//       limit: 1,
//       where: 'id = ?',
//       whereArgs: [id],
//     );

//     if (logs.isEmpty) {
//       throw CouldNotFindUser();
//     } else {
//       final log = DatabaseLog.fromRow(logs.first);
//       _logs.removeWhere((log) => log.id == id);
//       _logs.add(log);
//       _logsStreamController.add(_logs);
//       return log;
//     }
//   }

//   Future<int> deleteAllLogs() async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final numberOfDeletions = await db.delete(logsTable);
//     _logs = [];
//     _logsStreamController.add(_logs);
//     return numberOfDeletions;
//   }

//   Future<void> deleteLog({required int id}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final deletedCount = await db.delete(
//       logsTable,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     if (deletedCount == 0) {
//       throw CouldNotDeleteLog();
//     } else {
//       _logs.removeWhere((log) => log.id == id);
//       _logsStreamController.add(_logs);
//     }
//   }

// Future<DatabaseLog> createLog({required DatabaseUser owner}) async {
//   await _ensureDbIsOpen();
//   final db = _getDatabaseOrThrow();

//   // make sure owner exists in the database with the correct id
//   final dbUser = await getUser(email: owner.email);
//   if (dbUser != owner) {
//     throw CouldNotFindUser();
//   }

//   const text = '';
//   // create the log
//   final logId = await db.insert(logsTable, {
//     userIdColumn: owner.id,
//     textColumn: text,
//     isSyncedWithCloudColumn: 1,
//   });

//   final log = DatabaseLog(
//     id: logId,
//     userId: owner.id,
//     text: text,
//     isSyncedWithCloud: true,
//   );

//   // Create a new list with the added log and the existing logs
//   final List<DatabaseLog> updatedLogs = List.from(_logs)..add(log);

//   // Notify listeners about the change in logs
//   _logsStreamController.add(updatedLogs);

//   return log;
// }



//   Future<void> deleteUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final deletedCount = await db.delete(
//       userTable,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (deletedCount != 1) {
//       throw CouldNotDeleteUser();
//     }
//   }

//   Database _getDatabaseOrThrow() {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpen();
//     } else {
//       return db;
//     }
//   }




// }

// @immutable
// class DatabaseUser {
//   final int id;
//   final String email;
//   const DatabaseUser({
//     required this.id,
//     required this.email,
//   });

//   DatabaseUser.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         email = map[emailColumn] as String;

//   @override
//   String toString() => 'Person, ID = $id, email = $email';

//   @override
//   bool operator ==(covariant DatabaseUser other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// class DatabaseLog {
//   final int id;
//   final int userId;
//   final String text;
//   final bool isSyncedWithCloud;

//   DatabaseLog({
//     required this.id,
//     required this.userId,
//     required this.text,
//     required this.isSyncedWithCloud,
//   });

//   DatabaseLog.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         userId = map[userIdColumn] as int,
//         text = map[textColumn] as String,
//         isSyncedWithCloud = (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

//   @override
//   String toString() =>
//       'log, ID = $id, userId = $userId, isSyncedWithCloud = $isSyncedWithCloud, text = $text';

//   @override
//   bool operator ==(covariant DatabaseLog other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// const dbName = 'logs.db';
// const logsTable = 'log';
// const userTable = 'user';

// const idColumn = 'id';
// const emailColumn = 'email';
// const userIdColumn = 'user_id';
// const textColumn = 'text';
// const isSyncedWithCloudColumn = 'is_synced_with_cloud';
// const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
//         "id"	INTEGER NOT NULL,
//         "email"	TEXT NOT NULL UNIQUE,
//         PRIMARY KEY("id" AUTOINCREMENT)
//       );''';
// const createLogsTable = '''CREATE TABLE IF NOT EXISTS "log" (
//         "id"	INTEGER NOT NULL,
//         "user_id"	INTEGER NOT NULL,
//         "text"	TEXT,
//         "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
//         FOREIGN KEY("user_id") REFERENCES "user"("id"),
//         PRIMARY KEY("id" AUTOINCREMENT)
//       );''';
