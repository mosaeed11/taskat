import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';
import '../../core/constants/app_constants.dart';

class ApiService {
  // Fetch posts from JSONPlaceholder API
  Future<List<PostModel>> fetchPosts() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.apiBaseUrl}/posts'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => PostModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }

  // Fetch single post
  Future<PostModel> fetchPost(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.apiBaseUrl}/posts/$id'),
      );

      if (response.statusCode == 200) {
        return PostModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching post: $e');
    }
  }
}