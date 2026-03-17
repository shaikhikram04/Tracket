import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tracket/features/authentication/services/firebase_auth_methods.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/constants/enums.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class PlayerOnboardingScreen extends StatefulWidget {
  const PlayerOnboardingScreen({super.key});

  @override
  State<PlayerOnboardingScreen> createState() => _PlayerOnboardingScreenState();
}

class _PlayerOnboardingScreenState extends State<PlayerOnboardingScreen> {
  final TextEditingController _nameController = TextEditingController();

  int _step = 0;
  bool _isSubmitting = false;

  CricketRole? _selectedRole;
  Position? _battingHand;
  _BowlingType? _bowlingType;
  Position? _standardPosition;

  @override
  void initState() {
    super.initState();
    final currentUserName = FirebaseAuth.instance.currentUser?.displayName;
    if (currentUserName != null && currentUserName.trim().isNotEmpty) {
      _nameController.text = currentUserName;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _canContinueStepOne => _nameController.text.trim().isNotEmpty;
  bool get _canContinueStepTwo => _selectedRole != null;
  bool get _canFinishStepThree =>
      _battingHand != null && _bowlingType != null && _standardPosition != null;

  void _goNext() {
    if (_step == 0 && !_canContinueStepOne) return;
    if (_step == 1 && !_canContinueStepTwo) return;
    if (_step < 2) {
      setState(() => _step += 1);
    }
  }

  Future<void> _finishOnboarding() async {
    if (!_canFinishStepThree || _isSubmitting) return;

    setState(() => _isSubmitting = true);
    try {
      await FirebaseAuthMethods().completePlayerOnboarding(
        playerName: _nameController.text.trim(),
        role: _selectedRole!,
        battingHand: _battingHand!,
        bowlingStyle: _mapBowlingType(_bowlingType!),
        standardPosition: _standardPosition!,
      );
    } catch (error) {
      if (!mounted) return;
      THelperFunction.showErrorSnackBar(error.toString(), context);
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  BowlingStyle _mapBowlingType(_BowlingType type) {
    switch (type) {
      case _BowlingType.pace:
        return BowlingStyle.mediumFast;
      case _BowlingType.spin:
        return BowlingStyle.offSpin;
      case _BowlingType.none:
        return BowlingStyle.none;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFF081512),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 70),
              _StepProgress(activeStep: _step),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.08)),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1A2D29), Color(0xFF0D1715)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.16),
                      blurRadius: 28,
                      spreadRadius: 1,
                      offset: const Offset(0, 14),
                    )
                  ],
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _buildStepContent(textTheme),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent(TextTheme textTheme) {
    if (_step == 0) {
      return _buildNameStep(textTheme);
    }
    if (_step == 1) {
      return _buildRoleStep(textTheme);
    }
    return _buildStyleStep(textTheme);
  }

  Widget _buildNameStep(TextTheme textTheme) {
    return Column(
      key: const ValueKey('name_step'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepIcon(icon: Icons.sports_cricket_rounded),
        const SizedBox(height: 20),
        Text(
          "What's your name on the sheet?",
          style: textTheme.headlineMedium
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Text(
          "This is how you'll appear in match reports.",
          style: textTheme.titleMedium
              ?.copyWith(color: Colors.white.withValues(alpha: 0.55)),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _nameController,
          onChanged: (_) => setState(() {}),
          style: textTheme.titleLarge?.copyWith(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Player name',
            hintStyle: textTheme.headlineSmall
                ?.copyWith(color: Colors.white.withValues(alpha: 0.25)),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: primaryMedium, width: 2),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: primaryLight, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 28),
        _PrimaryActionButton(
          label: 'Continue',
          isEnabled: _canContinueStepOne,
          onPressed: _goNext,
        ),
      ],
    );
  }

  Widget _buildRoleStep(TextTheme textTheme) {
    return Column(
      key: const ValueKey('role_step'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepIcon(icon: Icons.gps_fixed_rounded),
        const SizedBox(height: 20),
        Text(
          'Select your primary role.',
          style: textTheme.headlineMedium
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 20),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.05,
          children: [
            _RoleCard(
              icon: Icons.sports_cricket_rounded,
              title: 'Batter',
              subtitle: 'Top-order run machine',
              selected: _selectedRole == CricketRole.batsman,
              onTap: () => setState(() => _selectedRole = CricketRole.batsman),
            ),
            _RoleCard(
              icon: Icons.adjust_rounded,
              title: 'Bowler',
              subtitle: 'Wicket-taking threat',
              selected: _selectedRole == CricketRole.bowler,
              onTap: () => setState(() => _selectedRole = CricketRole.bowler),
            ),
            _RoleCard(
              icon: Icons.bolt_rounded,
              title: 'All-Rounder',
              subtitle: 'Impact with bat & ball',
              selected: _selectedRole == CricketRole.allRounder,
              onTap: () =>
                  setState(() => _selectedRole = CricketRole.allRounder),
            ),
            _RoleCard(
              icon: Icons.sports_handball_rounded,
              title: 'Keeper',
              subtitle: 'Behind the stumps',
              selected: _selectedRole == CricketRole.wicketKeeper,
              onTap: () =>
                  setState(() => _selectedRole = CricketRole.wicketKeeper),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _PrimaryActionButton(
          label: 'Continue',
          isEnabled: _canContinueStepTwo,
          onPressed: _goNext,
        ),
      ],
    );
  }

  Widget _buildStyleStep(TextTheme textTheme) {
    return Column(
      key: const ValueKey('style_step'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepIcon(icon: Icons.tune_rounded),
        const SizedBox(height: 20),
        Text(
          'Refine your style.',
          style: textTheme.headlineMedium
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          "Tap, don't type.",
          style: textTheme.titleMedium
              ?.copyWith(color: Colors.white.withValues(alpha: 0.55)),
        ),
        const SizedBox(height: 22),
        _SectionTitle(title: 'BATTING HAND'),
        const SizedBox(height: 10),
        _SegmentedToggle<Position>(
          options: const [
            _OptionLabel(value: Position.lefty, label: 'Left'),
            _OptionLabel(value: Position.righty, label: 'Right'),
          ],
          selected: _battingHand,
          onSelected: (value) => setState(() => _battingHand = value),
        ),
        const SizedBox(height: 22),
        _SectionTitle(title: 'BOWLING TYPE'),
        const SizedBox(height: 10),
        _SegmentedToggle<_BowlingType>(
          options: const [
            _OptionLabel(value: _BowlingType.pace, label: 'Pace'),
            _OptionLabel(value: _BowlingType.spin, label: 'Spin'),
            _OptionLabel(value: _BowlingType.none, label: 'N/A'),
          ],
          selected: _bowlingType,
          onSelected: (value) => setState(() => _bowlingType = value),
        ),
        const SizedBox(height: 22),
        _SectionTitle(title: 'STANDARD POSITION'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Position>(
              value: _standardPosition,
              hint: const Text('Select position',
                  style: TextStyle(color: Colors.white70)),
              iconEnabledColor: Colors.white70,
              dropdownColor: const Color(0xFF14211E),
              isExpanded: true,
              items: const [
                DropdownMenuItem(
                    value: Position.lefty,
                    child: Text('Left', style: TextStyle(color: Colors.white))),
                DropdownMenuItem(
                    value: Position.righty,
                    child:
                        Text('Right', style: TextStyle(color: Colors.white))),
              ],
              onChanged: (value) => setState(() => _standardPosition = value),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _PrimaryActionButton(
          label: 'Start Tracking 🏏',
          isEnabled: _canFinishStepThree,
          isLoading: _isSubmitting,
          onPressed: _finishOnboarding,
        ),
      ],
    );
  }
}

class _StepProgress extends StatelessWidget {
  const _StepProgress({required this.activeStep});

  final int activeStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        3,
        (index) => Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index == 2 ? 0 : 8),
            height: 4,
            decoration: BoxDecoration(
              color: index <= activeStep
                  ? primaryMedium
                  : Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}

class _StepIcon extends StatelessWidget {
  const _StepIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: primaryMedium,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({
    required this.label,
    required this.onPressed,
    this.isEnabled = true,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isEnabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: (isEnabled && !isLoading) ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          disabledBackgroundColor: primaryColor.withValues(alpha: 0.45),
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
            : Text(label,
                style: const TextStyle(
                    fontSize: 24 / 1.5, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected
              ? primaryColor.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                selected ? primaryMedium : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? primaryLight : Colors.white, size: 28),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.white.withValues(alpha: 0.55)),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.5),
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
    );
  }
}

class _SegmentedToggle<T> extends StatelessWidget {
  const _SegmentedToggle({
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<_OptionLabel<T>> options;
  final T? selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: options
            .map(
              (option) => Expanded(
                child: GestureDetector(
                  onTap: () => onSelected(option.value),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: selected == option.value
                          ? primaryColor
                          : Colors.transparent,
                    ),
                    child: Text(
                      option.label,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: selected == option.value
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _OptionLabel<T> {
  const _OptionLabel({required this.value, required this.label});

  final T value;
  final String label;
}

enum _BowlingType {
  pace,
  spin,
  none,
}
