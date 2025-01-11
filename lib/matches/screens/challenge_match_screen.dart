import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tracket/matches/widgets/match_squad.dart';
import 'package:tracket/matches/widgets/players_selection_dialog.dart';
import 'package:tracket/matches/widgets/team_column.dart';
import 'package:tracket/players/models/player_details.dart';
import 'package:tracket/teams/models/team.dart';
import 'package:tracket/teams/models/team_details.dart';
import 'package:tracket/teams/services/teams_services.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_elevated_button.dart';
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
  final TeamDetails challengedTeam;

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
  double noOfPlayers = 7;
  bool allowSpectators = true;
  DateTime matchDate = DateTime.now();
  TimeOfDay matchTime = TimeOfDay.now();
  bool _isLoading = false;

  final List<PlayerDetails> _selectedPlayer = [];
  late Team challengerTeam;

  @override
  void initState() {
    _loadTeamData();
    super.initState();
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

      challengerTeam = Team.formSeed(teamData, teamPlayers);
    } catch (e) {
      if (!mounted) return;
      showSnackBar(e.toString(), context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void onAddPlayer() {
    showDialog(
      context: context,
      builder: (context) => PlayersSelectionDialog(
        playerList: challengerTeam.playersList,
        selectedPlayers: _selectedPlayer,
        noOfPlayerCanBeSelected : 7,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenge Match'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
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
                              teamName: challengerTeam.name,
                              teamLogo: challengerTeam.logoUrl,
                            ),
                            const Text('v/s'),
                            TeamColumn(
                              teamName: widget.challengedTeam.name,
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
                                      text: '$noOfPlayers',
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
                                      value: noOfPlayers,
                                      divisions: 6,
                                      label: '$noOfPlayers',
                                      onChanged: (value) {
                                        setState(() {
                                          noOfPlayers = value;
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
                            options: const [
                              '5 Overs',
                              '10 Overs',
                              '20 Overs',
                              '50 Overs'
                            ],
                            label: 'Numbers of overs',
                            onSelect: (value) {},
                          ),
                          MyDropdownMenu(
                            options: const [
                              'friendly',
                              'practice',
                              'challanged'
                            ],
                            label: 'Match Type',
                            onSelect: (value) {},
                          ),
                          SwitchListTile(
                            value: allowSpectators,
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
                                allowSpectators = value;
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
                        captainId: challengerTeam.captainId,
                        wicketkeeperId: challengerTeam.wicketkeeperId,
                        onAdd: onAddPlayer,
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
                                  DateFormat.yMMMd().format(matchDate)),
                              const SizedBox(width: 10),
                              _getScheduleContainer(
                                MaterialLocalizations.of(context)
                                    .formatTimeOfDay(matchTime),
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
                                    matchDate = selectedDate ?? matchDate;
                                    matchTime = selectedTime ?? matchTime;
                                  });
                                },
                                icon: const Icon(Icons.date_range_outlined),
                                iconSize: 30,
                              )
                            ],
                          ),
                          MyTextField(
                            onSave: (value) {},
                            label: 'Venue',
                            borderRadius: 15,
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
                          onPressed: () {},
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
