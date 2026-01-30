import 'package:flutter/foundation.dart';
import '../data/repositories/api_repository.dart';
import '../data/models/post_model.dart';

class ApiProvider extends ChangeNotifier {
  ApiRepository _apiRepository;

  List<PostModel> _posts = [];
  bool _isLoading = false;
  String? _errorMessage;

  ApiProvider({required ApiRepository apiRepository})
      : _apiRepository = apiRepository;

  void setRepository(ApiRepository repo) {
    _apiRepository = repo;
  }

  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPosts() async {
    _setLoading(true);
    try {
      _posts = await _apiRepository.fetchPosts();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _setLoading(false);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
