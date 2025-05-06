import 'package:flutter/material.dart';
import 'package:tracket/common/widgets/custom_widgets/my_card.dart';
import 'package:tracket/common/widgets/stats_widget/stat_data.dart';
import 'package:tracket/utils/constants/colors.dart';
import 'package:tracket/utils/helpers/helping_function.dart';

class StatBasicCard extends StatefulWidget {
  final Map<String, Map<String, int>> statsData;

  const StatBasicCard({
    Key? key,
    required this.statsData,
  }) : super(key: key);

  @override
  State<StatBasicCard> createState() => _PlayerStatBasicCard();
}

class _PlayerStatBasicCard extends State<StatBasicCard> {
  // Selected format index (default to ODI/50 overs)
  int _selectedFormatIndex = 2;

  // Available formats
  final List<String> _formats = ['T5', 'T10', 'T20', 'ODI', 'Test'];

  final _statsColorLight = <Color>[
    secondaryLight,
    primaryLight,
    Colors.redAccent,
    Colors.orangeAccent,
  ];

  final _statsColorDark = <Color>[
    secondaryColor,
    primaryColor,
    Colors.red,
    Colors.orange,
  ];

  Color _getStatsColor(String key, bool isDark) {
    switch (key) {
      case "matches":
        return !isDark ? _statsColorDark[0] : _statsColorLight[0];
      case "wins":
      case "runs":
        return !isDark ? _statsColorDark[1] : _statsColorLight[1];
      case "losses":
      case "wickets":
        return !isDark ? _statsColorDark[2] : _statsColorLight[2];
      case "ties":
        return !isDark ? _statsColorDark[3] : _statsColorLight[3];

      default:
        return !isDark ? _statsColorDark[1] : _statsColorLight[1];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedStats = widget.statsData[_formats[_selectedFormatIndex]];

    return MyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Player Statistics',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 22,
                    color: isDark ? primaryLight : primaryColor,
                  ),
            ),
          ),
          const SizedBox(height: 16),

          // Format selector - Segmented Buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_formats.length, (index) {
                final isSelected = _selectedFormatIndex == index;
                return Padding(
                  padding: EdgeInsets.only(
                      right: index < _formats.length - 1 ? 8 : 0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedFormatIndex = index;
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? primaryColor : primaryLight)
                            : (isDark ? Colors.grey[800] : Colors.grey[200]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _formats[index],
                        style: TextStyle(
                          color: isSelected
                              ? (isDark ? Colors.black : Colors.white)
                              : (isDark ? Colors.white70 : Colors.black87),
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 20),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final stats in selectedStats!.entries)
                StatsData(
                  number: stats.value,
                  label: THelperFunction.makeFirstLetterUpperCase(stats.key),
                  numColor: _getStatsColor(stats.key, isDark),
                  labelStyle: Theme.of(context).textTheme.bodyLarge,
                ),
            ],
          ),

          // Format details label
          const SizedBox(height: 16),
          Center(
            child: Text(
              _getFormatFullName(),
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[700],
                fontStyle: FontStyle.italic,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get the full format name
  String _getFormatFullName() {
    switch (_formats[_selectedFormatIndex]) {
      case 'T5':
        return '5 Overs Format';
      case 'T10':
        return '10 Overs Format';
      case 'T20':
        return 'Twenty20 Format';
      case 'ODI':
        return 'One Day International (50 Overs)';
      case 'Test':
        return 'Test Cricket';
      default:
        return '50 Overs Format';
    }
  }
}
