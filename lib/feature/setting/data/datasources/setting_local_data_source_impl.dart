import 'package:claimizer/config/PrefHelper/dbhelper.dart';
import 'package:claimizer/feature/setting/data/datasources/setting_local_data_source.dart';
import 'package:claimizer/feature/setting/data/models/user_model.dart';

class SettingLocalDataSourceImpl extends SettingLocalDataSource {

  DatabaseHelper dbhelper;
  SettingLocalDataSourceImpl({required this.dbhelper});

  @override
  Future<List<UserModel>> getUsersAccountsList() async{
    final users = await dbhelper.getUsers();
    return users;
  }
}
