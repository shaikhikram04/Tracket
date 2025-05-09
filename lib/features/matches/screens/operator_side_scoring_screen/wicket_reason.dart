import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/custom_widgets/my_dropdown_menu.dart';
import 'package:tracket/features/matches/models/batting_score.dart';
import 'package:tracket/features/matches/models/bowling_score.dart';
import 'package:tracket/features/matches/models/match_player_info.dart';
import 'package:tracket/features/matches/providers/extras_provider.dart';
import 'package:tracket/features/teams/widgets/capacity_selector.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/enums.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class WicketReason extends StatefulWidget {
  const WicketReason({
    super.key,
    required this.bowler,
    required this.fielders,
    required this.strikers,
    required this.extras,
    required this.wicketkeeperName,
  });

  final BowlingScore bowler;
  final String wicketkeeperName;
  final List<MatchPlayerInfo> fielders;
  final List<BattingScore> strikers;
  final ExtrasState extras;

  @override
  State<WicketReason> createState() => _WicketReasonState();
}

class _WicketReasonState extends State<WicketReason> {
  int _selectedIndex = -1;
  ReasonOfOut? _reasonOfOut;
  int _runsCompleted = 0;
  String? _runOutBy;
  int? _runOutBatsmanPosition;
  String? _caughtBy;
  double _sheetSize = 0.65;
  List<ReasonOfOut> _reasons = [];

  @override
  void initState() {
    super.initState();
    _addReason();
  }

  void _addReason() {
    final extras = widget.extras;

    if (extras.isWide) {
      _reasons = [
        ReasonOfOut.stumped,
        ReasonOfOut.hitWicket,
        ReasonOfOut.runOut,
      ];
    } else if (extras.isNoBall) {
      _reasons = [
        ReasonOfOut.hitWicket,
        ReasonOfOut.runOut,
      ];
    } else if (extras.isBye || extras.isLegBye) {
      _reasons = [
        ReasonOfOut.runOut,
      ];
    } else {
      _reasons = [
        ReasonOfOut.hitWicket,
        ReasonOfOut.stumped,
        ReasonOfOut.bowled,
        ReasonOfOut.lbw,
        ReasonOfOut.caught,
        ReasonOfOut.runOut,
      ];
    }
  }

  void _onReasonSelected(int index) {
    setState(() {
      _selectedIndex = index;
      _reasonOfOut = _reasons[index];
      // Adjust sheet size based on selected reason
      if (_reasonOfOut == ReasonOfOut.runOut || _reasonOfOut == ReasonOfOut.caught) {
        _sheetSize = 0.85;
      } else {
        _sheetSize = 0.65;
      }
    });
  }

  void _onConfirm() {
    if (_reasonOfOut == null) {
      THelperFunction.showIconAlertDialog(
        context,
        title: 'Error',
        errorMessage: 'Please select a reason',
        icon: Icons.error,
      );
      return;
    }
    if (_reasonOfOut == ReasonOfOut.runOut && _runOutBatsmanPosition == null) {
      THelperFunction.showIconAlertDialog(
        context,
        title: 'Error',
        errorMessage: 'Please select the batsman who run out',
        icon: Icons.error,
      );
      return;
    }
    if (_reasonOfOut == ReasonOfOut.runOut && _runOutBy == null) {
      THelperFunction.showIconAlertDialog(
        context,
        title: 'Error',
        errorMessage: 'Please select the fielder who run out the batsman',
        icon: Icons.error,
      );
      return;
    }
    if (_reasonOfOut == ReasonOfOut.caught && _caughtBy == null) {
      THelperFunction.showIconAlertDialog(
        context,
        title: 'Error',
        errorMessage: 'Please select the fielder who caught the batsman',
        icon: Icons.error,
      );
      return;
    }

    Map<String, dynamic> data = {
      'reasonOfOut': _reasonOfOut,
      'runsCompleted': _reasonOfOut == ReasonOfOut.runOut ? _runsCompleted : null,
      'runOutBatsman': _runOutBatsmanPosition,
      'runOutBy': _runOutBy,
      'caughtBy': _caughtBy,
      'dismissalInfo': _getDismissalInfo(),
    };
    Navigator.of(context).pop(data);
  }

