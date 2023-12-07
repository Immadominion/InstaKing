import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:insta_king/data/local/secure_storage_service.dart';
import 'package:insta_king/presentation/controllers/base_controller.dart';

final dashBoardControllerProvider = ChangeNotifierProvider<DashBoardController>(
  (ref) => DashBoardController(),
);

final SecureStorageService secureStorageService =
    SecureStorageService(secureStorage: const FlutterSecureStorage());

class DashBoardController extends BaseChangeNotifier {
  int page = 0;

  Future<String> getName() async {
    String? name = await secureStorageService.read(key: "name");
    List<String> part = name.toString().split(" ");
    name = part[0];
    return name;
  }

  Future<String> getImage() async {
    String? picture = await secureStorageService.read(key: "picture");
    return picture as String;
  }

  Future<String> getEmail() async {
    String? email = await secureStorageService.read(key: "email");
    if (email == null) {
      return '';
    } else if (email.isEmpty) {
      return '';
    } else {
      return email;
    }
  }

  Future<String> getId() async {
    String? id = await secureStorageService.read(key: "id");
    return id as String;
  }

  void resetPage() {
    page = 0;
    notifyListeners();
  }

  void switchPage(int index) {
    page = index;
    notifyListeners();
  }
}
