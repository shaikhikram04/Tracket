import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/features/teams/providers/request_state.dart';

class RequestNotifier extends StateNotifier<RequestState> {
  RequestNotifier() : super(const RequestState());

  void reset() {
    state = const RequestState();
  }

  void setError(String errorMessage) {
    state = state.copyWith(error: errorMessage);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void addRequestInProgress(String requestId) {
    if (state.isRequestInProgress(requestId)) return;
    
    state = state.copyWith(
      requestInProgress: [...state.requestInProgress, requestId],
      error: null,
    );
  }

  void markRequestSuccess(String requestId) {
    state = state.copyWith(
      requestInProgress: state.requestInProgress.where((id) => id != requestId).toList(),
      requestSuccess: [...state.requestSuccess, requestId],
      error: null,
    );
  }

  void markRequestFailure(String requestId, String errorMessage) {
    state = state.copyWith(
      requestInProgress: state.requestInProgress.where((id) => id != requestId).toList(),
      error: errorMessage,
    );
  }
}