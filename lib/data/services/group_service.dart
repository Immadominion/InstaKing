import 'package:dio/dio.dart' show Response;
import 'package:insta_king/data/services/dio_mixin.dart';

class GroupService with DioMixin {
  Future<Response<dynamic>> fetchUserGroup({
    required String id,
  }) async {
    return await sendRequest(() {
      return connect().get(
        '/users/$id/groups',
      );
    });
  }
}
