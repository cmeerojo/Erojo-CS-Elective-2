import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/jdm_car.dart';
import '../services/jdm_service.dart';

const jdmPageSize = 8;
const jdmMinPrice = 0.0;
const jdmMaxPrice = 10000000.0;

final jdmServiceProvider = Provider<JdmService>((ref) => JdmService());

enum JdmLoadStatus { initial, loading, success, error }

class JdmState {
  final JdmLoadStatus status;
  final List<JdmCar> cars;
  final int page;
  final double minPrice;
  final double maxPrice;
  final bool hasNextPage;
  final String? errorMessage;

  const JdmState({
    this.status = JdmLoadStatus.initial,
    this.cars = const [],
    this.page = 0,
    this.minPrice = jdmMinPrice,
    this.maxPrice = jdmMaxPrice,
    this.hasNextPage = false,
    this.errorMessage,
  });

  JdmState copyWith({
    JdmLoadStatus? status,
    List<JdmCar>? cars,
    int? page,
    double? minPrice,
    double? maxPrice,
    bool? hasNextPage,
    String? errorMessage,
    bool clearError = false,
  }) {
    return JdmState(
      status: status ?? this.status,
      cars: cars ?? this.cars,
      page: page ?? this.page,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

final jdmControllerProvider = NotifierProvider<JdmController, JdmState>(
  JdmController.new,
);

class JdmController extends Notifier<JdmState> {
  JdmService get _service => ref.read(jdmServiceProvider);

  @override
  JdmState build() => const JdmState();

  Future<void> fetchPage({int? page}) async {
    final targetPage = page ?? state.page;
    state = state.copyWith(
      status: JdmLoadStatus.loading,
      page: targetPage,
      clearError: true,
    );
    try {
      final result = await _service.fetchPage(
        page: targetPage,
        pageSize: jdmPageSize,
        minPrice: state.minPrice,
        maxPrice: state.maxPrice,
      );
      state = state.copyWith(
        status: JdmLoadStatus.success,
        cars: result.cars,
        hasNextPage: result.hasNextPage,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(
        status: JdmLoadStatus.error,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> setPriceRange(RangeValues values) async {
    state = state.copyWith(
      minPrice: values.start,
      maxPrice: values.end,
      page: 0,
    );
    await fetchPage(page: 0);
  }
}
