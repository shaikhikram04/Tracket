import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestStatus {
  RequestStatus({
    required this.requestInProgress,
    required this.requestSuccess,
  });
  List<String> requestInProgress = [];
  List<String> requestSuccess = [];

  void addRequestInProgress(String requestId) {
    requestInProgress.add(requestId);
  }

  void addRequestSuccess(String requestId) {
    requestInProgress.remove(requestId);
    requestSuccess.add(requestId);
  }
}

class RequestStatusNotifier extends StateNotifier<RequestStatus> {
  RequestStatusNotifier()
      : super(
          RequestStatus(requestInProgress: [], requestSuccess: []),
        );

  void addRequestInProgress(String requestId) {
    state.addRequestInProgress(requestId);
    state = state;
  }

  void addRequestSuccess(String requestId) {
    state.addRequestSuccess(requestId);
    state = state;
  }
}
