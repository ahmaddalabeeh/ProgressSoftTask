import 'package:ahmad_progress_soft_task/blocs/post/post_event.dart';
import 'package:ahmad_progress_soft_task/blocs/post/post_model.dart';
import 'package:ahmad_progress_soft_task/blocs/post/post_repo.dart';
import 'package:ahmad_progress_soft_task/blocs/post/post_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;

  List<PostModel> allPosts = [];

  PostBloc(this.postRepository) : super(PostLoading()) {
    on<FetchPosts>((event, emit) async {
      try {
        emit(PostLoading());
        allPosts = await postRepository.fetchPosts();
        emit(PostLoaded(allPosts, allPosts));
      } catch (e) {
        emit(PostError('Failed to load posts'));
      }
    });

    on<FilterPosts>((event, emit) {
      final filteredPosts = allPosts
          .where((post) =>
              post.title
                  .toLowerCase()
                  .contains(event.searchText.toLowerCase()) ||
              post.body.toLowerCase().contains(event.searchText.toLowerCase()))
          .toList();
      emit(PostLoaded(allPosts, filteredPosts));
    });
  }
}
