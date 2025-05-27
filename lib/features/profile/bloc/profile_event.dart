// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactions extends ProfileEvent {
  final Completer? completer;
  LoadTransactions({
    this.completer,
  });
}

class LoadUserData extends ProfileEvent {
  final Completer? completer;
  LoadUserData({
    this.completer,
  });
}
