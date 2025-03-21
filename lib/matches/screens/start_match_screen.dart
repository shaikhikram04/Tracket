import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/matches/models/match.dart';
import 'package:tracket/matches/providers/match_provider.dart';
import 'package:tracket/matches/screens/match_players_selection_screen.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/custom_button.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_card.dart';

class StartMatchScreen extends ConsumerStatefulWidget {
  // final Match match;

  const StartMatchScreen({
    Key? key,
    // required this.match,
  }) : super(key: key);

  @override
  ConsumerState<StartMatchScreen> createState() => _StartMatchScreenState();
}

class _StartMatchScreenState extends ConsumerState<StartMatchScreen>
    with SingleTickerProviderStateMixin {
  String? tossWinner;
  String? battingTeam;
  bool isCoinRotating = false;
  late AnimationController _controller;
  late Animation<double> _flipAnimation;
  late Animation<double> _scaleAnimation;

  void _onStartMatch(Match match) {
    bool isTeam1WonToss = tossWinner == match.team1.teamName;
    TossDecision decision = isTeam1WonToss
        ? battingTeam == match.team1.teamName
            ? TossDecision.batting
            : TossDecision.fielding
        : battingTeam == match.team1.teamName
            ? TossDecision.fielding
            : TossDecision.batting;
    ref
        .read(matchStateProvider.notifier)
        .setTossResult(isTeam1Won: isTeam1WonToss, decision: decision);
    pushScreen(context, const MatchPlayersSelectionScreen());
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _flipAnimation = Tween<double>(begin: 0, end: 12).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    _scaleAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 1.5),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.5, end: 1),
        weight: 90,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    final match = ref.read(matchStateProvider);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isCoinRotating = false;
          tossWinner = Random().nextBool()
              ? match!.team1.teamName
              : match!.team2.teamName;
        });
      }
    });
  }

  void _startToss() {
    setState(() {
      isCoinRotating = true;
      tossWinner = null;
      battingTeam = null;
    });
    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final match = ref.watch(matchStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Match'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MyCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          match!.team1.teamName,
                          style: MyTextStyle(context).titleLarge.copyWith(
                                color: secondaryColor,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'VS',
                          style: MyTextStyle(context).bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: LightThemeColors.secondaryText,
                              ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          match.team2.teamName,
                          style: MyTextStyle(context).titleLarge.copyWith(
                                color: StatusColors.warning,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Time for Toss!',
                    style: MyTextStyle(context).titleMedium.copyWith(
                          color: Colors.grey.shade700,
                        ),
                  ),
                  const SizedBox(height: 30),
                  // Enhanced coin flip animation
                  Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      height: 150,
                      width: 150,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateX(_flipAnimation.value * pi)
                          ..rotateY(_flipAnimation.value * pi),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.amber.shade300,
                                Colors.amber.shade600,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: LightThemeColors.primaryText
                                    .withValues(alpha: 0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.sports_cricket,
                              size: 80,
                              color: LightThemeColors.surfaceColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (!isCoinRotating)
                    CustomButton.primary(
                      onPressed: _startToss,
                      text: 'Toss Coin',
                      backgroundColor: grassGreen,
                      textStyle: MyTextStyle(context).buttonText.copyWith(
                            color: LightThemeColors.surfaceColor,
                          ),
                    ),
                ],
              ),
            ),
            if (tossWinner != null)
              MyCard(
                child: Column(
                  children: [
                    Text(
                      '🏆 $tossWinner won the toss!',
                      style: MyTextStyle(context).titleLarge.copyWith(
                            color: grassGreen,
                          ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Choose your decision:',
                      style: MyTextStyle(context).bodyLarge.copyWith(
                            color: LightThemeColors.secondaryText,
                          ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildDecisionButton(
                          icon: Icons.sports_cricket,
                          label: 'Bat',
                          onPressed: () {
                            setState(() {
                              battingTeam = tossWinner;
                            });
                          },
                        ),
                        _buildDecisionButton(
                          icon: Icons.sports_baseball,
                          label: 'Bowl',
                          onPressed: () {
                            setState(() {
                              battingTeam = tossWinner == match.team1.teamName
                                  ? match.team2.teamName
                                  : match.team1.teamName;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            if (battingTeam != null)
              MyCard(
                child: Column(
                  children: [
                    Text(
                      '$battingTeam will bat first',
                      style: MyTextStyle(context).titleLarge.copyWith(
                            color: LightThemeColors.batsmanColor,
                          ),
                    ),
                    const SizedBox(height: 30),
                    CustomButton.primary(
                      text: 'Next',
                      textStyle: MyTextStyle(context).titleLarge.copyWith(
                            fontSize: 20,
                            color: LightThemeColors.surfaceColor,
                          ),
                      icon: const Icon(
                        Icons.play_circle_filled,
                        size: 30,
                        color: LightThemeColors.surfaceColor,
                      ),
                      onPressed: () => _onStartMatch(match),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDecisionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return CustomButton.primary(
      text: label,
      icon: Icon(icon, color: LightThemeColors.surfaceColor),
      onPressed: onPressed,
      textStyle: MyTextStyle(context).buttonText.copyWith(
            color: LightThemeColors.surfaceColor,
          ),
      borderRadius: 20,
    );
  }
}
