

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:money_logger/services/cloud/cloud_storage_constants.dart';

@immutable
class CloudLog {
  final String documentId;
  final String ownerUserId;
  final String text;
  const CloudLog({
    required this.documentId,
    required this.ownerUserId,
    required this.text
});

CloudLog.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot):
  documentId = snapshot.id,
  ownerUserId = snapshot.data()[ownerUserIdFieldName],
  text = snapshot.data()[textFieldName] as String;


}