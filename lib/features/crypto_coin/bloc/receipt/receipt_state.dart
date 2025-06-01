import 'package:equatable/equatable.dart';

abstract class ReceiptState extends Equatable {
  const ReceiptState();

  @override
  List<Object?> get props => [];
}

class ReceiptInitial extends ReceiptState {}

class ReceiptCreated extends ReceiptState {}

class ReceiptCreating extends ReceiptState {}

class ReceiptDownloading extends ReceiptState {}

class ReceiptDownloaded extends ReceiptState {
  final String filePath;

  ReceiptDownloaded({required this.filePath});
}

class ReceiptError extends ReceiptState {
  final Object exception;

  ReceiptError({required this.exception});

  @override
  List<Object?> get props => [exception];
}
