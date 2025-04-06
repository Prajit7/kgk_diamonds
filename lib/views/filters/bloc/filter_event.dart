import 'package:equatable/equatable.dart';
import 'package:kgk_dia/models/diamond_model.dart';

abstract class FilterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ApplyFilters extends FilterEvent {
  final double? minCarat;
  final double? maxCarat;
  final String? lab;
  final String? shape;
  final String? color;
  final String? clarity;

  ApplyFilters({
    this.minCarat,
    this.maxCarat,
    this.lab,
    this.shape,
    this.color,
    this.clarity,
  });

  @override
  List<Object?> get props => [minCarat, maxCarat, lab, shape, color, clarity];
}

class SortDiamonds extends FilterEvent {
  final String sortBy;
  final bool ascending;

  SortDiamonds({required this.sortBy, this.ascending = true});
}

class ImportDiamonds extends FilterEvent {
  final List<Diamond> diamonds;
  ImportDiamonds(this.diamonds);
}
