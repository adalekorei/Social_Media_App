import 'models/models.dart';

abstract class PostRepo {

  Future<Post> createPost(Post post);

  Future<List<Post>> getPost();
}