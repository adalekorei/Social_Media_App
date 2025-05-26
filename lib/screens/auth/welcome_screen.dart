import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/bloc/auth_bloc/auth_bloc.dart';
import 'package:social_media/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:social_media/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:social_media/screens/auth/sign_in_screen.dart';
import 'package:social_media/screens/auth/sign_up_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              spacing: 20,
              children: [
                SizedBox(height: 60),
                Text(
                  'Welcome Back!',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                Image.asset(
                  'assets/logo.png',
                  color: Colors.white,
                  width: 230,
                  height: 150,
                ),
                TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  unselectedLabelColor: theme.tabBarTheme.unselectedLabelColor,
                  labelColor: theme.tabBarTheme.labelColor,
                  controller: tabController,
                  tabs: [
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'Sign In',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'Sign Up',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      BlocProvider<SignInBloc>(
                        create: (context) => SignInBloc(
                          userRepo: context.read<AuthBloc>().userRepo
                        ),
                        child: SignInScreen(),
                      ),
                      BlocProvider<SignUpBloc>(
                        create: (context) => SignUpBloc(
                          userRepo: context.read<AuthBloc>().userRepo
                        ),
                        child: SignUpScreen(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
