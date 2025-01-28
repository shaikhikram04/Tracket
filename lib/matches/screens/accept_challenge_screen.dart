import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/services/matches_services.dart';
import 'package:tracket/matches/widgets/match_squad.dart';
import 'package:tracket/matches/widgets/players_selection_dialog.dart';
import 'package:tracket/matches/widgets/team_section.dart';
import 'package:tracket/notifications/models/challenge_match.dart';
import 'package:tracket/teams/models/team.dart';
import 'package:tracket/teams/services/teams_services.dart';
import 'package:tracket/utils/utility_classes/my_elevated_button.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_card.dart';
import 'package:tracket/widgets/custom_widgets/my_dropdown_menu.dart';

class AcceptChallengeScreen extends StatefulWidget {
  const AcceptChallengeScreen({
    super.key,
    required this.challenge,
    required this.isSender,
    required this.challengeId,
  });

  final ChallengeMatch challenge;
  final String challengeId;
  final bool isSender;

  @override
  State<AcceptChallengeScreen> createState() => _AcceptChallengeScreenState();
}

class _AcceptChallengeScreenState extends State<AcceptChallengeScreen> {
  final _captainController = TextEditingController();
  final _wicketkeeperController = TextEditingController();

  bool _isLoading = false;
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
    showSnackBar(error.toString(), context);
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

      _challenge.setChallengerPlayers(challengerTeamPlayers);

      if (widget.isSender) {
        _challengedTeamPlayers.value =
            await MatchesServices.getChallengeMatchTeamPlayers(
          challengeId: widget.challengeId,
          isChallenger: false,
        );
      } else {
        if (!mounted) return;
        final teamId = widget.challenge.challengedTeam.teamId;
        final teamSnap = await TeamsServices.getTeamData(teamId);

        if (!mounted) return;
        final teamPlayers =
            await TeamsServices.getTeamPlayersFromId(teamId, context);

        _challengedTeam = Team.formSeed(teamSnap, teamPlayers);

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

  List<String> get _playersName => _selectedPlayers.value
      .map((player) => player.playerName.toUpperCase())
      .toList();

  Future<void> onAddPlayer() async {
    final result = await showDialog<List<MatchPlayerInfo>>(
      context: context,
      builder: (context) => PlayersSelectionDialog(
        playerList: _challengedTeamPlayers.value,
        selectedPlayers: _selectedPlayers.value,
        noOfPlayerCanBeSelected: widget.challenge.noOfPlayers,
      ),
    );

    if (result != null) {
      _updatePlayerRoles(result);
    }
  }

  void _updatePlayerRoles(List<MatchPlayerInfo> players) {
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
      return player.copyWith();
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
      showSnackBar(validationError, context);
      return;
    }

    try {
      _challenge.setChallengedPlayers(_selectedPlayers.value);
      _challenge.setCaptainAndWicketkeeper(
        _captainId.value,
        _wicketkeeperId.value,
      );

      await MatchesServices.acceptChallenge(
        challenge: _challenge,
        challengeId: widget.challengeId,
        context: context,
      );

      if (!mounted) return;
      Navigator.of(context).pop();
      showSnackBar('Challenge Accepted', context);
    } catch (e) {
      _handleError(e);
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
          ? getCircleLoadingIndicator()
          : SingleChildScrollView(
              child: Column(
                children: [
                  TeamSection(
                    team1Name: widget.challenge.challengerTeam.teamName,
                    team1Logo: widget.challenge.challengerTeam.logoUrl,
                    team2Name: widget.challenge.challengedTeam.teamName,
                    team2Logo: widget.challenge.challengedTeam.logoUrl,
                  ),
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
          getTitleText('Match Details', context),
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
              selectedPlayer: _challenge.challengerPlayers,
              captainId: _captainId.value,
              wicketkeeperId: _wicketkeeperId.value,
              isPlayerCanAdd: false,
              title: widget.isSender ? 'Your Squad' : 'Challenger Squad',
            ),
          ),
        ),
        MyCard(
          child: ValueListenableBuilder<List<MatchPlayerInfo>>(
            valueListenable: _selectedPlayers,
            builder: (context, players, _) => MatchSquad(
              selectedPlayer: players,
              captainId: _captainId.value,
              wicketkeeperId: _wicketkeeperId.value,
              isPlayerCanAdd: !widget.isSender,
              onAdd: onAddPlayer,
              title: widget.isSender ? 'Opponent Squad' : 'Your Squad',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRolesSection() {
    return MyCard(
      child: Column(
        children: [
          getTitleText('Roles', context),
          MyDropdownMenu(
            options: _playersName,
            label: 'Change Captaincy',
            controller: _captainController,
            onSelect: (value) {
              if (value != null) {
                final index = _playersName.indexOf(value);
                _captainId.value = _selectedPlayers.value[index].playerId;
              }
            },
          ),
          const SizedBox(height: 12),
          MyDropdownMenu(
            options: _playersName,
            label: 'Change Wicketkeeper',
            controller: _wicketkeeperController,
            onSelect: (value) {
              if (value != null) {
                final index = _playersName.indexOf(value);
                _wicketkeeperId.value = _selectedPlayers.value[index].playerId;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: MyElevatedButton.secondaryElevatedButton(
                context,
                text: 'Reject',
                fontSize: 16,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: SizedBox(
              height: 50,
              child: MyElevatedButton.primaryElevatedButton(
                context,
                onPressed: _acceptChallenge,
                fontSize: 16,
                text: 'Accept',
                primaryColor: const Color.fromARGB(255, 43, 114, 45),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _matchDetailRow(String title, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: MyTextStyle(context).boldBodyLarge,
            ),
          ),
          const Text('   :   '),
          Expanded(
            child: Text(
              value,
              style: MyTextStyle(context)
                  .boldBodyLarge
                  .copyWith(color: const Color.fromARGB(255, 50, 124, 53)),
            ),
          )
        ],
      ),
    );
  }
}
