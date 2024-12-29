import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestStatus {
  RequestStatus({
    required this.requestInProgress,
    required this.requestSuccess,
  });
  List<String> requestInProgress = [];
  List<String> requestSuccess = [];
}

class RequestStatusNotifier extends StateNotifier<RequestStatus> {
  RequestStatusNotifier()
      : super(
          RequestStatus(requestInProgress: [], requestSuccess: []),
        );

  void setRequestStatus() {
    state = RequestStatus(
      requestInProgress: [],
      requestSuccess: [],
    );
  }

  void addRequestInProgress(String requestId) {
    state = RequestStatus(
      requestInProgress: [...state.requestInProgress, requestId],
      requestSuccess: state.requestSuccess,
    );
  }

  void addRequestSuccess(String requestId) {
    state = RequestStatus(
      requestInProgress:
          state.requestInProgress.where((id) => id != requestId).toList(),
      requestSuccess: [...state.requestSuccess, requestId],
    );
  }
}

final requestStatusProvider =
    StateNotifierProvider<RequestStatusNotifier, RequestStatus>(
  (ref) => RequestStatusNotifier(),
);
