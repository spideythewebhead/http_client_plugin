// AUTO GENERATED - DO NOT MODIFY
// ignore_for_file: type=lint
// coverage:ignore-file

part of 'jsonplaceholderapi.dart';

class _$PostImpl extends Post {
  _$PostImpl({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  }) : super.ctor();

  @override
  final int id;

  @override
  final int userId;

  @override
  final String title;

  @override
  final String body;

  factory _$PostImpl.fromJson(Map<dynamic, dynamic> json) {
    return _$PostImpl(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
    };
  }

  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        other is Post &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            userId == other.userId &&
            title == other.title &&
            body == other.body;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      id,
      userId,
      title,
      body,
    ]);
  }

  @override
  String toString() {
    String toStringOutput = 'Post{<optimized out>}';
    assert(() {
      toStringOutput = 'Post@<$hexIdentity>{id: $id, userId: $userId, title: $title, body: $body}';
      return true;
    }());
    return toStringOutput;
  }

  @override
  Type get runtimeType => Post;
}

class _$CommentImpl extends Comment {
  _$CommentImpl({
    required this.id,
    required this.postId,
    required this.name,
    required this.email,
    required this.body,
  }) : super.ctor();

  @override
  final int id;

  @override
  final int postId;

  @override
  final String name;

  @override
  final String email;

  @override
  final String body;

  factory _$CommentImpl.fromJson(Map<dynamic, dynamic> json) {
    return _$CommentImpl(
      id: json['id'] as int,
      postId: json['postId'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      body: json['body'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'postId': postId,
      'name': name,
      'email': email,
      'body': body,
    };
  }

  @override
  bool operator ==(Object? other) {
    return identical(this, other) ||
        other is Comment &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            postId == other.postId &&
            name == other.name &&
            email == other.email &&
            body == other.body;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[
      runtimeType,
      id,
      postId,
      name,
      email,
      body,
    ]);
  }

  @override
  String toString() {
    String toStringOutput = 'Comment{<optimized out>}';
    assert(() {
      toStringOutput =
          'Comment@<$hexIdentity>{id: $id, postId: $postId, name: $name, email: $email, body: $body}';
      return true;
    }());
    return toStringOutput;
  }

  @override
  Type get runtimeType => Comment;
}

class _$JsonPlaceholderHttpServiceImpl extends JsonPlaceholderHttpService {
  _$JsonPlaceholderHttpServiceImpl(
    this._client, [
    String pathPrefix = '',
  ]) : super._() {
    if (pathPrefix.endsWith('/')) {
      pathPrefix = pathPrefix.substring(0, pathPrefix.length - 1);
    }
    _pathPrefix = pathPrefix;
  }

  late Dio _client;
  late final String _pathPrefix;

  @override
  JsonPlaceholderHttpService overrideHttpClient(Dio client) {
    _client = client;
    return this;
  }

  @override
  late final PostsHttpService posts = PostsHttpService(_client, _pathPrefix);
}

class _$PostsHttpServiceImpl extends PostsHttpService {
  _$PostsHttpServiceImpl(
    this._client, [
    String pathPrefix = '',
  ]) : super._() {
    if (pathPrefix.endsWith('/')) {
      pathPrefix = pathPrefix.substring(0, pathPrefix.length - 1);
    }
    _pathPrefix = '${pathPrefix}/posts';
  }

  late Dio _client;
  late final String _pathPrefix;

  @override
  PostsHttpService overrideHttpClient(Dio client) {
    _client = client;
    return this;
  }

  @override
  FutureHttpResult<List<Post>> getAll() async {
    try {
      final String path = '$_pathPrefix/';
      final Response<dynamic> response = await _client.get(
        path,
      );
      return HttpResult<List<Post>>.data(
          <Post>[for (final dynamic i0 in (response.data! as List<dynamic>)) Post.fromJson(i0)]);
    } on Exception catch (exception, stackTrace) {
      return HttpResult<List<Post>>.failure(exception, stackTrace: stackTrace);
    } catch (exception) {
      rethrow;
    }
  }

  @override
  FutureHttpResult<Post> getById(
    int id,
  ) async {
    try {
      final String path = '$_pathPrefix/:id'.replaceAllMapped(RegExp(r':(id)'), (Match match) {
        return switch (match.group(1)) {
          'id' => '$id',
          _ => '',
        };
      });
      final Response<dynamic> response = await _client.get(
        path,
      );
      return HttpResult<Post>.data(Post.fromJson(response.data!));
    } on Exception catch (exception, stackTrace) {
      return HttpResult<Post>.failure(exception, stackTrace: stackTrace);
    } catch (exception) {
      rethrow;
    }
  }

  @override
  FutureHttpResult<Post> createPost(
    Map<String, dynamic> data,
  ) async {
    try {
      final String path = '$_pathPrefix/';
      final Response<dynamic> response = await _client.post(
        path,
        data: data,
      );
      return HttpResult<Post>.data(Post.fromJson(response.data!));
    } on Exception catch (exception, stackTrace) {
      return HttpResult<Post>.failure(exception, stackTrace: stackTrace);
    } catch (exception) {
      rethrow;
    }
  }
}

class _$CommentsHttpImpl extends CommentsHttp {
  _$CommentsHttpImpl(
    this._client, [
    String pathPrefix = '',
  ]) : super._() {
    if (pathPrefix.endsWith('/')) {
      pathPrefix = pathPrefix.substring(0, pathPrefix.length - 1);
    }
    _pathPrefix = '${pathPrefix}/comments';
  }

  late Dio _client;
  late final String _pathPrefix;

  @override
  CommentsHttp overrideHttpClient(Dio client) {
    _client = client;
    return this;
  }

  @override
  FutureHttpResult<List<Comment>> get(
    int postId,
  ) async {
    try {
      final String path = '$_pathPrefix/';
      final Response<dynamic> response = await _client.get(
        path,
        queryParameters: <String, String>{
          'postId': postId.toString(),
        },
      );
      return HttpResult<List<Comment>>.data(<Comment>[
        for (final dynamic i0 in (response.data! as List<dynamic>)) Comment.fromJson(i0)
      ]);
    } on Exception catch (exception, stackTrace) {
      return HttpResult<List<Comment>>.failure(exception, stackTrace: stackTrace);
    } catch (exception) {
      rethrow;
    }
  }
}
