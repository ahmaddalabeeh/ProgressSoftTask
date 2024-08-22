import 'package:ahmad_progress_soft_task/screens/home/home_imports.dart';
import 'package:ahmad_progress_soft_task/screens/profile/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final SharedPreferences sharedPreferences;
  const HomeScreen({super.key, required this.sharedPreferences});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const PostList(),
      ProfileScreen(userId: '', sharedPreferences: widget.sharedPreferences),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundAppColor,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10.h,
        backgroundColor: AppColors.primaryColor,
        selectedItemColor: AppColors.whiteColor,
        unselectedFontSize: FontSizes.xSmall,
        selectedIconTheme: IconThemeData(size: 22.r),
        unselectedIconTheme: IconThemeData(size: 16.r),
        unselectedItemColor: AppColors.disabledColor,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: AppLocalizations.of(context)!.profile,
          ),
        ],
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text(
          _selectedIndex == 0
              ? AppLocalizations.of(context)!.posts
              : AppLocalizations.of(context)!.profile,
          style: TextStyle(
            fontSize: FontSizes.xLarge,
            fontWeight: FontWeight.bold,
            color: AppColors.whiteColor,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => PostBloc(PostRepository())..add(FetchPosts()),
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
    );
  }
}

class PostList extends StatefulWidget {
  const PostList({super.key});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  final TextEditingController _searchTextController = TextEditingController();

  @override
  void dispose() {
    _searchTextController.dispose();
    _searchTextController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          CustomTextField(
              hintText: AppLocalizations.of(context)!.search,
              onChanged: (value) {
                context.read<PostBloc>().add(FilterPosts(value));
                setState(() {});
              },
              textEditingController: _searchTextController,
              prefixIcon: Icons.search),
          SizedBox(
            height: 30.h,
          ),
          Expanded(
            child: BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                if (state is PostLoading) {
                  return ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return CardShimmer(height: 300.h, width: 320.w);
                    },
                  );
                } else if (state is PostLoaded) {
                  return ListView.builder(
                    itemCount: state.filteredPosts.length,
                    itemBuilder: (context, index) {
                      final post = state.filteredPosts[index];
                      return PostCard(
                        title: post.title,
                        body: post.body,
                      );
                    },
                  );
                } else if (state is PostError) {
                  return Center(child: Text(state.message));
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
