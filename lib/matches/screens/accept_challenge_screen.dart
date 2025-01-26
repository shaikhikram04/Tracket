import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tracket/matches/services/matches_services.dart';
import 'package:tracket/matches/widgets/match_squad.dart';
import 'package:tracket/matches/widgets/players_selection_dialog.dart';
import 'package:tracket/matches/widgets/team_column.dart';
import 'package:tracket/notifications/models/challenge_match.dart';
import 'package:tracket/players/models/player_details.dart';
import 'package:tracket/teams/models/team.dart';
import 'package:tracket/teams/services/teams_services.dart';
import 'package:tracket/utils/utility_classes/my_elevated_button.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_card.dart';

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
  List<PlayerDetails> _challengerTeamPlayers = [];
  List<PlayerDetails> _challengedTeamPlayers = [];
  List<PlayerDetails> _selectedPlayers = [];
  late TextEditingController _captainController;
  late TextEditingController _wicketkeeperController;
  Team? _challengedTeam;
  String _captainId = '';
  String _wicketkeeperId = '';

  @override
  void initState() {
    _loadSquad();
    _captainController = TextEditingController();
    _wicketkeeperController = TextEditingController();
    super.initState();
  }

  Future<void> _loadSquad() async {
    // Load challenger squad
    setState(() {
      _isLoading = true;
    });

    try {
      _challengerTeamPlayers =
          await MatchesServices.getChallengeMatchTeamPlayers(
              challengeId: widget.challengeId, isChallenger: true);

      if (widget.isSender) {
        _challengedTeamPlayers =
            await MatchesServices.getChallengeMatchTeamPlayers(
                challengeId: widget.challengeId, isChallenger: false);
      } else {
        if (!mounted) return;
        final teamId = widget.challenge.challengedTeam.id;
        final teamSnap = await TeamsServices.getTeamData(teamId);
        final teamPlayers =
            await TeamsServices.getTeamPlayersFromId(teamId, context);

        _challengedTeam = Team.formSeed(teamSnap, teamPlayers);
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
      playerNames.add(player.name);
    }

    return playerNames;
  }

  Future<void> onAddPlayer() async {
    final result = await showDialog<List<PlayerDetails>>(
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
          if (captain.isEmpty && player.id == _challengedTeam!.captainId) {
            _captainController.text = player.name.toUpperCase();
            _captainId = player.id;
          }
          if (wicketkeeper.isEmpty &&
              player.id == _challengedTeam!.wicketkeeperId) {
            _wicketkeeperController.text = player.name.toUpperCase();
            _wicketkeeperId = player.id;
          } 
          return player.copyWith();
        }).toList();
      });
    }
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
                              teamName: widget.challenge.challengerTeam.name,
                              teamLogo: widget.challenge.challengerTeam.logoUrl,
                            ),
                            Text(
                              'v/s',
                              style: MyTextStyle(context).boldBodyLarge,
                            ),
                            TeamColumn(
                              teamName: widget.challenge.challengedTeam.name,
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
                  MyCard(
                    child: MatchSquad(
                      selectedPlayer: _challengerTeamPlayers,
                      captainId: '',
                      wicketkeeperId: '',
                      isPlayerCanAdd: false,
                      title:
                          widget.isSender ? 'Your Squad' : 'Challenger Squad',
                    ),
                  ),
                  MyCard(
                    child: MatchSquad(
                      selectedPlayer: widget.isSender
                          ? _challengedTeamPlayers
                          : _selectedPlayers,
                      captainId: '',
                      wicketkeeperId: '',
                      isPlayerCanAdd: !widget.isSender,
                      onAdd: onAddPlayer,
                      title: widget.isSender ? 'Opponent Squad' : 'Your Squad',
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (!widget.isSender)
                    Row(
                      spacing: 20,
                      children: [
                        const SizedBox(),
                        Expanded(
                          child: MyElevatedButton.secondaryElevatedButton(
                            context,
                            text: 'Reject',
                            onPressed: () {},
                          ),
                        ),
                        Expanded(
                          child: MyElevatedButton.primaryElevatedButton(
                            context,
                            onPressed: () {},
                            text: 'Accept',
                            primaryColor:
                                const Color.fromARGB(255, 43, 114, 45),
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
