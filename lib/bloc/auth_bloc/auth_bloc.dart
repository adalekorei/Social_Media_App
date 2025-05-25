import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepo userRepo;
  late final StreamSubscription<User?> _userSubsctiption;

  AuthBloc({required UserRepo myUserRepo})
    : userRepo = myUserRepo,
      super(const AuthState.unknown()) {
    _userSubsctiption = userRepo.user.listen((authUser) {
      add(AuthUserChanged(authUser));
    });

    on<AuthUserChanged>((event, emit) {
      try {
        if (event.user != null) {
          emit(AuthState.authenticated(event.user!));
        } else {
          emit(const AuthState.unauthenticated());
        }
      } catch (e) {}
    });
  }
  @override
  Future<void> close() {
    _userSubsctiption.cancel();
    return super.close();
  }
}
