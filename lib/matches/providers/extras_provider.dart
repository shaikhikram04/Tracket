import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExtrasState {
  final bool isWide;
  final bool isNoBall;
  final bool isLegBye;
  final bool isBye;

  ExtrasState({
    this.isWide = false,
    this.isNoBall = false,
    this.isLegBye = false,
    this.isBye = false,
  });

  ExtrasState copyWith({
    bool? isWide,
    bool? isNoBall,
    bool? isLegBye,
    bool? isBye,
  }) {
    return ExtrasState(
      isWide: isWide ?? this.isWide,
      isNoBall: isNoBall ?? this.isNoBall,
      isLegBye: isLegBye ?? this.isLegBye,
      isBye: isBye ?? this.isBye,
    );
  }
}

final extrasProvider =
    StateNotifierProvider<ExtrasNotifier, ExtrasState>((ref) {
  return ExtrasNotifier();
});

class ExtrasNotifier extends StateNotifier<ExtrasState> {
  ExtrasNotifier() : super(ExtrasState());

  void updateExtras(ExtrasState Function(ExtrasState) update) {
    state = update(state);
  }

  void reset() {
    state = ExtrasState();
  }
}
