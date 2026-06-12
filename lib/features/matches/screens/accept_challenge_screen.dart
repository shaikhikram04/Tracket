import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tracket/common/widgets/circular_loading_indicator.dart';
import 'package:tracket/common/widgets/custom_widgets/my_card.dart';
import 'package:tracket/common/widgets/custom_widgets/value_listenable_builder_3.dart';
import 'package:tracket/features/authentication/services/firebase_auth_methods.dart';
import 'package:tracket/features/matches/models/match_player_info.dart';
import 'package:tracket/features/matches/services/matches_services.dart';
import 'package:tracket/features/matches/widgets/captain_and_wicketkeeper_dropdown.dart';
import 'package:tracket/features/matches/widgets/match_squad.dart';
import 'package:tracket/features/matches/widgets/squad_selection_sheet.dart';
import 'package:tracket/features/matches/widgets/team_section.dart';
import 'package:tracket/features/notifications/models/challenge_match.dart';
import 'package:tracket/features/teams/models/team.dart';
import 'package:tracket/features/teams/services/teams_services.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/utility_classes/custom_button.dart';

class AcceptChallengeScreen extends StatefulWidget {
  const AcceptChallengeScreen({
    super.key,
    required this.challenge,
    required this.isSender,
    required this.challengeId,
    required this.onAccepted,
  });

  final ChallengeMatch challenge;
  final String challengeId;
  final bool isSender;
  final VoidCallback onAccepted;

  @override
  State<AcceptChallengeScreen> createState() => _AcceptChallengeScreenState();
}

class _AcceptChallengeScreenState extends State<AcceptChallengeScreen> {
  final _captainController = TextEditingController();
  final _wicketkeeperController = TextEditingController();

  bool _isLoading = false;
  bool _isAccepting = false;
  Team? _challengedTeam;
  late ChallengeMatch _challenge;

  final ValueNotifier<List<MatchPlayerInfo>> _challengedTeamPlayers =
      ValueNotifier([]);
  final ValueNotifier<List<MatchPlayerInfo>> _selectedPlayers =
      ValueNotifier([]);
  final ValueNotifier<String> _captainId = ValueNotifier('');
  final ValueNotifier<String> _wicketkeeperId = ValueNotifier('');

  @override
  void initState() {
    _loadSquad();
    _challenge = widget.challenge;
    super.initState();
  }

  // Improved error handling with dedicated error handler
  Future<void> _handleError(dynamic error) async {
    if (!mounted) return;
    THelperFunction.showSnackBar(error.toString(), context);
  }

