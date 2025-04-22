import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tracket/common/widgets/circular_loading_indicator.dart';
import 'package:tracket/common/widgets/custom_widgets/my_card.dart';
import 'package:tracket/common/widgets/custom_widgets/my_dropdown_menu.dart';
import 'package:tracket/common/widgets/custom_widgets/my_text_field.dart';
import 'package:tracket/features/matches/models/match.dart';
import 'package:tracket/features/matches/models/match_player_info.dart';
import 'package:tracket/features/matches/models/match_team_info.dart';
import 'package:tracket/features/matches/services/matches_services.dart';
import 'package:tracket/features/matches/utils/utils.dart';
import 'package:tracket/features/matches/widgets/captain_and_wicketkeeper_dropdown.dart';
import 'package:tracket/features/matches/widgets/match_squad.dart';
import 'package:tracket/features/matches/widgets/squad_selection_sheet.dart';
import 'package:tracket/features/matches/widgets/team_section.dart';
import 'package:tracket/features/teams/models/team.dart';
import 'package:tracket/features/teams/services/teams_services.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/utility_classes/custom_button.dart';
import 'package:tracket/utils/validator/validator.dart';

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

class _CreateMatchScreenState extends State<ChallengeMatchScreen> {
  // Constants
  static const double _minPlayers = 5.0;
  static const double _maxPlayers = 11.0;
  static const int _playersDivisions = 6;

  // Form Controllers
  final _formKey = GlobalKey<FormState>();
  final _captainController = TextEditingController();
  final _wicketkeeperController = TextEditingController();

  // State Management using ValueNotifier
  final _selectedPlayers = ValueNotifier<List<MatchPlayerInfo>>([]);
  final _captainId = ValueNotifier<String>('');
  final _wicketkeeperId = ValueNotifier<String>('');

  // Match Settings
  final ValueNotifier<double> _noOfPlayers = ValueNotifier(7.0);
  final ValueNotifier<bool> _allowSpectators = ValueNotifier(true);
  final ValueNotifier<DateTime> _matchDate = ValueNotifier(DateTime.now());
  final ValueNotifier<TimeOfDay> _matchTime = ValueNotifier(TimeOfDay.now());
  final ValueNotifier<String?> _venue = ValueNotifier(null);
  final ValueNotifier<String?> _matchType = ValueNotifier(null);
  final ValueNotifier<String?> _matchFormat = ValueNotifier(null);

  // Loading States
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  final ValueNotifier<bool> _isChallenging = ValueNotifier(false);

  // Team Data
  late Team _challengerTeam;

  // Options
  final List<String> matchFormatOptions = THelperFunction.matchFormatToString();
  final List<String> matchTypeOptions =
      THelperFunction.enumToString(MatchType.values);

  @override
  void initState() {
    _loadTeamData();
    super.initState();
  }

  @override
  void dispose() {
    // Dispose all controllers and notifiers
    _captainController.dispose();
    _wicketkeeperController.dispose();
    _selectedPlayers.dispose();
    _captainId.dispose();
    _wicketkeeperId.dispose();
    _noOfPlayers.dispose();
    _allowSpectators.dispose();
    _matchDate.dispose();
    _matchTime.dispose();
    _venue.dispose();
    _matchType.dispose();
    _matchFormat.dispose();
    _isLoading.dispose();
    _isChallenging.dispose();
    super.dispose();
  }

  Future<void> _loadTeamData() async {
    _isLoading.value = true;

    try {
      final teamData = await TeamsServices.getTeamData(widget.challengerTeamId);

      if (!mounted) return;

      final teamPlayers = await TeamsServices.getTeamPlayersFromId(
        widget.challengerTeamId,
        context,
      );

      _challengerTeam = Team.fromJson(teamData, teamPlayers);
    } catch (e) {
      if (!mounted) return;
      _handleError('Failed to load team data', e);
    } finally {
      _isLoading.value = false;
      setState(() {});
    }
  }

  void _handleError(String message, [dynamic error]) {
    if (!mounted) return;
    THelperFunction.showSnackBar(
        '$message${error != null ? ': $error' : ''}', context);
  }

  void onAddPlayer() {
    SquadSelectionSheet.show(
      context,
      playersList:
          MatchPlayerInfo.fromPlayerDetailList(_challengerTeam.playersList),
      noOfPlayersCanBeSelected: _noOfPlayers.value.toInt(),
      onSubmit: (List<MatchPlayerInfo> selectedPlayers) {
        _updateSelectedPlayers(selectedPlayers);
        Navigator.of(context).pop();
      },
    );
  }

