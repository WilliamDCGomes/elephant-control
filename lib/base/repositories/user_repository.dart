import 'package:elephant_control/base/models/user/user.dart';
import 'package:elephant_control/base/repositories/base/base_repository.dart';

class UserRepositoy extends BaseRepository {
  Future<User?> getUser() async {
    try {
      final userDb = await context.find(User.tableName);
      if (userDb.isEmpty) throw Exception();
      return User.fromJsonRepository(userDb.first);
    } catch (_) {
      return null;
    }
  }
}
