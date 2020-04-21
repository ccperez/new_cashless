import '../../models/user.dart';
import '../../controller/users_controller.dart';

class LoginRequest {
	UsersController connect = UsersController();

	Future<User> getLogin(String phone, String password) {
		return connect.getLogin(phone, password);
	}
}
