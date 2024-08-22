class PostEvent {}

class FetchPosts extends PostEvent {}

class FilterPosts extends PostEvent {
  final String searchText;

  FilterPosts(this.searchText);
}
