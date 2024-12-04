import 'package:data_class_plugin/data_class_plugin.dart';
import 'package:dio/dio.dart';
import 'package:http_client_plugin/http_client_plugin.dart';

part 'jsonplaceholderapi.gen.dart';

@DataClass()
abstract class Post {
  Post.ctor();

  /// Default constructor
  factory Post({
    required int id,
    required int userId,
    required String title,
    required String body,
  }) = _$PostImpl;

  /// Creates an instance of [Post] from [json]
  factory Post.fromJson(Map<dynamic, dynamic> json) = _$PostImpl.fromJson;

  int get id;
  int get userId;
  String get title;
  String get body;

  /// Converts [Post] to a [Map] json
  Map<String, dynamic> toJson();
}

@DataClass()
abstract class Comment {
  Comment.ctor();

  /// Default constructor
  factory Comment({
    required int id,
    required int postId,
    required String name,
    required String email,
    required String body,
  }) = _$CommentImpl;

  /// Creates an instance of [Comment] from [json]
  factory Comment.fromJson(Map<dynamic, dynamic> json) = _$CommentImpl.fromJson;

  int get id;
  int get postId;
  String get name;
  String get email;
  String get body;

  /// Converts [Comment] to a [Map] json
  Map<String, dynamic> toJson();
}

@HttpService()
abstract class JsonPlaceholderHttpService {
  JsonPlaceholderHttpService._();

  factory JsonPlaceholderHttpService(
    Dio client, [
    String pathPrefix,
  ]) = _$JsonPlaceholderHttpServiceImpl;

  JsonPlaceholderHttpService overrideHttpClient(Dio client);

  PostsHttpService get posts;
}

@HttpService('/posts')
abstract class PostsHttpService {
  PostsHttpService._();

  factory PostsHttpService(
    Dio client, [
    String pathPrefix,
  ]) = _$PostsHttpServiceImpl;

  PostsHttpService overrideHttpClient(Dio client);

  @HttpMethod.get()
  FutureHttpResult<List<Post>> getAll();

  @HttpMethod.get('/:id')
  FutureHttpResult<Post> getById(@PathParam() int id);

  @HttpMethod.post()
  FutureHttpResult<Post> createPost(@HttpPayload() Map<String, dynamic> data);
}

@HttpService('/comments')
abstract class CommentsHttp {
  CommentsHttp._();

  factory CommentsHttp(
    Dio client, [
    String pathPrefix,
  ]) = _$CommentsHttpImpl;

  CommentsHttp overrideHttpClient(Dio client);

  @HttpMethod.get()
  FutureHttpResult<List<Comment>> get(@QueryParam() int postId);
}
