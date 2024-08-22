import 'package:ahmad_progress_soft_task/blocs/post/post_model.dart';

class PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<PostModel> posts;
  final List<PostModel> filteredPosts;

  PostLoaded(this.posts, this.filteredPosts);
}

class PostError extends PostState {
  final String message;

  PostError(this.message);
}
