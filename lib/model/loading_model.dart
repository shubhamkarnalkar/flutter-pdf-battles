import 'package:equatable/equatable.dart';

class LoadingModel extends Equatable {
  final String message;
  final bool isLoading;

  LoadingModel({this.message = '', this.isLoading = false});
  @override
  // TODO: implement props
  List<Object?> get props => [message, isLoading];
}
