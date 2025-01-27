import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/models/match_team_info.dart';
import 'package:tracket/matches/services/matches_services.dart';
import 'package:tracket/matches/widgets/match_squad.dart';
import 'package:tracket/matches/widgets/players_selection_dialog.dart';
import 'package:tracket/matches/widgets/team_column.dart';
import 'package:tracket/teams/models/team.dart';
import 'package:tracket/teams/services/teams_services.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_elevated_button.dart';
import 'package:tracket/utils/utility_classes/validation_services.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_card.dart';
import 'package:tracket/widgets/custom_widgets/my_dropdown_menu.dart';
import 'package:tracket/widgets/custom_widgets/my_text_field.dart';

class ChallengeMatchScreen extends StatefulWidget {
  const ChallengeMatchScreen({
    super.key,
    required this.challengerId,
    required this.challengerName,
    required this.challengerTeamId,
    required this.challengedTeam,
  });

  final String challengerId;
  final String challengerName;
  final String challengerTeamId;
  final MatchTeamInfo challengedTeam;

  @override
  State<ChallengeMatchScreen> createState() => _CreateMatchScreenState();
}

extension TimeOfDayToString on TimeOfDay {
  String formatToString() {
    final hourString = hour.toString().padLeft(2, '0');
    final minuteString = minute.toString().padLeft(2, '0');
    return '$hourString:$minuteString';
  }
}

class _CreateMatchScreenState extends State<ChallengeMatchScreen> {
  double _noOfPlayers = 7;
  bool _allowSpectators = true;
  DateTime _matchDate = DateTime.now();
  TimeOfDay _matchTime = TimeOfDay.now();
  String? _venue;
  bool _isLoading = false;
  List<MatchPlayerInfo> _selectedPlayer = [];
  String? _matchType;
  String? _matchFormat;
  late Team _challengerTeam;
  final _formKey = GlobalKey<FormState>();
  bool _isChallenging = false;
  String _captainId = '';
  String _wicketkeeperId = '';
  late TextEditingController _captainController;
  late TextEditingController _wicketkeeperController;

  final matchFormatOptions = matchFormatToString();
  final matchTypeOptions = enumToString(MatchType.values);

  @override
  void initState() {
    _loadTeamData();
    _captainController = TextEditingController();
    _wicketkeeperController = TextEditingController();
    super.initState();
  }

  List<String> get _playerNames {
    List<String> playerNames = [];
    for (var player in _selectedPlayer) {
      playerNames.add(player.playerName.toUpperCase());
    }

    return playerNames;
  }

  Future<void> _loadTeamData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final teamData = await TeamsServices.getTeamData(widget.challengerTeamId);

      if (!mounted) return;

      final teamPlayers = await TeamsServices.getTeamPlayersFromId(
          widget.challengerTeamId, context);

