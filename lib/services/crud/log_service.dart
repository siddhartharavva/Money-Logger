import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:money_logger/services/crud/crud_exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;



class LogsService {
  Database? _db;

  List<DatabaseLog> _logs = [];

  final _logsStreamController = 
      StreamController<List<DatabaseLog>>.broadcast();
  Stream<List<DatabaseLog>> get allLogs => _logsStreamController.stream;
  Future<DatabaseUser> getOrCreateUser({required String email}) async{
    
    try{
      
      final user = await getUser(email: email);
      return user;
    }on CouldnotfindUser{
      final createdUser = await createUser(email: email);
      return createdUser;
    }catch (e){
      rethrow;
    }
  }

  Future<void> _cachedLogs() async{
    final allLogs  = await getAllLogs();
    _logs = allLogs.toList();
    _logsStreamController.add(_logs);
  }
  
  Future<DatabaseLog> updateLog({
    required DatabaseLog log,
    required String text
    }) async {
       await _ensureDbIsOpen();
       final db = _getDatabaseOrThrow();

       await getLog(id: log.id);
       final updatesCount = await db.update(logsTable,{
        textColumn: text, 
        isSyncedWithCloudColumn: 0,
       });

      if(updatesCount == 0){
        throw CouldNotUpdateLog();
      }else{
        final updatedLog  = await getLog(id: log.id);
        _logs.removeWhere((log) => log.id == updatedLog.id);
        _logs.add(updatedLog);
        _logsStreamController.add(_logs);
        return updatedLog;
      }

    }

  Future<Iterable<DatabaseLog>> getAllLogs() async{
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final logs = await db.query(logsTable);
    return logs.map((logRow) => DatabaseLog.fromRow(logRow));

  }

  Future<DatabaseLog> getLog({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final logs = await db.query(
      logsTable,
      limit: 1,
      where : 'id = ?',   
      whereArgs: [id],
    );

    if(logs.isEmpty){
      throw CouldNotFindLog();
    }else{
      
      final log = DatabaseLog.fromRow(logs.first);
      _logs.removeWhere((log) => log.id == id);
      _logs.add(log);
      _logsStreamController.add(_logs);
      return log;
    }

  }
  
  Future<int> deleteAllLogs() async{
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeletions  = await db.delete(logsTable);
    _logs = [];
    _logsStreamController.add(_logs);
    return numberOfDeletions;
  }
  
  Future<void> deleteLog({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      logsTable,
      where:'id = ?', 
      whereArgs: [id],
      
      );
      if(deletedCount != 1){
      throw CouldNotDeleteNote();
    }else{
      _logs.removeWhere((log) => log.id == id);
      _logsStreamController.add(_logs);
    }
}

  Future<DatabaseLog> createLog({required DatabaseUser owner}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    // make sure owner    exists in the databse with the correct id

    final dbUser = await getUser(email: owner.email);
    if(dbUser != owner){
      throw CouldnotfindUser();
    }
    const text = ' ';
    // create the note
    final logId = await db.insert(logsTable, {
      userIdColumn: owner.id,
      textColumn: text,
      isSyncedWithCloudColumn: 1,
    });

    final log = DatabaseLog(
      id: logId, 
      text: text, 
      userId: owner.id, 
      isSyncedWithCloud: true,
      );
      
      
    _logs.add(log);
    _logsStreamController.add(_logs);

      return log;

  }
  
  Future<DatabaseUser> getUser({required String email}) async{
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if(results.isEmpty){
      throw CouldnotfindUser();
    }else{
      return DatabaseUser.fromRow(results.first); 
    }

  }
  
  Future<DatabaseUser> createUser({required String email}) async{
    await _ensureDbIsOpen();

    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable, 
      limit: 1, 
      where: 'email = ?' , 
      whereArgs: [email.toLowerCase()],
    );
    
    if(results.isNotEmpty){
      throw UserAlreadyExists();
    }

    final userId = await db.insert(userTable,{
      emailColumn : email.toLowerCase(),
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
    where:'email = ?', 
    whereArgs: [email. toLowerCase()],
    
    );
    if(deletedCount != 1){
     throw CouldNotDeleteUser();
    }
}

  Database _getDatabaseOrThrow(){
    final db = _db;
    if(db == null){
      throw DatabaseIsNotOpen();
    }else{
      return db;
    }
  }


  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      // create the user table
      await db.execute(createUserTable);
      // create note table
      await db.execute(createLogsTable);
      await _cachedLogs();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }

  Future<void> close() async {
    
    final db = _db;
    if(db == null){
      throw DatabaseIsNotOpen();
    }else{
       db.close;
      _db = null;
    }

}
  Future<void> _ensureDbIsOpen()async{
    try{
      await open();
    }on DatabaseAlreadyOpenException{
      //empty
    }
  
  }
}
@immutable
class DatabaseUser{
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
  String toString() => 'Person, ID = $id , email= $email';

  @override 
  bool operator == (covariant DatabaseUser other) => id == other.id;
  
  @override
  int get hashCode => id.hashCode;
}

class DatabaseLog{
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;
  const DatabaseLog({
    required this.id, 
    required this.text,
    required this.userId,
    required this.isSyncedWithCloud,

  });  


  DatabaseLog.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSyncedWithCloud = 
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false ;
  @override
  String toString() => 'Log, ID = $id, userId = $userId, isSyncedWithCLoud = $isSyncedWithCloud , text = $text';

  @override 
  bool operator == (covariant DatabaseLog other) => id == other.id;
  
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
