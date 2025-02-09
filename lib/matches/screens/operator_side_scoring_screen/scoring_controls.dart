import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracket/utils/colors.dart';
import 'package:tracket/utils/utility_classes/my_elevated_button.dart';
import 'package:tracket/utils/utility_classes/my_text_style.dart';

class ScoringControls extends ConsumerWidget {
  const ScoringControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Runs Grid
          Row(
            children: [0, 1, 2, 3].map((runs) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.all(5),
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lightGreen,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      '$runs',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          Row(
            children: List.generate(3, (index) {
              int runs = index < 2 ? 4 : 6;
              return Expanded(
                child: Container(
                  margin: EdgeInsets.all(5),
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: index == 0 ? lightGreen : darkGreenColor,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      '$runs',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 25),

          // Extras Wrap
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: ['Wide', 'No Ball', 'Leg Bye', 'Bye'].map((extra) {
              return ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentGold,
                  elevation: 2,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  extra,
                  style: GoogleFonts.poppins(
                    color: blackColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 25),

          // Wicket Button
          MyElevatedButton.iconTextElevatedButton(
            onPressed: () {},
            text: 'WICKET',
            textStyle: MyTextStyle(context).buttonText.copyWith(
                  letterSpacing: 1.2,
                  fontSize: 18,
                ),
            icon: Icon(
              Icons.sports_cricket,
              color: whiteColor,
            ),
            backgroundColor: Colors.red.shade600,
            borderRadius: 15,
            height: 50,
            width: double.infinity,
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}
