class RequestState {
  final List<String> requestInProgress;
  final List<String> requestSuccess;
  final String? error;

  const RequestState({
    this.requestInProgress = const [],
    this.requestSuccess = const [],
    this.error,
  });

  bool get hasError => error != null;
  bool get isLoading => requestInProgress.isNotEmpty;
  bool isRequestInProgress(String requestId) => requestInProgress.contains(requestId);
  bool isRequestSuccessful(String requestId) => requestSuccess.contains(requestId);

  RequestState copyWith({
    List<String>? requestInProgress,
    List<String>? requestSuccess,
    String? error,
  }) {
    return RequestState(
      requestInProgress: requestInProgress ?? this.requestInProgress,
      requestSuccess: requestSuccess ?? this.requestSuccess,
      error: error,
    );
  }
}