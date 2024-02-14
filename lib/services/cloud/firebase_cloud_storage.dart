import 'dart:js_interop_unsafe';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_logger/services/cloud/cloud_note.dart';
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


  Stream<Iterable<CloudLog>> allLogs({
    required String ownerUserId
    })=>
    logs.snapshots().map((event)=> event.docs
    .map((doc)=> CloudLog.fromSnapshot(doc))
    .where((log) => log.ownerUserId == ownerUserId)); 

  Future<Iterable<CloudLog>> getLogs({required String ownerUserId}) async{
    try{
      return await logs
      .where(
        ownerUserIdFieldName,
        isEqualTo: ownerUserId 
      )
      .get()
      .then(
        (value) => value.docs.map(
        (doc) {
          return CloudLog(
            documentId: doc.id, 
            ownerUserId:  doc.data()[ownerUserIdFieldName] as String, 
            text: doc.data()[textFieldName] as String,
          );
        },
      ),
    );
    }catch (e){
      throw CouldNotCreateLogException();
    }
  }
  
  
  
void createNewLog({required String ownerUserId}) async{
    await logs.add(({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    }));
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory  FirebaseCloudStorage() => _shared; 
} 