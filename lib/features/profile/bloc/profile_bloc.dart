import 'package:crypto_coins_flutter/features/profile/bloc/profile_event.dart';
import 'package:crypto_coins_flutter/features/profile/bloc/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadTransactions>((event, emit) {
      // TODO: implement event handler
    });
    on<LoadUserData>((event, emit) {
      // TODO: implement event handler
    });
  }
}
