import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/services/matches_services.dart';
import 'package:tracket/matches/widgets/match_squad.dart';
import 'package:tracket/matches/widgets/players_selection_dialog.dart';
import 'package:tracket/matches/widgets/team_column.dart';
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
  bool _isLoading = false;
  List<MatchPlayerInfo> _challengedTeamPlayers = [];
  List<MatchPlayerInfo> _selectedPlayers = [];
  late TextEditingController _captainController;
  late TextEditingController _wicketkeeperController;
  Team? _challengedTeam;
  late ChallengeMatch _challenge;
  String _captainId = '';
  String _wicketkeeperId = '';

  @override
  void initState() {
    _loadSquad();
    _captainController = TextEditingController();
    _wicketkeeperController = TextEditingController();
    _challenge = widget.challenge;
    super.initState();
  }

  Future<void> _loadSquad() async {
    // Load challenger squad
    setState(() {
      _isLoading = true;
    });

    try {
      final challengerTeamPlayers =
          await MatchesServices.getChallengeMatchTeamPlayers(
              challengeId: widget.challengeId, isChallenger: true);

      _challenge.setChallengerPlayers(challengerTeamPlayers);

      if (widget.isSender) {
        _challengedTeamPlayers =
            await MatchesServices.getChallengeMatchTeamPlayers(
                challengeId: widget.challengeId, isChallenger: false);
      } else {
        if (!mounted) return;
        final teamId = widget.challenge.challengedTeam.teamId;
        final teamSnap = await TeamsServices.getTeamData(teamId);
        if (!mounted) return;
        final teamPlayers =
            await TeamsServices.getTeamPlayersFromId(teamId, context);

        _challengedTeam = Team.formSeed(teamSnap, teamPlayers);

        _challengedTeamPlayers =
            MatchPlayerInfo.fromPlayerDetailList(_challengedTeam!.playersList);
      }
    } catch (e) {
      if (!mounted) return;
      showSnackBar(e.toString(), context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  List<String> get _playersName {
    List<String> playerNames = [];
    for (var player in _selectedPlayers) {
      playerNames.add(player.playerName.toUpperCase());
    }

    return playerNames;
  }

  Future<void> onAddPlayer() async {
    final result = await showDialog<List<MatchPlayerInfo>>(
      context: context,
      builder: (context) => PlayersSelectionDialog(
        playerList: _challengedTeamPlayers,
        selectedPlayers: _selectedPlayers,
        noOfPlayerCanBeSelected: widget.challenge.noOfPlayers,
      ),
    );

    if (result != null) {
      final captain = _captainController.text;
      final wicketkeeper = _wicketkeeperController.text;

      setState(() {
        _selectedPlayers = result.map((player) {
          if (captain.isEmpty &&
              player.playerId == _challengedTeam!.captainId) {
            _captainController.text = player.playerName.toUpperCase();
            _captainId = player.playerId;
          }
          if (wicketkeeper.isEmpty &&
              player.playerId == _challengedTeam!.wicketkeeperId) {
            _wicketkeeperController.text = player.playerName.toUpperCase();
            _wicketkeeperId = player.playerId;
          }
          return player.copyWith();
        }).toList();
      });
    }
  }

  Future<void> _acceptChallenge() async {
    if (_selectedPlayers.isEmpty) {
      showSnackBar('Please select squad', context);
      return;
    }
    if (_captainId.isEmpty) {
      showSnackBar('Please select team captain', context);
      return;
    }
    if (_wicketkeeperId.isEmpty) {
      showSnackBar('Please select team wicketkeeper', context);
      return;
    }
    _challenge.setChallengedPlayers(_selectedPlayers);
    _challenge.setCaptainAndWicketkeeper(_captainId, _wicketkeeperId);

    try {
      await MatchesServices.acceptChallenge(
        challenge: _challenge,
        challengeId: widget.challengeId,
        context: context,
      );
    } catch (e) {
      if (!mounted) return;
      showSnackBar(e.toString(), context);
    }
  }

  @override
  void dispose() {
    _captainController.dispose();
    _wicketkeeperController.dispose();
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
                  //! Team Detail
                  MyCard(
                    child: Column(
                      children: [
                        getTitleText('Teams', context),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          spacing: 8,
                          children: [
                            TeamColumn(
                              teamName:
                                  widget.challenge.challengerTeam.teamName,
                              teamLogo: widget.challenge.challengerTeam.logoUrl,
                            ),
                            Text(
                              'v/s',
                              style: MyTextStyle(context).boldBodyLarge,
                            ),
                            TeamColumn(
                              teamName:
                                  widget.challenge.challengedTeam.teamName,
                              teamLogo: widget.challenge.challengedTeam.logoUrl,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //! Match detail
                  MyCard(
                    child: Column(
                      spacing: 20,
                      children: [
                        getTitleText('Match Details', context),
                        Column(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            matchDetailRow(
                              'No of players',
                              widget.challenge.noOfPlayers.toString(),
                              context,
                            ),
                            matchDetailRow(
                              'Match Format',
                              widget.challenge.overs.name,
                              context,
                            ),
                            matchDetailRow(
                              'Match type',
                              widget.challenge.matchType.name,
                              context,
                            ),
                            matchDetailRow(
                              'Spectator',
                              widget.challenge.allowSpectator
                                  ? 'Allow'
                                  : 'Not allow',
                              context,
                            ),
                            matchDetailRow(
                              'Date',
                              DateFormat.yMMMd()
                                  .format(widget.challenge.schedule),
                              context,
                            ),
                            matchDetailRow(
                              'Time',
                              DateFormat.Hms()
                                  .format(widget.challenge.schedule),
                              context,
                            ),
                            matchDetailRow(
                                'Venue', widget.challenge.venue, context),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //! Challenger Team Squad
                  MyCard(
                    child: MatchSquad(
                      selectedPlayer: _challenge.challengerPlayers,
                      captainId: _captainId,
                      wicketkeeperId: _wicketkeeperId,
                      isPlayerCanAdd: false,
                      title:
                          widget.isSender ? 'Your Squad' : 'Challenger Squad',
                    ),
                  ),
                  //! Challenged Team Squad
                  MyCard(
                    child: MatchSquad(
                      selectedPlayer: _selectedPlayers,
                      captainId: _captainId,
                      wicketkeeperId: _wicketkeeperId,
                      isPlayerCanAdd: !widget.isSender,
                      onAdd: onAddPlayer,
                      title: widget.isSender ? 'Opponent Squad' : 'Your Squad',
                    ),
                  ),
                  //! Role Selection
                  MyCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 12,
                      children: [
                        getTitleText('Roles', context),
                        //! Captain, Wicketkeeper
                        MyDropdownMenu(
                          options: _playersName,
                          label: 'Change Captaincy',
                          controller: _captainController,
                          onSelect: (value) {
                            setState(() {
                              int index = _playersName
                                  .indexWhere((name) => name == value);

                              _captainId = _selectedPlayers[index].playerId;
                            });
                          },
                        ),
                        MyDropdownMenu(
                          options: _playersName,
                          label: 'Change Wicketkeeper',
                          controller: _wicketkeeperController,
                          onSelect: (value) {
                            setState(() {
                              int index = _playersName
                                  .indexWhere((name) => name == value);

                              _wicketkeeperId =
                                  _selectedPlayers[index].playerId;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  //! Action Buttons
                  if (!widget.isSender)
                    Row(
                      spacing: 20,
                      children: [
                        const SizedBox(),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: MyElevatedButton.secondaryElevatedButton(
                              context,
                              text: 'Reject',
                              fontSize: 16,
                              onPressed: () {},
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: MyElevatedButton.primaryElevatedButton(
                              context,
                              onPressed: () {},
                              fontSize: 16,
                              text: 'Accept',
                              primaryColor:
                                  const Color.fromARGB(255, 43, 114, 45),
                            ),
                          ),
                        ),
                        const SizedBox(),
                      ],
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget matchDetailRow(String title, String value, BuildContext context) {
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
