class TTextStrings {
  //! Button text
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

  //! Error messages
  static const String teamCapacityError =
      'Team has reached its maximum capacity.';
  static const String unexpectedError =
      'An unexpected error occurred. Please try again later.';
  static const String somethingWentWrong =
      'Something went wrong. Please try again later.';
  static const String error = 'Error';
  static const String wrongEmailOrPassword =
      'Wrong email or password. Please try again.';

  //! logging errors
  static const String emailUsedByUser =
      'This email is already in use. Try another email or login as a user.';
  static const String emailUsedByPlayer =
      'This email is already in use. Try another email or login as a player.';
  static const String verificationTimeout = 'Verification timeout';
  static const String noAuthenticationUser = 'No authenticated user found';
  static const String userNotFound = 'User not found';
  static const String userNotFoundMessage =
      'No user found with the provided email. Sign-up first!';

  //! match formats
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

  //! login and signup
  static const String email = 'Email';
  static const String password = 'Password';
  static const String username = 'Username';
  static const String forgetPassword = 'Forget Password?';
  static const String wantToSignup = 'Sign Up?';
  static const String wantToLogin = 'Login?';
  static const String resetPassword = 'Reset Password';
  static const String resendEmail = 'Resend Email';
  static const String resetEmailSent = 'Reset Email Sent';
  static const String logout = 'Logout';
  static const String login = 'Login';
  static const String signup = 'Sign Up';
  static const String enterEmail = 'Enter your email';
  static const String editEmail = 'Edit email';
  static const String selectCricketRole = 'Select Cricket Role';
  static const String selectBattingPosition = 'Select Batting Position';
  static const String selectBowlingStyle = 'Select Bowling Style';
  static const String selectBowlingArm = 'Select Bowling Arm';
  static const String loginAsPlayer = 'Login as Player';
  static const String signupAsPlayer = 'Signup as Player';
  static const String loginAsUser = 'Login as User';
  static const String signupAsUser = 'Signup as User';
  static const String playerName = 'Player Name';
  static String resetEmailSentMsg(String email) =>
      'Reset email link has been sent to ${email.trim()}. Please check your inbox!';
  static const String resetPasswordMessage =
      'Enter your registered email address. We\'ll send you a link to reset your password.';
  static const String backToLogin = 'Back to Login';
  static const String confirmExit = 'Confirm Exit';
  static const String confirmExitMessage =
      'Leaving now will cancel the verification process. Are you sure?';
  static const String authentication = 'Authentication';
  static const String sendEmail = 'Send Email';
  static const String verified = 'Verified';
  static const String resendVerificationEmail = 'Resend Verification Email';

  //! verification messages
  static const String waitForEmailVerification = 'Wait for email verification';
  static const String emailVerificationSuccessfully =
      'Verification email successfully!';
  static const String loginSuccessfully = 'Login successfully!';
  static const String emailVerificationFailed =
      'Email verification failed. Please try again.';

  //! Authentication roles
  static const String user = 'User';
  static const String player = 'Player';
  static const String userRole = 'user';
  static const String playerRole = 'player';

  //! success messages
  static const String success = 'success';

  //! FirebaseAuth & custom error code
  static const String emailAlreadyInUse = 'email-already-in-use';
  static const String emailUsedByUserCode = 'Email-is-already-in-use-as-user';
  static const String emailUsedByPlayerCode =
      'Email-is-already-in-use-as-player';
  static const String userNotFoundCode = 'user-not-found';
  static const String invalidCredentialCode = 'invalid-credential';
}
