class TTextStrings {
  //! -------------------- Buttons --------------------
  static const String addButton = 'Add';
  static const String addedButton = 'Added';
  static const String joinButton = 'Join';
  static const String joinedButton = 'Joined';
  static const String offerButton = 'Offer';
  static const String offeredButton = 'Offered';
  static const String requestButton = 'Request';
  static const String requestedButton = 'Requested';
  static const String viewProfileButton = 'View Profile';
  static const String leaveButton = 'Leave';
  static const String stayButton = 'Stay';

  static const String joinTeam = 'Join Team';
  static const String createTeam = 'Create Team';
  static const String exploreTeams = 'Explore Teams';

  //! -------------------- Match Formats --------------------
  static const String over5 = '5 overs';
  static const String over10 = '10 overs';
  static const String over20 = '20 overs';
  static const String over50 = '50 overs';
  static const String test = 'Test';

  static const String over5Key = 'over5';
  static const String over10Key = 'over10';
  static const String over20Key = 'over20';
  static const String over50Key = 'over50';
  static const String testKey = 'test';

  //! -------------------- Authentication --------------------
  static const String email = 'Email';
  static const String password = 'Password';
  static const String username = 'Username';
  static const String playerName = 'Player Name';

  static const String forgetPassword = 'Forget Password?';
  static const String wantToSignup = 'Sign Up?';
  static const String wantToLogin = 'Login?';

  static const String login = 'Login';
  static const String signup = 'Sign Up';
  static const String logout = 'Logout';

  static const String enterEmail = 'Enter your email';
  static const String editEmail = 'Edit email';
  static const String resetPassword = 'Reset Password';
  static const String resendEmail = 'Resend Email';
  static const String resetEmailSent = 'Reset Email Sent';
  static const String resetPasswordMessage =
      'Enter your registered email address. We\'ll send you a link to reset your password.';
  static const String backToLogin = 'Back to Login';
  static const String authentication = 'Authentication';
  static const String sendEmail = 'Send Email';
  static const String verified = 'Verified';
  static const String resendVerificationEmail = 'Resend Verification Email';

  static String resetEmailSentMsg(String email) =>
      'A password reset link has been sent to ${email.trim()}. Please check your inbox!';

  //! -------------------- Role Selection --------------------
  static const String selectCricketRole = 'Select Cricket Role';
  static const String selectBattingPosition = 'Select Batting Position';
  static const String selectBowlingStyle = 'Select Bowling Style';
  static const String selectBowlingArm = 'Select Bowling Arm';

  static const String loginAsPlayer = 'Login as Player';
  static const String signupAsPlayer = 'Signup as Player';
  static const String loginAsUser = 'Login as User';
  static const String signupAsUser = 'Signup as User';

  //! -------------------- Verification Messages --------------------
  static const String waitForEmailVerification = 'Wait for email verification';
  static const String emailVerificationSuccessfully =
      'Verification email sent successfully!';
  static const String emailVerificationFailed =
      'Email verification failed. Please try again.';
  static const String loginSuccessfully = 'Login successful!';

  static const String confirmExit = 'Confirm Exit';
  static const String confirmExitMessage =
      'Leaving now will cancel the verification process. Are you sure?';

  //! -------------------- Roles --------------------
  static const String user = 'User';
  static const String player = 'Player';
  static const String userRole = 'user';
  static const String playerRole = 'player';

  //! -------------------- Error Messages --------------------
  static const String teamCapacityError =
      'The team has reached its maximum capacity.';
  static const String unexpectedError =
      'An unexpected error occurred. Please try again later.';
  static const String somethingWentWrong =
      'Something went wrong. Please try again later.';
  static const String error = 'Error';
  static const String wrongEmailOrPassword =
      'Wrong email or password. Please try again.';
  static const String loadingPlayerDataError =
      'Error on loading player data :';

  //! -------------------- Authentication Errors --------------------
  static const String emailUsedByUser =
      'This email is already in use. Try another email or log in as a user.';
  static const String emailUsedByPlayer =
      'This email is already in use. Try another email or log in as a player.';
  static const String verificationTimeout = 'Verification timed out.';
  static const String noAuthenticationUser = 'No authenticated user found.';
  static const String userNotFound = 'User not found.';
  static const String userNotFoundMessage =
      'No user found with the provided email. Please sign up first.';

  //! -------------------- Success Messages --------------------
  static const String success = 'success';

  //! -------------------- Firebase Auth Error Codes --------------------
  static const String emailAlreadyInUse = 'email-already-in-use';
  static const String emailUsedByUserCode = 'Email-is-already-in-use-as-user';
  static const String emailUsedByPlayerCode =
      'Email-is-already-in-use-as-player';
  static const String userNotFoundCode = 'user-not-found';
  static const String invalidCredentialCode = 'invalid-credential';

  //! -------------------- Home Navigation --------------------
  static const String teams = 'Teams';
  static const String matches = 'Matches';
  static const String tournaments = 'Tournaments';

  //! -------------------- Teams --------------------
  static const String teamLoading = 'Loading your teams...';
  static const String noTeam = 'No Team Found Yet';
  static const String noTeamMessage =
      'Join or create a team to get started. Explore teams and connect with players.';

  //! -------------------- Team Error --------------------
  static const String failedToUpdateTeam =
      'Failed to update team :';
  static const String failedToUpdateTeamField =
      'Failed to update team field :';
  static const String teamPlayerNotFound =
      'Player not found in team';
  static const String failedToDeletePlayer =
      'Failed to delete player:';
  static const String teamHasReachedMaxCapacity =
      'Team has reached maximum capacity';
  static const String playerAlreadyInTeam =
      'Player already exists in team';
  static const String failedToAddPlayer =
      'Failed to add player:';
  static const String failedToUpdatePlayerRole =
      'Failed to update player role:';
  static const String capacityCannotBeReduce =
      'Team capacity cannot be reduce below current team size';
  static const String capacityCannotBeLessThanOne =
      'Team capacity cannot be less than 1';
  static const String failedToUpdateTeamCapacity =
      'Failed to update team capacity:';
  
  //! -------------------- Team Role --------------------
  static const String owner = 'owner';
  static const String admin = 'admin';
}
