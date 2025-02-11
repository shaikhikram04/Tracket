import 'package:flutter/material.dart';
import 'package:tracket/matches/models/batting_score.dart';
import 'package:tracket/teams/widgets/capacity_selector.dart';
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
    return SingleChildScrollView(
      child: Padding(
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
            Column(
              children: [
                ...List.generate(
                  ReasonOfOut.values.length,
                  (index) => InkWell(
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
              ],
            ),
            if (_reasonOfOut == ReasonOfOut.runOut) ...[
              SizedBox(height: 10),
              CapacitySelector(
                capacity: _runsCompleted,
                onIncrement: () {
                  if (_runsCompleted < 3) {
                    setState(() {
                      _runsCompleted++;
                    });
                  }
                },
                onDecrement: () {
                  if (_runsCompleted > 0) {
                    setState(() {
                      _runsCompleted--;
                    });
                  }
                },
                label: 'Runs completed',
                labelColor: darkGreenColor,
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  'Run out by: ',
                  style: MyTextStyle(context).bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: darkGreenColor,
                      ),
                ),
              ),
              SizedBox(height: 2),
              TextField(
                decoration: InputDecoration(
                  hintText: "Enter fielder's name",
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            ],
            if (_reasonOfOut == ReasonOfOut.caught) ...[
              SizedBox(height: 10),
              Text(
                'Caught by: ',
                style: MyTextStyle(context).bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: darkGreenColor,
                    ),
              ),
              SizedBox(height: 2),
              TextField(
                decoration: InputDecoration(
                  hintText: "Enter fielder's name",
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            ],
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: darkGreenColor),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.clear, color: blackColor),
                          SizedBox(width: 10),
                          Text(
                            'Cancel',
                            style: MyTextStyle(context).bodyLarge.copyWith(
                                  color: blackColor,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: darkGreenColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check, color: whiteColor),
                          SizedBox(width: 10),
                          Text(
                            'Confirm',
                            style: MyTextStyle(context).bodyLarge.copyWith(
                                  color: whiteColor,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
