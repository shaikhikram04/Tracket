import 'package:flutter/material.dart';
import 'package:tracket/matches/models/batting_score.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class WicketReason extends StatefulWidget {
  const WicketReason({super.key});

  @override
  State<WicketReason> createState() => _WicketReasonState();
}

class _WicketReasonState extends State<WicketReason> {
  int _selectedIndex = -1;
  ReasonOfOut? _reasonOfOut;
  int _runsCompleted = 0;
  String _runOutBy = '';
  String _caughtBy = '';

  void _onReasonSelected(int index) {
    setState(() {
      _selectedIndex = index;
      _reasonOfOut = ReasonOfOut.values[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How was the batsman dismissed?',
            style: MyTextStyle(context).titleMedium.copyWith(
                  color: darkGreenColor,
                  fontWeight: FontWeight.w800,
                ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: ReasonOfOut.values.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () => _onReasonSelected(index),
                child: Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: _selectedIndex == index
                        ? primaryMedium
                        : primaryMedium.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      ReasonOfOut.values[index].description,
                      style: MyTextStyle(context).bodyLarge.copyWith(
                            color: _selectedIndex == index
                                ? whiteColor
                                : darkGreenColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_reasonOfOut == ReasonOfOut.runOut)
            Row(
              children: [
                Text(
                  'Runs completed:  ',
                  style: MyTextStyle(context).bodyLarge.copyWith(
                        color: darkGreenColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
