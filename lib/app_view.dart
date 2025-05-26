import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/bloc/auth_bloc/auth_bloc.dart';
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
      home: BlocBuilder<AuthBloc, AuthState>(builder: (context, state){
        if(state.status == AuthStatus.authenticated){
          return const HomeScreen();
        } else {
          return const WelcomeScreen();
        }
      }),
    );
  }
}