  String _getDismissalInfo() {
    final suffixInfo = _reasonOfOut == ReasonOfOut.runOut ? '' : 'b ${widget.bowler.playerName}';
    var prefixInfo = '';

    if (_reasonOfOut == ReasonOfOut.caught) {
      prefixInfo = 'c $_caughtBy  ';
    } else if (_reasonOfOut == ReasonOfOut.hitWicket) {
      prefixInfo = 'hit wicket  ';
    } else if (_reasonOfOut == ReasonOfOut.lbw) {
      prefixInfo = 'lbw  ';
    } else if (_reasonOfOut == ReasonOfOut.runOut) {
      prefixInfo = 'run out ($_runOutBy)';
    } else if (_reasonOfOut == ReasonOfOut.stumped) {
      prefixInfo = 'st ${widget.wicketkeeperName}  ';
    }

    return prefixInfo + suffixInfo;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunction.isDarkMode(context);
    return Stack(
      children: [
        // Semi-transparent background
        GestureDetector(
          onTap: () => Navigator.of(context).pop(null),
        ),
        // Bottom Sheet
        DraggableScrollableSheet(
          initialChildSize: _sheetSize,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          snap: true,
          snapSizes: const [0.65, 0.85, 0.95],
          builder: (BuildContext context, ScrollController scrollController) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  decoration: BoxDecoration(
                    color: isDark ? DarkThemeColors.secondaryBackground : LightThemeColors.secondaryBackground,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Drag handle
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey.withValues(alpha: 0.6) : Colors.grey.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Expanded(
                        child: CustomScrollView(
                          controller: scrollController,
                          slivers: [
                            SliverPadding(
                              padding: const EdgeInsets.fromLTRB(40, 10, 40, 30),
                              sliver: SliverList(
                                delegate: SliverChildListDelegate([
                                  Text(
                                    'How was the batsman dismissed?',
                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                          color: isDark ? lightGrassGreen : grassGreen,
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Dismissal options
                                  ...List.generate(_reasons.length, (index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: InkWell(
                                        onTap: () => _onReasonSelected(index),
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          height: 50,
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          decoration: BoxDecoration(
                                            color: _selectedIndex == index
                                                ? primaryMedium
                                                : primaryMedium.withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(
                                              _reasons[index].description,
                                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                                    color: _selectedIndex == index
                                                        ? LightThemeColors.surfaceColor
                                                        : isDark
                                                            ? lightGrassGreen
                                                            : grassGreen,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                  // Additional fields based on selection
                                  if (_reasonOfOut == ReasonOfOut.runOut) ...[
                                    const SizedBox(height: 16),
                                    CapacitySelector(
                                      capacity: _runsCompleted,
                                      onIncrement: () {
                                        if (_runsCompleted < 3) {
                                          setState(() => _runsCompleted++);
                                        }
                                      },
                                      onDecrement: () {
                                        if (_runsCompleted > 0) {
                                          setState(() => _runsCompleted--);
                                        }
                                      },
                                      label: 'Runs completed',
                                      textStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: isDark ? lightGrassGreen : grassGreen,
                                          ),
                                      maxCapacity: 3,
                                      minCapacity: 0,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Run out batsman:',
                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: isDark ? lightGrassGreen : grassGreen,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    MyDropdownMenu(
                                      hintText: 'Select batsman',
                                      options: widget.strikers.map((e) => e.playerName).toList(),
                                      onSelect: (value) => setState(
                                        () {
                                          int index = widget.strikers.indexWhere((e) => e.playerName == value);
                                          _runOutBatsmanPosition = widget.strikers[index].battingPosition;
                                        },
                                      ),
                                      leadingIcon: const Icon(Icons.person_outline),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Run out by:',
                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: isDark ? lightGrassGreen : grassGreen,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    MyDropdownMenu(
                                      hintText: 'Select fielder',
                                      options: widget.fielders.map((e) => e.playerName).toList(),
                                      onSelect: (value) => setState(
                                        () => _runOutBy = value,
                                      ),
                                      leadingIcon: const Icon(Icons.person_outline),
                                    ),
                                  ],
                                  if (_reasonOfOut == ReasonOfOut.caught) ...[
                                    const SizedBox(height: 16),
                                    Text(
                                      'Caught by:',
                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: isDark ? lightGrassGreen : grassGreen,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    MyDropdownMenu(
                                      hintText: 'Select fielder',
                                      options: widget.fielders.map((e) => e.playerName).toList(),
                                      onSelect: (value) => setState(() => _caughtBy = value),
                                      leadingIcon: const Icon(Icons.person_outline),
                                    ),
                                  ],
                                  const SizedBox(height: 24),
                                  // Action buttons
                                  SizedBox(
                                    height: 50,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () => Navigator.of(context).pop(null),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: LightThemeColors.backgroundColor,
                                              foregroundColor: grassGreen,
                                              side: const BorderSide(color: grassGreen),
                                              padding: const EdgeInsets.symmetric(vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.clear, color: grassGreen),
                                                const SizedBox(width: 8),
                                                Text('Cancel',
                                                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                                          color: grassGreen,
                                                        )),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: _onConfirm,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: grassGreen,
                                              padding: const EdgeInsets.symmetric(vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.check, color: LightThemeColors.surfaceColor),
                                                const SizedBox(width: 8),
                                                Text('Confirm',
                                                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                                          color: LightThemeColors.surfaceColor,
                                                        )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
