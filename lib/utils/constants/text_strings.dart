import 'package:tracket/features/teams/utils/team_constants.dart';

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
  static const String gotItButton = 'Got it';
  static const String retryButton = 'Retry';
  static const String changeLogo = 'Change Logo';
  static const String discardButton = 'Discard';
  static const String saveChangesButton = 'Save Changes';
  static const String deleteButton = 'Delete';
  static const String cancelButton = 'Cancel';
  static const String removeButton = 'Remove';
  static const String closeButton = 'Close';

  static const String joinTeam = 'Join Team';
  static const String createTeam = 'Create Team';
  static const String exploreTeams = 'Explore Teams';

  static const String followButton = 'Follow';
  static const String unfollowButton = 'Unfollow';
  static const String challengeButton = 'Challenge';

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
  static const String loadingPlayerDataError = 'Error on loading player data :';
  static const String failedToPickImage = 'Failed to pick image:';
  static const String failedToUploadLogo = 'Failed to upload logo:';

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
  static const String teamCreated = 'Team created successfully!';
  static const String teamUpdated = 'Team updated successfully!';

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
  static const String searchPlayers = 'Search players...';
  static const String searchTeams = 'Search teams...';
  static const String addPlayer = 'Add Player';
  static const String teamInfo = 'Team Information';
  static const String teamName = 'Team Name';
  static const String teamShortName = 'Team Short Name';
  static const String teamDescription = 'Team Description';
  static const String teamDetails = 'Team Details';
  static const String privateTeam = 'Private Team';
  static const String privateTeams = 'Private Teams';
  static const String privateTeamMessage =
      'Only invited players can join this team.';
  static const String advancedSettings = 'Advanced Settings';
  static const String maxTeamCapacity = 'Max Team Capacity';
  static const String exploreTeam = 'Explore Teams';
  static const String followers = 'Followers';
  static const String ranking = 'Ranking';
  static const String achievements = 'Achievements';
  static const String followersKey = 'followers';
  static const String challenged = 'Challenged';
  static const String hasCapacity = 'Has Capacity';
  static const String full = 'Full';
  static const String teamLogo = 'Team Logo';
  static const String teamLogoMessage = 'Upload a Team Logo here.';
  static const String discardChanges = 'Discard Changes?';
  static const String discardChangesMessage =
      'You have unsaved changes. Are you sure you want to discard them?';
  static const String editTeam = 'Edit Team';
  static const String editTeamDetails = 'Edit Team Details';
  static const String editTeamDetailsDescription =
      'Modify team information and preferences.';
  static const String primaryInformation = 'Primary Information';
  static const String teamCapacity = 'Team Capacity';
  static const String teamRoles = 'Team Roles';
  static const String teamCaptain = 'Team Captain';
  static const String teamWicketkeeper = 'Wicketkeeper';
  static const String teamStatistics = 'Team Statistics';
  static const String wins = 'Wins';
  static const String losses = 'Losses';
  static const String ties = 'Ties';
  static const String makeTeamPrivate = 'Make Team Private';
  static const String makeTeamPrivateDescription =
      'When your team is private, only admins can add new members.';
  static const String makeTeamPrivateMessage =
      'Team is now private. New members require approval.';
  static const String makeTeamPublicMessage =
      'Team is now public. Anyone can join without approval.';
  static const String teamSettings = 'Team Settings';
  static const String teamSettingsDescription =
      'Manage team configuration and permissions.';
  static const String teamAdministrators = 'Team Administrators';
  static const String requestAndChallengeManagement =
      'Request and Challenge Management';
  static const String requests = 'Requests';
  static const String challenges = 'Challenges';
  static const String privacySettings = 'Privacy Settings';
  static const String dangerZone = 'Danger Zone';
  static const String deleteTeam = 'Delete Team';
  static const String deleteTeamDescription = 'This action cannot be undone.';
  static const String removeAdmin = 'Remove Admin';
  static const String deleteTeamMessage =
      'This action cannot be undone. All team data, including matches and statistics, will be permanently deleted.';

  static const String private = 'Private';
  static const String public = 'Public';

  //! -------------------- Team Error --------------------
  static const String failedToUpdateTeam = 'Failed to update team :';
  static const String failedToUpdateTeamMessage =
      'Failed to update team. Please try again later.';
  static const String failedToUpdateTeamField = 'Failed to update team field :';
  static const String teamPlayerNotFound = 'Player not found in team';
  static const String failedToDeletePlayer = 'Failed to delete player:';
  static const String failedToDeletePlayerMessage =
      'Failed to delete player. Please try again later.';
  static const String teamHasReachedMaxCapacity =
      'Team has reached maximum capacity';
  static const String playerAlreadyInTeam = 'Player already exists in team';
  static const String failedToAddPlayer = 'Failed to add player:';
  static const String failedToAddPlayerMessage =
      'Failed to add player. Please try again later.';
  static const String failedToUpdatePlayerRole =
      'Failed to update player role:';
  static const String capacityCannotBeReduce =
      'Team capacity cannot be reduce below current team size';
  static const String capacityCannotBeLessThanOne =
      'Team capacity cannot be less than 1';
  static const String failedToUpdateTeamCapacity =
      'Failed to update team capacity:';
  static const String failedToUpdateTeamPrivacyMessage =
      'Failed to update team privacy. Please try again later.';
  static const String failedToLoadPlayers =
      'Failed to load players. Please try again.';
  static const String noPlayersFoundMatchingSearch =
      'No players found matching your search';
  static const String noPlayersFound = 'No players found';
  static const String noPlayersFoundMessage =
      'No players found in the team. Please add players to the team.';
  static const String failedToCreateTeam = 'Failed to create team:';
  static const String noTeamAvailable = 'No Teams Available';
  static const String noTeamAvailableMessage = 'Be the first to create a team!';
  static const String noTeamAvailableJoinMessage =
      'All teams are already joined or no teams exist yet.';
  static const String noTeamFoundMatchingSearch = 'No teams found, matching';
  static const String noTeamFoundMatchingSearch2 =
      'No teams found matching your criteria.';
  static const String maxTeamCapacityReached =
      'Maximum team capacity is ${TeamConstants.maxTeamSize} players.';
  static const String minTeamCapacityReached =
      'Minimum team capacity is ${TeamConstants.minTeamSize} players.';
  static const String unableToFetchTeamData =
      'Unable to fetch team data. Please try again later.';
  static const String failedToDeleteTeamMessage =
      'Failed to delete team. Please try again later.';
  static const String teamOptions = 'Team Options';

  //! -------------------- Team Role --------------------
  static const String owner = 'owner';
  static const String admin = 'admin';

  //! -------------------- Admin --------------------
  static const String addAdmin = 'Add Admin';
  static const String addAdminMessage =
      'Select players to grant admin privileges';
  static const String noAvailablePlayers =
      'No available players to add as admin';
  static const String noAvailablePlayersMessage =
      'All players are already administrators';
  static const String adminPrivileges = 'Admin Privileges';

  static const String manageTeamSettings = 'Manage team settings and details';
  static const String manageTeamMembers = 'Add or remove team members';
  static const String manageTeamMatches =
      'Create and Manage team matches and schedules';

  //! -------------------- Challenge Match --------------------
  static const String selectTeam = 'Select a Team';

  //! -------------------- Challenge Match Error --------------------
  static const String alreadyChallenged = 'Already Challenged';
  static const String alreadyChallengedDesc =
      'This team has already challenged the current team.';

  //! -------------------- Matches --------------------
  static const String noResult = 'No Result';
  static const String matchTied = 'Match Tied';
  static const String runs = 'runs';
  static const String wickets = 'wickets';

  //! -------------------- Match Error --------------------
  static const String cantAddMaidenOver =
      'Cannot add maiden over: current over is incomplete';
  static const String inValidDeliveryParameter =
      'Invalid delivery parameter.';
  static const String tossNotDone =
      'Toss details must be set before initializing innings';
  static const String inningsNotStarted =
      'First innings must be completed before starting second innings';

  //! -------------------- Tournaments --------------------
  static const String noTournaments = 'No Tournaments Scheduled';
  static const String noTournamentsMessage =
      'Please check back later for updates.';

  
}
