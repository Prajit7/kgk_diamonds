import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgk_dia/models/diamond_model.dart';
import 'filter_event.dart';
import 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  List<Diamond> _allDiamonds = [];

  FilterBloc() : super(FilterInitial()) {
    on<ApplyFilters>(_onApplyFilters);
    on<SortDiamonds>(_onSortDiamonds);
    on<ImportDiamonds>(_onImportDiamonds);
  }
  Future<void> _onApplyFilters(
    ApplyFilters event,
    Emitter<FilterState> emit,
  ) async {
    emit(FilterLoading());

    try {
      List<Diamond> filteredDiamonds = _allDiamonds.where((diamond) {
        bool matchesCarat =
            (event.minCarat == null || diamond.carat >= event.minCarat!) &&
                (event.maxCarat == null || diamond.carat <= event.maxCarat!);

        bool matchesLab = event.lab == null ||
            event.lab!.isEmpty ||
            diamond.lab.trim().toLowerCase() == event.lab!.trim().toLowerCase();

        bool matchesShape = event.shape == null ||
            event.shape!.isEmpty ||
            diamond.shape.trim().toLowerCase() ==
                event.shape!.trim().toLowerCase();

        bool matchesColor = event.color == null ||
            event.color!.isEmpty ||
            diamond.color.trim().toLowerCase() ==
                event.color!.trim().toLowerCase();

        bool matchesClarity = event.clarity == null ||
            event.clarity!.isEmpty ||
            diamond.clarity.trim().toLowerCase() ==
                event.clarity!.trim().toLowerCase();

        return matchesCarat &&
            matchesLab &&
            matchesShape &&
            matchesColor &&
            matchesClarity;
      }).toList();

      print("Filtered diamonds: ${filteredDiamonds.length}");
      emit(FilterLoaded(filteredDiamonds: filteredDiamonds));
    } catch (e) {
      emit(FilterError(message: "Error filtering diamonds: ${e.toString()}"));
    }
  }

  void _onSortDiamonds(SortDiamonds event, Emitter<FilterState> emit) {
    if (state is FilterLoaded) {
      List<Diamond> sorted =
          List.from((state as FilterLoaded).filteredDiamonds);

      if (event.sortBy == 'price') {
        sorted.sort((a, b) => event.ascending
            ? a.finalAmount.compareTo(b.finalAmount)
            : b.finalAmount.compareTo(a.finalAmount));
      } else if (event.sortBy == 'carat') {
        sorted.sort((a, b) => event.ascending
            ? a.carat.compareTo(b.carat)
            : b.carat.compareTo(a.carat));
      }

      emit(FilterLoaded(filteredDiamonds: sorted));
    }
  }

  Future<void> _onImportDiamonds(
      ImportDiamonds event, Emitter<FilterState> emit) async {
    try {
      _allDiamonds = event.diamonds;
      emit(FilterInitial());
    } catch (e) {
      emit(FilterError(message: "Failed to import diamonds"));
    }
  }
}
