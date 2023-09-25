import 'package:claimizer/config/PrefHelper/dbhelper.dart';
import 'package:claimizer/feature/useraccounts/data/models/user_model.dart';
import 'package:claimizer/feature/useraccounts/data/datasources/useraccounts_remote_data_source.dart';

class UserAccountsLocalDataSourceImpl extends UserAccountsLocalDataSource {

  DatabaseHelper dbhelper;
  UserAccountsLocalDataSourceImpl({required this.dbhelper});

  @override
  Future<List<UserModel>> getUsersAccountsList() async{
    print('here');
    final users = await dbhelper.getUsers();
    print('here');
    for (var user in users) {
      print('User: ${user.name}, Email: ${user.email}, Active: ${user.active}');
    }
    return users;
  }
}
