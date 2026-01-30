import '../services/api_service.dart';
import '../models/post_model.dart';

class ApiRepository {
  final ApiService _apiService;

  ApiRepository({required ApiService apiService}) : _apiService = apiService;

  Future<List<PostModel>> fetchPosts() async {
    return await _apiService.fetchPosts();
  }

  Future<PostModel> fetchPost(int id) async {
    return await _apiService.fetchPost(id);
  }
}