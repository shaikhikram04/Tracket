import 'package:flutter/material.dart';
import 'package:tracket/utils/utils.dart';

// Design system constants
class AppTheme {
  static const primaryColor = Color(0xFF2196F3);
  static const secondaryColor = Color(0xFF4CAF50);
  static const errorColor = Color(0xFFE53935);
  static const backgroundColor = Color(0xFFF5F5F5);

  static const cardShadow = BoxShadow(
    color: Colors.black12,
    blurRadius: 10,
    offset: Offset(0, 4),
  );

  static const textTheme = TextTheme(
    headlineSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.15,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      letterSpacing: 0.25,
    ),
  );
}

// Animated action button
class AnimatedActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const AnimatedActionButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Challenge Card
class ChallengeCard extends StatefulWidget {
  final String teamAName;
  final String teamBName;
  final String teamALogo;
  final String teamBLogo;
  final DateTime matchDate;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onCancel;

  const ChallengeCard({
    Key? key,
    required this.teamAName,
    required this.teamBName,
    required this.teamALogo,
    required this.teamBLogo,
    required this.matchDate,
    required this.onAccept,
    required this.onReject,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<ChallengeCard> createState() => _ChallengeCardState();
}

class _ChallengeCardState extends State<ChallengeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: _isHovered ? 20 : 10,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getCircleAvatar(
                        url: widget.teamALogo, isTeam: true, radius: 24),
                    const SizedBox(width: 16),
                    Text(
                      "VS",
                      style: AppTheme.textTheme.titleMedium,
                    ),
                    const SizedBox(width: 16),
                    getCircleAvatar(
                        url: widget.teamBLogo, isTeam: true, radius: 24),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.teamAName,
                      style: AppTheme.textTheme.titleMedium,
                    ),
                    Text(
                      widget.teamBName,
                      style: AppTheme.textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      "${widget.matchDate.day}/${widget.matchDate.month}/${widget.matchDate.year}",
                      style: AppTheme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AnimatedActionButton(
                      label: "Accept",
                      icon: Icons.check_circle_outline,
                      color: AppTheme.secondaryColor,
                      onPressed: widget.onAccept,
                    ),
                    AnimatedActionButton(
                      label: "Reject",
                      icon: Icons.cancel_outlined,
                      color: AppTheme.errorColor,
                      onPressed: widget.onReject,
                    ),
                    AnimatedActionButton(
                      label: "Cancel",
                      icon: Icons.close,
                      color: Colors.grey,
                      onPressed: widget.onCancel,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Request Card
class RequestCard extends StatefulWidget {
  final String userName;
  final String userAvatar;
  final String requestType; // "Player" or "Team"
  final String teamName;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const RequestCard({
    Key? key,
    required this.userName,
    required this.userAvatar,
    required this.requestType,
    required this.teamName,
    required this.onAccept,
    required this.onReject,
  }) : super(key: key);

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: _isHovered ? 20 : 10,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(widget.userAvatar),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userName,
                            style: AppTheme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${widget.requestType} Join Request",
                            style: AppTheme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (widget.teamName.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      widget.teamName,
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedActionButton(
                      label: "Accept",
                      icon: Icons.check_circle_outline,
                      color: AppTheme.secondaryColor,
                      onPressed: widget.onAccept,
                    ),
                    const SizedBox(width: 12),
                    AnimatedActionButton(
                      label: "Reject",
                      icon: Icons.cancel_outlined,
                      color: AppTheme.errorColor,
                      onPressed: widget.onReject,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Example usage
class ExampleScreen extends StatelessWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ChallengeCard(
              teamAName: "Team Alpha",
              teamBName: "Team Beta",
              teamALogo: "https://example.com/team-a-logo.png",
              teamBLogo: "https://example.com/team-b-logo.png",
              matchDate: DateTime.now(),
              onAccept: () {},
              onReject: () {},
              onCancel: () {},
            ),
            const SizedBox(height: 16),
            RequestCard(
              userName: "John Doe",
              userAvatar: "https://example.com/user-avatar.png",
              requestType: "Player",
              teamName: "Team Alpha",
              onAccept: () {},
              onReject: () {},
            ),
          ],
        ),
      ),
    );
  }
}
