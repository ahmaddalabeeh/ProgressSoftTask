import 'package:ahmad_progress_soft_task/blocs/language/language_bloc.dart';
import 'package:ahmad_progress_soft_task/blocs/language/language_event.dart';
import 'package:ahmad_progress_soft_task/blocs/profile/profile_bloc.dart';
import 'package:ahmad_progress_soft_task/blocs/profile/profile_event.dart';
import 'package:ahmad_progress_soft_task/blocs/profile/profile_state.dart';
import 'package:ahmad_progress_soft_task/language/model/language_model.dart';
import 'package:ahmad_progress_soft_task/screens/auth/auth_imports.dart';
import 'package:ahmad_progress_soft_task/screens/auth/sign_in_screen.dart';
import 'package:ahmad_progress_soft_task/screens/home/home_imports.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;
  final SharedPreferences sharedPreferences;

  const ProfileScreen(
      {super.key, required this.userId, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    final LanguageBloc languageBloc = BlocProvider.of<LanguageBloc>(context);

    return BlocProvider(
      create: (context) =>
          ProfileBloc(FirebaseFirestore.instance)..add(LoadUserProfile(userId)),
      child: Scaffold(
        backgroundColor: AppColors.backGroundAppColor,
        body: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileInitial) {
              NavigationHelper.navigateToReplacement(
                  context, SignInScreen(sharedPreferences: sharedPreferences));
            } else if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProfileLoaded) {
                final user = state.user;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            ResourcePath.progress_soft_logo_png,
                            width: 250.w,
                            height: 250.h,
                          ),
                        ],
                      ),
                      SizedBox(height: 45.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                user.name,
                                style: TextStyle(
                                  fontSize: FontSizes.xLarge,
                                  fontWeight: FontWeights.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.r),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ProfileDetailRow(
                                      icon: Icons.cake,
                                      label: AppLocalizations.of(context)!.age,
                                      value: user.age.toString(),
                                    ),
                                    ProfileDetailRow(
                                      icon: Icons.person,
                                      label:
                                          AppLocalizations.of(context)!.gender,
                                      value: user.gender,
                                    ),
                                    ProfileDetailRow(
                                      icon: Icons.phone,
                                      label: AppLocalizations.of(context)!
                                          .phoneNumber,
                                      value: user.phoneNumber,
                                    ),
                                    // Logout Button
                                    SizedBox(height: 16.h),
                                    Center(
                                      child: ElevatedButton(
                                        style: const ButtonStyle(
                                            side: WidgetStatePropertyAll(
                                                BorderSide(
                                                    color: AppColors
                                                        .primaryColor)),
                                            backgroundColor:
                                                WidgetStatePropertyAll(AppColors
                                                    .backGroundAppColor)),
                                        onPressed: () {
                                          context
                                              .read<ProfileBloc>()
                                              .add(LogoutUser());
                                        },
                                        child: Text(
                                            style: TextStyle(
                                                color: AppColors.primaryColor,
                                                fontWeight:
                                                    FontWeights.semiBold,
                                                fontSize: FontSizes.mid),
                                            AppLocalizations.of(context)!
                                                .signOut),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          languageBloc.add(
                            const ChangeLanguage(
                                selectedLanguage: LanguageModel.english),
                          );
                        },
                        child: const Text('Switch to English'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          languageBloc.add(
                            const ChangeLanguage(
                                selectedLanguage: LanguageModel.arabic),
                          );
                        },
                        child: const Text('Switch to عربي'),
                      ),
                    ],
                  ),
                );
              } else if (state is ProfileError) {
                return Center(
                  child: Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else {
                return const Center(child: Text('No data found.'));
              }
            },
          ),
        ),
      ),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileDetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryColor),
          SizedBox(width: 10.w),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeights.bold,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
