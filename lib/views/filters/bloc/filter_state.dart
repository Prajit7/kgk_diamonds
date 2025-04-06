import 'package:equatable/equatable.dart';
import 'package:kgk_dia/models/diamond_model.dart';

abstract class FilterState extends Equatable {
  @override
  List<Object> get props => [];
}

class FilterInitial extends FilterState {}

class FilterLoading extends FilterState {}

class FilterLoaded extends FilterState {
  final List<Diamond> filteredDiamonds;

  FilterLoaded({required this.filteredDiamonds});

  @override
  List<Object> get props => [filteredDiamonds];
}

class FilterError extends FilterState {
  final String message;

  FilterError({required this.message});

  @override
  List<Object> get props => [message];
}