  Future<void> _loadSquad() async {
    // Load challenger squad

    setState(() => _isLoading = true);

    try {
      final challengerTeamPlayers =
          await MatchesServices.getChallengeMatchTeamPlayers(
        challengeId: widget.challengeId,
        isChallenger: true,
      );

      if (!mounted) return;
      _challenge.setChallengerPlayers(challengerTeamPlayers);

      if (widget.isSender) {
        final challengedPlayers =
            await MatchesServices.getChallengeMatchTeamPlayers(
          challengeId: widget.challengeId,
          isChallenger: false,
        );

        if (!mounted) return;
        _challengedTeamPlayers.value = challengedPlayers;
      } else {
        if (!mounted) return;
        final teamId = widget.challenge.challengedTeam.teamId;
        final teamSnap = await TeamsServices.getTeamData(teamId);

        if (!mounted) return;
        final teamPlayers =
            await TeamsServices.getTeamPlayersFromId(teamId, context);

        _challengedTeam = Team.fromJson(teamSnap, teamPlayers, null);

        _challengedTeamPlayers.value =
            MatchPlayerInfo.fromPlayerDetailList(_challengedTeam!.playersList);
      }
    } catch (e) {
      _handleError(e);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _onAddPlayer() async {
    SquadSelectionSheet.show(
      context,
      playersList: _challengedTeamPlayers.value,
      noOfPlayersCanBeSelected: widget.challenge.noOfPlayers,
      onSubmit: (List<MatchPlayerInfo> selectedPlayers) {
        if (!mounted) return;
        _updatePlayerRoles(selectedPlayers);
        Navigator.of(context).pop();
      },
    );
  }

  void _updatePlayerRoles(List<MatchPlayerInfo> players) {
    if (players.isEmpty) return;

    final captain = _captainController.text;
    final wicketkeeper = _wicketkeeperController.text;

    _selectedPlayers.value = players.map((player) {
      if (captain.isEmpty && player.playerId == _challengedTeam?.captainId) {
        _captainController.text = player.playerName.toUpperCase();
        _captainId.value = player.playerId;
      }
      if (wicketkeeper.isEmpty &&
          player.playerId == _challengedTeam?.wicketkeeperId) {
        _wicketkeeperController.text = player.playerName.toUpperCase();
        _wicketkeeperId.value = player.playerId;
      }
      return player;
    }).toList();
  }

  String? _validateChallenge() {
    if (_selectedPlayers.value.isEmpty) {
      return 'Please select squad';
    }
    if (_captainId.value.isEmpty) {
      return 'Please select team captain';
    }
    if (_wicketkeeperId.value.isEmpty) {
      return 'Please select team wicketkeeper';
    }
    return null;
  }

  Future<void> _acceptChallenge() async {
    final validationError = _validateChallenge();
    if (validationError != null) {
      THelperFunction.showSnackBar(validationError, context);
      return;
    }

    if (!mounted) return;

    setState(() {
      _isAccepting = true;
    });

    try {
      _challenge.setChallengedPlayers(_selectedPlayers.value);
      _challenge.updateTeamDetails(
        captainId: _captainId.value,
        wicketkeeperId: _wicketkeeperId.value,
      );

      await MatchesServices.acceptChallenge(
        challenge: _challenge,
        challengeId: widget.challengeId,
        context: context,
        acceptedBy: FirebaseAuthMethods().currentUserId,
      );
      widget.onAccepted();

      // Store this in a variable to show after navigation
      const successMessage = 'Challenge Accepted';

      if (!mounted) return;

      Navigator.of(context).pop();

      // We're using a slight delay to ensure the snackbar appears in the parent screen
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          THelperFunction.showSnackBar(successMessage, context);
        }
      });
    } catch (e) {
      _handleError(e);
    } finally {
      if (mounted) {
        // Check if widget is still mounted before setState
        setState(() {
          _isAccepting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _captainController.dispose();
    _wicketkeeperController.dispose();
    _challengedTeamPlayers.dispose();
    _selectedPlayers.dispose();
    _captainId.dispose();
    _wicketkeeperId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Challenge  '),
      ),
      body: _isLoading
          ? const CircularLoadingIndicator()
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildTeamsSection(),
                  _buildMatchDetailsSection(),
                  _buildSquadSections(),
                  _buildRolesSection(),
                  if (!widget.isSender) _buildActionButtons(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildMatchDetailsSection() {
    final details = [
      ['No of players', widget.challenge.noOfPlayers.toString()],
      ['Match Format', widget.challenge.overs.name],
      ['Match type', widget.challenge.matchType.name],
      ['Spectator', widget.challenge.allowSpectator ? 'Allow' : 'Not allow'],
      ['Date', DateFormat.yMMMd().format(widget.challenge.schedule)],
      ['Time', DateFormat.Hms().format(widget.challenge.schedule)],
      ['Venue', widget.challenge.venue],
    ];

    return MyCard(
      child: Column(
        children: [
          THelperFunction.getTitleText('Match Details', context),
          const SizedBox(height: 8),
          ...details
              .map((detail) => _matchDetailRow(detail[0], detail[1], context)),
        ],
      ),
    );
  }

  Widget _buildSquadSections() {
    return Column(
      children: [
        MyCard(
          child: ValueListenableBuilder<List<MatchPlayerInfo>>(
            valueListenable: _selectedPlayers,
            builder: (context, players, _) => MatchSquad(
              players: _challenge.challengerPlayers,
              captainId: _challenge.challengerTeam.captainId,
              wicketkeeperId: _challenge.challengerTeam.wicketkeeperId,
              title: widget.isSender ? 'Your Squad' : 'Challenger Squad',
            ),
          ),
        ),
        MyCard(
          child: ValueListenableBuilder3<List<MatchPlayerInfo>, String, String>(
            first: _selectedPlayers,
            second: _captainId,
            third: _wicketkeeperId,
            builder: (context, players, captainId, wicketkeeperId, _) =>
                MatchSquad(
              players: players,
              captainId: _captainId.value,
              wicketkeeperId: _wicketkeeperId.value,
              isPlayerCanAdd: !widget.isSender,
              onAddPlayer: _onAddPlayer,
              title: widget.isSender ? 'Opponent Squad' : 'Your Squad',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeamsSection() {
    return TeamSection(
      team1Name: widget.challenge.challengerTeam.teamName,
      team1Logo: widget.challenge.challengerTeam.logoUrl,
      team2Name: widget.challenge.challengedTeam.teamName,
      team2Logo: widget.challenge.challengedTeam.logoUrl,
    );
  }

  Widget _buildRolesSection() {
    return ValueListenableBuilder<List<MatchPlayerInfo>>(
      valueListenable: _selectedPlayers,
      builder: (context, players, _) {
        final playersName =
            players.map((player) => player.playerName.toUpperCase()).toList();
        return CaptainAndWicketkeeperDropdown(
          playersName: playersName,
          captainController: _captainController,
          selectedPlayers: _selectedPlayers,
          wicketkeeperController: _wicketkeeperController,
          onSelectCaptain: (String? name) {
            if (name == null) return;
            final index = playersName.indexOf(name);
            if (index >= 0 && index < players.length) {
              _captainId.value = players[index].playerId;
              _captainController.text = name;
            }
          },
          onSelectWicketkeeper: (String? name) {
            if (name == null) return;
            final index = playersName.indexOf(name);
            if (index >= 0 && index < players.length) {
              _wicketkeeperId.value = players[index].playerId;
              _wicketkeeperController.text = name;
            }
          },
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: CustomButton.secondary(
              height: 45,
              onPressed: () => Navigator.of(context).pop(),
              text: 'Reject',
              backgroundColor: LightThemeColors.backgroundColor,
              textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: StatusColors.error,
                  ),
              borderColor: StatusColors.error,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: CustomButton.primary(
              height: 45,
              onPressed: _acceptChallenge,
              text: 'Accept',
              backgroundColor: const Color.fromARGB(255, 43, 114, 45),
              isLoading: _isAccepting,
              textStyle: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  Widget _matchDetailRow(String title, String value, BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          const Text('   :   '),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isDark ? lightGrassGreen : darkGrassGreen,
                  ),
            ),
          )
        ],
      ),
    );
  }
}
