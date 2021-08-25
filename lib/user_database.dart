import 'package:cloud_firestore/cloud_firestore.dart';

class UserDatabase {
  getUserByUsername(String username) async {
    return FirebaseFirestore.instance.collection("users")
        .where("userName",isEqualTo: username)
        .get();
  }
  getUserByUseremail(String useremail) async {
    return FirebaseFirestore.instance.collection("users")
        .where("userEmail",isEqualTo: useremail)
        .get().catchError((e){
          print(e.toString());
    });
  }

  Future<void> uploadUserInfo(userDetail) async {
    FirebaseFirestore.instance.collection("users")
        .add(userDetail).catchError((e) {
      print(e.toString());
    });
  }
  createUserChat(String userchatid,Map<String,dynamic> userchatMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("UserChat")
        .doc(userchatid)
        .get();
    if (snapShot.exists) {
      return true;
    }
    else {
      return FirebaseFirestore.instance.collection("UserChat").doc(userchatid)
          .set(userchatMap);
    }
  }
  Future<void> addUserMessages(String userChatId,Map<String,dynamic> messageMap)async {
    FirebaseFirestore.instance.collection("UserChat")
        .doc(userChatId).collection("chats").add(messageMap);
  }
  updateLastMessageSend(String userChatId,Map<String,dynamic> lastMessageMap) {
    return FirebaseFirestore.instance
        .collection("UserChat")
        .doc(userChatId)
        .update(lastMessageMap);
  }
  Future<Stream<QuerySnapshot>> getUserMessages(String userChatId) async {
    return FirebaseFirestore.instance.collection("UserChat")
        .doc(userChatId).collection("chats")
        .orderBy("time",descending: false).snapshots();
  }
  Future<Stream<QuerySnapshot>> getUserChats(String sendername) async {
    return FirebaseFirestore.instance
        .collection("UserChat")
        .where('users', arrayContains:sendername).snapshots();
  }

}