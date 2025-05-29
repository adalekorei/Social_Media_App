import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:social_media/bloc/auth_bloc/auth_bloc.dart';
import 'package:social_media/bloc/get_post_bloc/get_post_bloc.dart';
import 'package:social_media/bloc/my_user_bloc/my_user_bloc.dart';
import 'package:social_media/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:social_media/bloc/update_user_info_bloc/bloc/update_user_info_bloc.dart';
import 'package:social_media/theme.dart';

import 'screens/home/home_screen.dart';
import 'screens/auth/welcome_screen.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Social Network',
      theme: lightTheme,
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create:
                      (context) => SignInBloc(
                        userRepo: context.read<AuthBloc>().userRepo,
                      ),
                ),
                BlocProvider(
                  create:
                      (context) => UpdateUserInfoBloc(
                        userRepo: context.read<AuthBloc>().userRepo,
                      ),
                ),
                BlocProvider(
                  create:
                      (context) => MyUserBloc(
                        userRepo: context.read<AuthBloc>().userRepo,
                      )..add(
                        GetMyUser(
                          myUserId: context.read<AuthBloc>().state.user!.uid,
                        ),
                      ),
                ),
                BlocProvider(
                  create:
                      (conxtext) =>
                          GetPostBloc(postRepo: FirebasePostRepository())
                            ..add(GetPosts()),
                ),
              ],
              child: HomeScreen(),
            );
          } else {
            return const WelcomeScreen();
          }
        },
      ),
    );
  }
}