      _challengerTeam = Team.formSeed(teamData, teamPlayers);
    } catch (e) {
      if (!mounted) return;
      showSnackBar(e.toString(), context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> onAddPlayer() async {
    final result = await showDialog<List<MatchPlayerInfo>>(
      context: context,
      builder: (context) => PlayersSelectionDialog(
        playerList: _challengerTeam.playersList
            .map(
              (player) => MatchPlayerInfo(
                playerId: player.id,
                cricketRole: player.cricketRole,
                playerName: player.name,
                profileImageUrl: player.imageUrl,
              ),
            )
            .toList(),
        selectedPlayers: _selectedPlayer,
        noOfPlayerCanBeSelected: _noOfPlayers.toInt(),
      ),
    );

    if (result != null) {
      final captain = _captainController.text;
      final wicketkeeper = _wicketkeeperController.text;

      setState(() {
        _selectedPlayer = result.map((player) {
          if (captain.isEmpty && player.playerId == _challengerTeam.captainId) {
            _captainController.text = player.playerName.toUpperCase();
            _captainId = player.playerId;
          }
          if (wicketkeeper.isEmpty &&
              player.playerId == _challengerTeam.wicketkeeperId) {
            _wicketkeeperController.text = player.playerName.toUpperCase();
            _wicketkeeperId = player.playerId;
          }
          return player.copyWith();
        }).toList();
      });
    }
  }

  Future<void> _challengeMatch() async {
    if (_matchFormat == null || _matchType == null) {
      showSnackBar('Please fill all details', context);
      return;
    }
    if (_selectedPlayer.isEmpty) {
      showSnackBar('Please select player for match', context);
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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isChallenging = true;
    });

    _formKey.currentState!.save();

    final matchFormatIndex = matchFormatOptions.indexOf(_matchFormat!);

    final challengerTeamDetail = MatchTeamInfo(
      teamId: _challengerTeam.id,
      logoUrl: _challengerTeam.logoUrl,
      teamName: _challengerTeam.name,
      shortName: _challengerTeam.shortName,
      captainId: _captainId,
      wicketkeeperId: _wicketkeeperId,
    );

    try {
      await MatchesServices.challegeForAMatch(
        matchFormatIndex: matchFormatIndex,
        challengerTeam: challengerTeamDetail,
        challengedTeam: widget.challengedTeam,
        matchDate: _matchDate,
        matchTime: _matchTime,
        matchVenue: _venue!,
        challengerId: widget.challengerId,
        challengerName: widget.challengerName,
        allowSpectators: _allowSpectators,
        noOfPlayers: _noOfPlayers.toInt(),
        challengerPlayers: _selectedPlayer,
        matchType: _matchType!,
      );

      if (mounted) {
        showSnackBar('Challenged successfully!', context);
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(
            'failed to challenge, please try again. ${e.toString()}', context);
      }
    } finally {
      setState(() {
        _isChallenging = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenge Match'),
      ),
      body: _isLoading
          ? getCircleLoadingIndicator()
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    //! Team Detail
                    MyCard(
                        child: Column(
                      children: [
                        getTitleText('Teams', context),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TeamColumn(
                              teamName: _challengerTeam.name,
                              teamLogo: _challengerTeam.logoUrl,
                            ),
                            const Text('v/s'),
                            TeamColumn(
                              teamName: widget.challengedTeam.teamName,
                              teamLogo: widget.challengedTeam.logoUrl,
                            ),
                          ],
                        ),
                      ],
                    )),
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
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'No of players : ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    TextSpan(
                                      text: '$_noOfPlayers',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: darkGreenColor,
                                          ),
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  const Text('5'),
                                  Expanded(
                                    child: Slider(
                                      min: 5,
                                      max: 11,
                                      value: _noOfPlayers,
                                      divisions: 6,
                                      label: '$_noOfPlayers',
                                      onChanged: (value) {
                                        setState(() {
                                          _noOfPlayers = value;
                                        });
                                      },
                                    ),
                                  ),
                                  const Text('11'),
                                ],
                              ),
                            ],
                          ),
                          MyDropdownMenu(
                            options: matchFormatOptions,
                            label: 'Match Format',
                            onSelect: (value) {
                              _matchFormat = value;
                            },
                          ),
                          MyDropdownMenu(
                            options: enumToString(MatchType.values),
                            label: 'Match Type',
                            onSelect: (value) {
                              _matchType = value;
                            },
                          ),
                          SwitchListTile(
                            value: _allowSpectators,
                            title: Text(
                              'Allow Spectators',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: Colors.black, fontSize: 17),
                            ),
                            subtitle: const Text(
                              'Any one can see this match',
                            ),
                            activeColor: enableSwitchColor,
                            onChanged: (value) {
                              setState(() {
                                _allowSpectators = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    //! Select Squad
                    MyCard(
                      child: MatchSquad(
                        selectedPlayer: _selectedPlayer,
                        captainId: _captainId,
                        wicketkeeperId: _wicketkeeperId,
                        onAdd: onAddPlayer,
                      ),
                    ),
                    //! Roles
                    MyCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 12,
                        children: [
                          getTitleText('Roles', context),
                          //! Captain, Wicketkeeper
                          MyDropdownMenu(
                            options: _playerNames,
                            label: 'Change Captaincy',
                            controller: _captainController,
                            onSelect: (value) {
                              setState(() {
                                int index = _playerNames
                                    .indexWhere((name) => name == value);

                                _captainId = _selectedPlayer[index].playerId;
                              });
                            },
                          ),
                          MyDropdownMenu(
                            options: _playerNames,
                            label: 'Change Wicketkeeper',
                            controller: _wicketkeeperController,
                            onSelect: (value) {
                              setState(() {
                                int index = _playerNames
                                    .indexWhere((name) => name == value);

                                _wicketkeeperId =
                                    _selectedPlayer[index].playerId;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    //! Match Venue
                    MyCard(
                      child: Column(
                        spacing: 20,
                        children: [
                          getTitleText('Schedule & Venue Detail', context),
                          Row(
                            children: [
                              _getScheduleContainer(
                                  DateFormat.yMMMd().format(_matchDate)),
                              const SizedBox(width: 10),
                              _getScheduleContainer(
                                MaterialLocalizations.of(context)
                                    .formatTimeOfDay(_matchTime),
                              ),
                              IconButton(
                                onPressed: () async {
                                  final selectedDate = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(DateTime.now().year + 1),
                                    initialDate: DateTime.now(),
                                  );

                                  if (!context.mounted) return;
                                  final selectedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );

                                  setState(() {
                                    _matchDate = selectedDate ?? _matchDate;
                                    _matchTime = selectedTime ?? _matchTime;
                                  });
                                },
                                icon: const Icon(Icons.date_range_outlined),
                                iconSize: 30,
                              )
                            ],
                          ),
                          Form(
                            key: _formKey,
                            child: MyTextField(
                              onSave: (value) {
                                _venue = value;
                              },
                              label: 'Venue',
                              borderRadius: 15,
                              validator: (value) =>
                                  ValidationServices.nameValidator(
                                      value, 'Venue'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: MyElevatedButton.primaryElevatedButton(
                          context,
                          isSubmit: true,
                          text: 'Challenge Match',
                          onPressed: _challengeMatch,
                          isLoading: _isChallenging,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _getScheduleContainer(String scheduleText) {
    return Expanded(
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: blackColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Align(
          alignment: const Alignment(-0.8, 0),
          child: Text(scheduleText),
        ),
      ),
    );
  }
}
