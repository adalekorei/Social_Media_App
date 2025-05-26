import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/app_view.dart';
import 'package:social_media/bloc/auth_bloc/auth_bloc.dart';
import 'package:user_repository/user_repository.dart';

class MyApp extends StatelessWidget {
  final UserRepo userRepo;
  const MyApp(this.userRepo, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthBloc(myUserRepo: userRepo))
      ], 
      child: AppView());
  }
}
