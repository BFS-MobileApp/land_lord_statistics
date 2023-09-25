import 'package:claimizer/feature/useraccounts/data/models/user_model.dart';

abstract class UserAccountsLocalDataSource {

  Future<List<UserModel>> getUsersAccountsList();
}
