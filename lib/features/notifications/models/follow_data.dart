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

  factory FollowerData.fromMap(Map<String, dynamic> map) => FollowerData(
        followerId: map['followerId'] as String,
        profilePic: map['profilePic'] as String,
        userName: map['userName'] as String,
      );

  FollowerData copyWith({
    String? followerId,
    String? profilePic,
    String? userName,
  }) =>
      FollowerData(
        followerId: followerId ?? this.followerId,
        profilePic: profilePic ?? this.profilePic,
        userName: userName ?? this.userName,
      );
}