  void _updateSelectedPlayers(List<MatchPlayerInfo> players) {
    final captain = _captainController.text;
    final wicketkeeper = _wicketkeeperController.text;

    _selectedPlayers.value = players.map((player) {
      if (captain.isEmpty && player.playerId == _challengerTeam.captainId) {
        _captainController.text = player.playerName.toUpperCase();
        _captainId.value = player.playerId;
      }
      if (wicketkeeper.isEmpty &&
          player.playerId == _challengerTeam.wicketkeeperId) {
        _wicketkeeperController.text = player.playerName.toUpperCase();
        _wicketkeeperId.value = player.playerId;
      }
      return player.copyWith();
    }).toList();

    setState(() {});
  }

  bool _validateMatchDetails() {
    if (_matchFormat.value == null || _matchType.value == null) {
      _handleError('Please fill all details');
      return false;
    }
    if (_selectedPlayers.value.isEmpty) {
      _handleError('Please select players for match');
      return false;
    }
    if (_captainId.value.isEmpty) {
      _handleError('Please select team captain');
      return false;
    }
    if (_wicketkeeperId.value.isEmpty) {
      _handleError('Please select team wicketkeeper');
      return false;
    }
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    return true;
  }

  Future<void> _challengeMatch() async {
    if (!_validateMatchDetails()) return;

    _isChallenging.value = true;
    _formKey.currentState!.save();

    final challengerTeamDetail = MatchTeamInfo(
      teamId: _challengerTeam.id,
      logoUrl: _challengerTeam.logoUrl,
      teamName: _challengerTeam.name,
      shortName: _challengerTeam.shortName,
      captainId: _captainId.value,
      wicketkeeperId: _wicketkeeperId.value,
    );

    try {
      await MatchesServices.challengeForAMatch(
        matchFormatIndex: matchFormatOptions.indexOf(_matchFormat.value!),
        challengerTeam: challengerTeamDetail,
        challengedTeam: widget.challengedTeam,
        matchDate: _matchDate.value,
        matchTime: _matchTime.value,
        matchVenue: _venue.value!,
        challengerId: widget.challengerId,
        challengerName: widget.challengerName,
        allowSpectators: _allowSpectators.value,
        noOfPlayers: _noOfPlayers.value.toInt(),
        challengerPlayers: _selectedPlayers.value,
        matchType: _matchType.value!,
      );

      if (mounted) {
        THelperFunction.showSnackBar('Challenge sent successfully!', context);
        Navigator.of(context).pop();
      }
    } catch (e) {
      _handleError('Failed to create challenge', e);
    } finally {
      _isChallenging.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenge Match'),
      ),
      body: _isLoading.value
          ? const CircularLoadingIndicator()
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    _buildTeamsSection(),
                    _buildMatchDetailsCard(isDark),
                    _buildSquadSelection(),
                    _buildRolesSection(),
                    _buildScheduleAndVenue(isDark),
                    _buildChallengeButton(),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildRolesSection() {
    final playerNames = getPlayerNames(_selectedPlayers);
    return CaptainAndWicketkeeperDropdown(
      playersName: playerNames,
      captainController: _captainController,
      selectedPlayers: _selectedPlayers,
      wicketkeeperController: _wicketkeeperController,
      onSelectCaptain: (name) {
        if (name == null) return;
        final index = playerNames.indexOf(name);
        _captainId.value = _selectedPlayers.value[index].playerId;
        _captainController.text = name.toUpperCase();
        setState(() {});
      },
      onSelectWicketkeeper: (name) {
        if (name == null) return;
        final index = playerNames.indexOf(name);
        _wicketkeeperId.value = _selectedPlayers.value[index].playerId;
        _wicketkeeperController.text = name.toUpperCase();
        setState(() {});
      },
    );
  }

  Widget _buildTeamsSection() {
    return TeamSection(
      team1Name: _challengerTeam.name,
      team1Logo: _challengerTeam.logoUrl,
      team2Name: widget.challengedTeam.teamName,
      team2Logo: widget.challengedTeam.logoUrl,
    );
  }

  Widget _buildMatchDetailsCard(bool isDark) {
    return MyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          THelperFunction.getTitleText('Match Details', context),
          const SizedBox(height: 12),
          _buildPlayerCountSection(isDark),
          _buildMatchFormatDropdown(),
          const SizedBox(height: 16),
          _buildMatchTypeDropdown(),
          const SizedBox(height: 16),
          _buildSpectatorToggle(isDark),
        ],
      ),
    );
  }

  Widget _buildPlayerCountSection(bool isDark) {
    return ValueListenableBuilder<double>(
      valueListenable: _noOfPlayers,
      builder: (context, value, _) => Column(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Number of players :  ',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                TextSpan(
                  text: value.toInt().toString(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark ? lightGrassGreen : darkGrassGreen,
                      ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Text(_minPlayers.toInt().toString()),
              Expanded(
                child: Slider(
                  min: _minPlayers,
                  max: _maxPlayers,
                  divisions: _playersDivisions,
                  value: value,
                  label: value.toInt().toString(),
                  onChanged: (newValue) {
                    _noOfPlayers.value = newValue;
                    if (newValue.toInt() != _selectedPlayers.value.length &&
                        _selectedPlayers.value.isNotEmpty) {
                      _selectedPlayers.value = [];
                      setState(() {});
                    }
                  },
                ),
              ),
              Text(_maxPlayers.toInt().toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMatchFormatDropdown() {
    return ValueListenableBuilder(
      builder: (context, value, _) => MyDropdownMenu(
        options: matchFormatOptions,
        label: 'Match Format',
        onSelect: (value) {
          _matchFormat.value = value;
        },
      ),
      valueListenable: _matchFormat,
    );
  }

  Widget _buildMatchTypeDropdown() {
    return ValueListenableBuilder(
      valueListenable: _matchType,
      builder: (context, value, child) => MyDropdownMenu(
        options: THelperFunction.enumToString(MatchType.values),
        label: 'Match Type',
        onSelect: (value) {
          _matchType.value = value;
        },
      ),
    );
  }

  Widget _buildSpectatorToggle(bool isDark) {
    return ValueListenableBuilder(
      valueListenable: _allowSpectators,
      builder: (context, value, _) => SwitchListTile(
        value: value,
        title: Text(
          'Allow Spectators',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: isDark
                  ? DarkThemeColors.primaryText
                  : LightThemeColors.primaryText,
              fontSize: 15),
        ),
        subtitle: const Text(
          'Any one can see this match',
        ),
        activeColor: InteractiveColors.focused,
        onChanged: (value) {
          setState(() {
            _allowSpectators.value = value;
          });
        },
      ),
    );
  }

  Widget _buildSquadSelection() {
    return MyCard(
      child: MatchSquad(
        players: _selectedPlayers.value,
        captainId: _captainId.value,
        wicketkeeperId: _wicketkeeperId.value,
        isPlayerCanAdd: true,
        onAddPlayer: onAddPlayer,
        titleSize: 18,
        iconSize: 24,
      ),
    );
  }

  Widget _buildScheduleAndVenue(bool isDark) {
    return MyCard(
      child: Column(
        spacing: 20,
        children: [
          THelperFunction.getTitleText('Schedule & Venue Detail', context),
          _buildScheduleRow(isDark),
          _buildVenueForm(),
        ],
      ),
    );
  }

  Widget _buildScheduleRow(bool isDark) {
    return Row(
      children: [
        _getScheduleContainer(
            DateFormat.yMMMd().format(_matchDate.value), isDark),
        const SizedBox(width: 10),
        _getScheduleContainer(
            MaterialLocalizations.of(context).formatTimeOfDay(_matchTime.value),
            isDark),
        IconButton(
          onPressed: () async {
            final initialDate = DateTime.now().add(const Duration(minutes: 5));
            final selectedDate = await showDatePicker(
              context: context,
              firstDate: initialDate,
              lastDate: DateTime(DateTime.now().year + 1),
              initialDate: initialDate,
            );

            if (!context.mounted) return;
            final selectedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );

            setState(() {
              _matchDate.value = selectedDate ?? _matchDate.value;
              _matchTime.value = selectedTime ?? _matchTime.value;
            });
          },
          icon: const Icon(Icons.date_range_outlined),
          iconSize: 30,
        )
      ],
    );
  }

  Widget _buildVenueForm() {
    return Form(
      key: _formKey,
      child: MyTextField(
        onSave: (value) {
          _venue.value = value;
        },
        label: 'Venue',
        validator: (value) => TValidator.nameValidator(value, 'Venue'),
      ),
    );
  }

  Widget _buildChallengeButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: ValueListenableBuilder<bool>(
        valueListenable: _isChallenging,
        builder: (context, isChallenging, _) => SizedBox(
          width: double.infinity,
          height: 50,
          child: CustomButton.primary(
            text: 'Challenge Match',
            onPressed: _challengeMatch,
            isLoading: isChallenging,
            textStyle: Theme.of(context).textTheme.bodyLarge,
            backgroundColor: grassGreen,
            foregroundColor: LightThemeColors.surfaceColor,
          ),
        ),
      ),
    );
  }

  Widget _getScheduleContainer(String scheduleText, bool isDark) {
    return Expanded(
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          border: Border.all(
              width: 1,
              color: isDark
                  ? DarkThemeColors.primaryText
                  : LightThemeColors.primaryText),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(scheduleText),
        ),
      ),
    );
  }
}
