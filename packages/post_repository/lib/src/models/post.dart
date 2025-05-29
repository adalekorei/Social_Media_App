import 'package:post_repository/src/entities/entities.dart';
import 'package:user_repository/user_repository.dart';

class Post {
  String postId;
  String post;
  DateTime createAt;
  MyUser myUser;

  Post({
    required this.postId,
    required this.post,
    required this.createAt,
    required this.myUser,
  });

  static var empty = Post(
    postId: '',
    post: '',
    createAt: DateTime.now(),
    myUser: MyUser.empty,
  );

  Post copyWith({
    String? postId,
    String? post,
    DateTime? createAt,
    MyUser? myUser,
  }) {
    return Post(
      postId: postId ?? this.postId,
      post: post ?? this.post,
      createAt: createAt ?? this.createAt,
      myUser: myUser ?? this.myUser,
    );
  }

  bool get isEmpty => this == Post.empty;
  bool get isNotEmpty => this != Post.empty;

  PostEntity toEntity() {
    return PostEntity(
      postId: postId,
      post: post,
      createAt: createAt,
      myUser: myUser,
    );
  }

  static Post fromEntity(PostEntity entity) {
    return Post(
      postId: entity.postId,
      post: entity.post,
      createAt: entity.createAt,
      myUser: entity.myUser,
    );
  }

  @override
  String toString() {
    return '''Post: {
    postId: $postId
    post: $post
    createAt: $createAt
    myUser: $myUser
    }''';
  }
}
