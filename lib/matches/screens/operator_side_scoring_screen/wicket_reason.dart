import 'package:flutter/material.dart';
import 'package:tracket/matches/models/batting_score.dart';
import 'package:tracket/matches/models/current_player.dart';
import 'package:tracket/matches/models/match_player_info.dart';
import 'package:tracket/matches/providers/extras_provider.dart';
import 'package:tracket/teams/widgets/capacity_selector.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_dropdown_menu.dart';

class WicketReason extends StatefulWidget {
  const WicketReason({
    super.key,
    required this.fielders,
    required this.strikers,
    required this.extras,
  });

  final List<MatchPlayerInfo> fielders;
  final List<StrikerData> strikers;
  final ExtrasState extras;

  @override
  State<WicketReason> createState() => _WicketReasonState();
}

class _WicketReasonState extends State<WicketReason> {
  int _selectedIndex = -1;
  ReasonOfOut? _reasonOfOut;
  int _runsCompleted = 0;
  String? _runOutBy;
  String? _runOutBatsman;
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
      if (_reasonOfOut == ReasonOfOut.runOut ||
          _reasonOfOut == ReasonOfOut.caught) {
        _sheetSize = 0.85;
      } else {
        _sheetSize = 0.65;
      }
    });
  }

  void _onConfirm() {
    if (_reasonOfOut == null) {
      showIconAlertDialog(
        context,
        title: 'Error',
        errorMessage: 'Please select a reason',
        icon: Icons.error,
      );
      return;
    }
    if (_reasonOfOut == ReasonOfOut.runOut && _runOutBatsman == null) {
      showIconAlertDialog(
        context,
        title: 'Error',
        errorMessage: 'Please select the batsman who run out',
        icon: Icons.error,
      );
      return;
    }
    if (_reasonOfOut == ReasonOfOut.runOut && _runOutBy == null) {
      showIconAlertDialog(
        context,
        title: 'Error',
        errorMessage: 'Please select the fielder who run out the batsman',
        icon: Icons.error,
      );
      return;
    }
    if (_reasonOfOut == ReasonOfOut.caught && _caughtBy == null) {
      showIconAlertDialog(
        context,
        title: 'Error',
        errorMessage: 'Please select the fielder who caught the batsman',
        icon: Icons.error,
      );
      return;
    }
    Map<String, dynamic> data = {
      'reasonOfOut': _reasonOfOut,
      'runsCompleted':
          _reasonOfOut == ReasonOfOut.runOut ? _runsCompleted : null,
      'runOutBatsman': _runOutBatsman,
      'runOutBy': _runOutBy,
      'caughtBy': _caughtBy,
    };
    Navigator.of(context).pop(data);
  }

  @override
  Widget build(BuildContext context) {
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
          snapSizes: [0.65, 0.85, 0.95],
          builder: (BuildContext context, ScrollController scrollController) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  decoration: BoxDecoration(
                    color: LightThemeColors.backgroundColor,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Drag handle
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 12),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Expanded(
                        child: CustomScrollView(
                          controller: scrollController,
                          slivers: [
                            SliverPadding(
                              padding: EdgeInsets.fromLTRB(40, 10, 40, 30),
                              sliver: SliverList(
                                delegate: SliverChildListDelegate([
                                  Text(
                                    'How was the batsman dismissed?',
                                    style: MyTextStyle(context)
                                        .titleMedium
                                        .copyWith(
                                          color: grassGreen,
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                  SizedBox(height: 16),
                                  // Dismissal options
                                  ...List.generate(_reasons.length, (index) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: InkWell(
                                        onTap: () => _onReasonSelected(index),
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          height: 50,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          decoration: BoxDecoration(
                                            color: _selectedIndex == index
                                                ? primaryMedium
                                                : primaryMedium.withValues(
                                                    alpha: 0.2),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(
                                              _reasons[index].description,
                                              style: MyTextStyle(context)
                                                  .bodyLarge
                                                  .copyWith(
                                                    color:
                                                        _selectedIndex == index
                                                            ? LightThemeColors.surfaceColor
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
                                    SizedBox(height: 16),
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
                                      labelColor: grassGreen,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Run out batsman:',
                                      style: MyTextStyle(context)
                                          .bodyLarge
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: grassGreen,
                                          ),
                                    ),
                                    SizedBox(height: 8),
                                    MyDropdownMenu(
                                      hintText: 'Select batsman',
                                      options: widget.strikers
                                          .map((e) => e.playerName)
                                          .toList(),
                                      onSelect: (value) => setState(
                                        () {
                                          int index = widget.strikers
                                              .indexWhere(
                                                  (e) => e.playerName == value);
                                          _runOutBatsman =
                                              widget.strikers[index].id;
                                        },
                                      ),
                                      leadingIcon: Icon(Icons.person_outline),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Run out by:',
                                      style: MyTextStyle(context)
                                          .bodyLarge
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: grassGreen,
                                          ),
                                    ),
                                    SizedBox(height: 8),
                                    MyDropdownMenu(
                                      hintText: 'Select fielder',
                                      options: widget.fielders
                                          .map((e) => e.playerName)
                                          .toList(),
                                      onSelect: (value) => setState(
                                        () {
                                          int index = widget.fielders
                                              .indexWhere(
                                                  (e) => e.playerName == value);
                                          _runOutBy =
                                              widget.fielders[index].playerId;
                                        },
                                      ),
                                      leadingIcon: Icon(Icons.person_outline),
                                    ),
                                  ],
                                  if (_reasonOfOut == ReasonOfOut.caught) ...[
                                    SizedBox(height: 16),
                                    Text(
                                      'Caught by:',
                                      style: MyTextStyle(context)
                                          .bodyLarge
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: grassGreen,
                                          ),
                                    ),
                                    SizedBox(height: 8),
                                    MyDropdownMenu(
                                      hintText: 'Select fielder',
                                      options: widget.fielders
                                          .map((e) => e.playerName)
                                          .toList(),
                                      onSelect: (value) =>
                                          setState(() => _caughtBy = value),
                                      leadingIcon: Icon(Icons.person_outline),
                                    ),
                                  ],
                                  SizedBox(height: 24),
                                  // Action buttons
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(null),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                LightThemeColors.backgroundColor,
                                            foregroundColor: grassGreen,
                                            side: BorderSide(
                                                color: grassGreen),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.clear,
                                                  color: grassGreen),
                                              SizedBox(width: 8),
                                              Text('Cancel',
                                                  style: MyTextStyle(context)
                                                      .bodyLarge
                                                      .copyWith(
                                                        color: grassGreen,
                                                      )),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: _onConfirm,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: grassGreen,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.check,
                                                  color:
                                                      LightThemeColors.surfaceColor),
                                              SizedBox(width: 8),
                                              Text('Confirm',
                                                  style: MyTextStyle(context)
                                                      .bodyLarge
                                                      .copyWith(
                                                        color:
                                                            LightThemeColors
                                                                .surfaceColor,
                                                      )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
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
