import 'package:hive_flutter/hive_flutter.dart';

part 'user_model.g.dart';

// user model for hive db that will store user data using app..

@HiveType(typeId: 1)
class UserModel extends HiveObject {

  //user id
  @HiveField(0)
  final String uid;

  // for storing user name
  @HiveField(1)
  final String name;

  // image url of user profile..
  @HiveField(2) 
  final String image;

  // constructor of user model
  UserModel(
  {
  required this.uid, 
  required this.name, 
  required this.image
  }
  );
  
}
