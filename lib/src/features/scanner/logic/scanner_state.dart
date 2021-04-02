import 'package:freezed_annotation/freezed_annotation.dart';

part 'scanner_state.freezed.dart';

extension EasyValidation on ScannerState {
  bool get isLoading => this is _Loading;
}

@freezed
abstract class ScannerState with _$ScannerState {
  /// Initial/default state
  const factory ScannerState.initial() = _Initial;

  /// Data is loading state
  const factory ScannerState.loading() = _Loading;
}
