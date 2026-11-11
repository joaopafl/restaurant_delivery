import 'package:guia_restaurantes/data/services/user_service.dart';
import 'package:guia_restaurantes/models/user.dart';

class UserRepository {
  final UserService _service = UserService();
  Future<void> creatUser(User user) async {
    await _service.postUser(user);
  }
}