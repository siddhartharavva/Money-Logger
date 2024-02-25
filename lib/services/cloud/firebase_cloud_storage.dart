
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_logger/services/cloud/cloud_log.dart';
import 'package:money_logger/services/cloud/cloud_storage_constants.dart';
import 'package:money_logger/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {

  final logs = FirebaseFirestore.instance.collection("logs");

  Future<void> updateLog({
    required String documentId,
    required String text,
  }) async{
    try{
      logs.doc(documentId).update({
        textFieldName: text,  
      });
    }catch(e){
      throw CouldNotUpdateLogException();
    }

  }

  Future<void> deleteLog({required String documentId}) async{
    try{
      await logs.doc(documentId).delete();
    }catch(e){
      throw CouldNotDeleteLogException();
    }
  }


  Stream<Iterable<CloudLog>> allLogs({required String ownerUserId}) {
  final allLogs = logs
      .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
      .snapshots()
      .map((event)=> event.docs
          .map((doc)=> CloudLog.fromSnapshot(doc))
          .where((log)=> log.ownerUserId == ownerUserId));
    return allLogs;
  }

   
  
  
Future<CloudLog> createNewLog({required String ownerUserId}) async{
    final document = await logs.add(({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    }));
    final fetchedLog = await document.get();
    return CloudLog(
      documentId: fetchedLog.id,
      ownerUserId: ownerUserId,
      text:'',
    );
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory  FirebaseCloudStorage() => _shared; 
} 