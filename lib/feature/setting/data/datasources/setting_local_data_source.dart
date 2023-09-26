
import '../models/user_model.dart';

abstract class SettingLocalDataSource {

  Future<List<UserModel>> getUsersAccountsList();
}
