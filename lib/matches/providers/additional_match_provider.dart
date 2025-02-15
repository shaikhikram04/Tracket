import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdditionalMatchState {
  final bool isOverCompleted;
  final bool isInningsCompleted;
  final bool isMatchCompleted;
  final bool isWicketDown;

  AdditionalMatchState({
    required this.isOverCompleted,
    required this.isInningsCompleted,
    required this.isMatchCompleted,
    required this.isWicketDown,
  });

  AdditionalMatchState copyWith({
    bool? isOverCompleted,
    bool? isInningsCompleted,
    bool? isMatchCompleted,
    bool? isWicketDown,
  }) {
    return AdditionalMatchState(
      isOverCompleted: isOverCompleted ?? this.isOverCompleted,
      isInningsCompleted: isInningsCompleted ?? this.isInningsCompleted,
      isMatchCompleted: isMatchCompleted ?? this.isMatchCompleted,
      isWicketDown: isWicketDown ?? this.isWicketDown,
    );
  }
}

class AdditionalMatchProvider extends StateNotifier<AdditionalMatchState> {
  AdditionalMatchProvider()
      : super(AdditionalMatchState(
          isOverCompleted: false,
          isInningsCompleted: false,
          isMatchCompleted: false,
          isWicketDown: false,
        ));

  void setIsOverCompleted(bool value) {
    state = state.copyWith(isOverCompleted: value);
  }

  void setIsInningsCompleted(bool value) {
    state = state.copyWith(isInningsCompleted: value);
  }

  void setIsMatchCompleted(bool value) {
    state = state.copyWith(isMatchCompleted: value);
  }

  void setIsWicketDown(bool value) {
    state = state.copyWith(isWicketDown: value);
  }
}

final additionalMatchProvider =
    StateNotifierProvider<AdditionalMatchProvider, AdditionalMatchState>(
  (ref) => AdditionalMatchProvider(),
);
