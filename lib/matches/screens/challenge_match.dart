import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utils.dart';
import 'package:tracket/widgets/custom_widgets/my_card.dart';
import 'package:tracket/widgets/custom_widgets/my_dropdown_menu.dart';
import 'package:tracket/utils/utility_classes/my_elevated_button.dart';
import 'package:tracket/widgets/custom_widgets/my_text_field.dart';

class CreateMatchScreen extends StatefulWidget {
  const CreateMatchScreen({super.key});

  @override
  State<CreateMatchScreen> createState() => _CreateMatchScreenState();
}

extension TimeOfDayToString on TimeOfDay {
  String formatToString() {
    final hourString = hour.toString().padLeft(2, '0');
    final minuteString = minute.toString().padLeft(2, '0');
    return '$hourString:$minuteString';
  }
}

class _CreateMatchScreenState extends State<CreateMatchScreen> {
  double noOfPlayers = 7;
  bool allowSpectators = true;
  DateTime matchDate = DateTime.now();
  TimeOfDay matchTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenge Match'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              //! Match detail
              MyCard(
                child: Column(
                  spacing: 20,
                  children: [
                    getTitleText('Match Details', context),
                    Column(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'No of players : ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                              TextSpan(
                                text: '$noOfPlayers',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: darkGreenColor),
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const Text('5'),
                            Expanded(
                              child: Slider(
                                min: 5,
                                max: 11,
                                value: noOfPlayers,
                                divisions: 6,
                                label: '$noOfPlayers',
                                onChanged: (value) {
                                  setState(() {
                                    noOfPlayers = value;
                                  });
                                },
                              ),
                            ),
                            const Text('11'),
                          ],
                        ),
                      ],
                    ),
                    MyDropdownMenu(
                      options: const [
                        '5 Overs',
                        '10 Overs',
                        '20 Overs',
                        '50 Overs'
                      ],
                      label: 'Numbers of overs',
                      onSelect: (value) {},
                    ),
                    MyDropdownMenu(
                      options: const ['friendly', 'practice', 'challanged'],
                      label: 'Match Type',
                      onSelect: (value) {},
                    ),
                    SwitchListTile(
                      value: allowSpectators,
                      title: Text(
                        'Allow Spectators',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.black, fontSize: 17),
                      ),
                      subtitle: const Text(
                        'Any one can see this match',
                      ),
                      activeColor: enableSwitchColor,
                      onChanged: (value) {
                        setState(() {
                          allowSpectators = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              //! Match Venue
              MyCard(
                child: Column(
                  spacing: 20,
                  children: [
                    getTitleText('Schedule & Venue Detail', context),
                    Row(
                      children: [
                        _getScheduleContainer(
                            DateFormat.yMMMd().format(matchDate)),
                        const SizedBox(width: 10),
                        _getScheduleContainer(
                          MaterialLocalizations.of(context)
                              .formatTimeOfDay(matchTime),
                        ),
                        IconButton(
                          onPressed: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(DateTime.now().year + 1),
                              initialDate: DateTime.now(),
                            );

                            if (!context.mounted) return;
                            final selectedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            setState(() {
                              matchDate = selectedDate ?? matchDate;
                              matchTime = selectedTime ?? matchTime;
                            });
                          },
                          icon: const Icon(Icons.date_range_outlined),
                          iconSize: 30,
                        )
                      ],
                    ),
                    MyTextField(
                      onSave: (value) {},
                      label: 'Venue',
                      borderRadius: 15,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: MyElevatedButton.primaryElevatedButton(
                    context,
                    isSubmit: true,
                    text: 'Create Match',
                    onPressed: () {},
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getScheduleContainer(String scheduleText) {
    return Expanded(
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: blackColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Align(
          alignment: const Alignment(-0.8, 0),
          child: Text(scheduleText),
        ),
      ),
    );
  }
}
