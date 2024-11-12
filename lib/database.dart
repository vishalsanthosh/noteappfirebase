import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  static Future addNoteDetails(Map<String,dynamic>noteMapInfo,String id)async{
    return await FirebaseFirestore.instance.collection("Note").doc(id).set(noteMapInfo);
  }
   static Future<Stream<QuerySnapshot>> getNoteDetails() async{
  return await FirebaseFirestore.instance.collection("Note").snapshots();
}

static Future updateNoteDetails(String id,Map<String,dynamic> updateInfo) async{
  return await FirebaseFirestore.instance.collection("Note").doc(id).update(updateInfo);
}
  static Future deleteNoteDetails(String id) async{
  return await FirebaseFirestore.instance.collection("Note").doc(id).delete();
}
}