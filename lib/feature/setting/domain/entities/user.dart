import 'package:equatable/equatable.dart';

import '../../data/models/user_model.dart';

class User extends Equatable{

  final String name;
  final String email;
  final String token;
  final bool active;
  const User({required this.active , required this.email , required this.name , required this.token});

  @override
  List<Object?> get props => [name , email , token , active];
}