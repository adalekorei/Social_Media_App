import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:social_media/components/custom_textfield.dart';
import 'package:social_media/components/strings.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? _errorMsg;
  bool obscurePassword = true;
  IconData iconPassword = Icons.visibility_off;
  bool signInRequired = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          setState(() {
            signInRequired = false;
          });
        } else if (state is SignInProcess) {
          setState(() {
            signInRequired = true;
          });
        } else if (state is SignInFailure) {
          setState(() {
            signInRequired = false;
            _errorMsg = 'Invalid email or password';
          });
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: CustomTextfield(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icon(Icons.email_outlined),
                errorMsg: _errorMsg,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Please fill in this field';
                  } else if (!emailRexExp.hasMatch(val)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: CustomTextfield(
                controller: passwordController,
                hintText: 'Password',
                obscureText: obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                prefixIcon: Icon(Icons.lock_outline),
                errorMsg: _errorMsg,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Please fill in this field';
                  } else if (!passwordRexExp.hasMatch(val)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                      if (obscurePassword) {
                        iconPassword = Icons.visibility_off;
                      } else {
                        iconPassword = Icons.visibility;
                      }
                    });
                  },
                  icon: Icon(iconPassword),
                ),
              ),
            ),
            SizedBox(height: 30),
            !signInRequired
                ? SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<SignInBloc>().add(
                          SignInRequired(
                            emailController.text,
                            passwordController.text,
                          ),
                        );
                      }
                    },
                    style: TextButton.styleFrom(
                      elevation: 3,
                      backgroundColor: theme.colorScheme.outline,
                      foregroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 5,
                      ),
                      child: Text(
                        'Sign in',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
                : const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
