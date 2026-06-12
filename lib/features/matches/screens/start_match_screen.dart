import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracket/common/widgets/custom_widgets/my_card.dart';
import 'package:tracket/features/matches/models/match.dart';
import 'package:tracket/features/matches/providers/match_provider.dart';
import 'package:tracket/features/matches/screens/match_players_selection_screen.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/enums.dart';
import 'package:tracket/utils/helpers/helping_function.dart';
import 'package:tracket/utils/utility_classes/custom_button.dart';

class StartMatchScreen extends ConsumerStatefulWidget {
  // final Match match;

  const StartMatchScreen({
    super.key,
    // required this.match,
  });

  @override
  ConsumerState<StartMatchScreen> createState() => _StartMatchScreenState();
}

class _StartMatchScreenState extends ConsumerState<StartMatchScreen> with SingleTickerProviderStateMixin {
  String? tossWinner;
  String? battingTeam;
  bool isCoinRotating = false;
  late AnimationController _controller;
  late Animation<double> _flipAnimation;
  late Animation<double> _scaleAnimation;

  // Add a ScrollController
  final ScrollController _scrollController = ScrollController();

  // Add GlobalKeys for sections we want to scroll to
  final GlobalKey _tossResultKey = GlobalKey();
  final GlobalKey _battingTeamKey = GlobalKey();

  void _onStartMatch(Match match) {
    bool isTeam1WonToss = tossWinner == match.team1.teamName;
    TossDecision decision = isTeam1WonToss
        ? battingTeam == match.team1.teamName
            ? TossDecision.batting
            : TossDecision.fielding
        : battingTeam == match.team1.teamName
            ? TossDecision.fielding
            : TossDecision.batting;
    ref.read(matchStateProvider.notifier).setTossResult(isTeam1Won: isTeam1WonToss, decision: decision);
    THelperFunction.pushScreen(context, const MatchPlayersSelectionScreen());
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
          tossWinner = Random().nextBool() ? match!.team1.teamName : match!.team2.teamName;
        });

        // Scroll to toss result after animation completes
        _scrollToWidget(_tossResultKey);
      }
    });
  }

  // Method to scroll to a specific widget using a GlobalKey
  void _scrollToWidget(GlobalKey key) {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients && key.currentContext != null) {
        final RenderObject? renderObject = key.currentContext?.findRenderObject();
        if (renderObject is RenderBox) {
          final position = renderObject.localToGlobal(Offset.zero);
          final scrollPosition = position.dy;

          // Calculate scroll position relative to the viewport
          final scrollOffset = scrollPosition - 100; // Add some padding at the top

          _scrollController.animateTo(
            scrollOffset,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        }
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
    _scrollController.dispose(); // Dispose the ScrollController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final match = ref.watch(matchStateProvider);

    final isDark = THelperFunction.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Match'),
        iconTheme: IconThemeData(
          color: isDark ? onPrimary : Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController, // Assign the ScrollController
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
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                color: secondaryColor,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'VS',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark ? DarkThemeColors.secondaryText : LightThemeColors.secondaryText,
                              ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          match.team2.teamName,
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
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
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: isDark ? DarkThemeColors.primaryText : LightThemeColors.primaryText,
                        ),
                  ),
                  const SizedBox(height: 30),
                  // Enhanced coin flip animation
                  Transform.scale(
                    scale: _scaleAnimation.value,
                    child: SizedBox(
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
                                color: LightThemeColors.primaryText.withValues(alpha: 0.3),
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
                      textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: LightThemeColors.surfaceColor,
                          ),
                    ),
                ],
              ),
            ),
            if (tossWinner != null)
              MyCard(
                key: _tossResultKey, // Assign key for scrolling
                child: Column(
                  children: [
                    Text(
                      '🏆 $tossWinner won the toss!',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: isDark ? lightGrassGreen : grassGreen,
                          ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Choose your decision:',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: isDark ? DarkThemeColors.secondaryText : LightThemeColors.secondaryText,
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
                            // Scroll to batting decision after selection
                            _scrollToWidget(_battingTeamKey);
                          },
                        ),
                        _buildDecisionButton(
                          icon: Icons.sports_baseball,
                          label: 'Bowl',
                          onPressed: () {
                            setState(() {
                              battingTeam =
                                  tossWinner == match.team1.teamName ? match.team2.teamName : match.team1.teamName;
                            });
                            // Scroll to batting decision after selection
                            _scrollToWidget(_battingTeamKey);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            if (battingTeam != null)
              MyCard(
                key: _battingTeamKey, // Assign key for scrolling
                child: Column(
                  children: [
                    Text(
                      '$battingTeam will bat first',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: LightThemeColors.batsmanColor,
                          ),
                    ),
                    const SizedBox(height: 30),
                    CustomButton.primary(
                      text: 'Next',
                      textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
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
      textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: LightThemeColors.surfaceColor,
          ),
      borderRadius: 20,
    );
  }
}
