class FollowerData {
  FollowerData({
    required this.followerId,
    required this.profilePic,
    required this.userName,
  });

  final String followerId;
  final String profilePic;
  final String userName;

  Map<String, dynamic> get toMap => {
        'followerId': followerId,
        'profilePic': profilePic,
        'userName': userName,
      };
}
