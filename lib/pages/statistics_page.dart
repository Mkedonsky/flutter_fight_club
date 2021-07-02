import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_result.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/widgets/fight_result_widget.dart';
import 'package:flutter_fight_club/widgets/secondary_action_button.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _StatisticsPageContent();
  }
}

class _StatisticsPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 16, right: 16, top: 24),
              alignment: Alignment.center,
              child: Text(
                "Statistics",
                style: TextStyle(
                    color: FightClubColors.darkGreyText,
                    fontWeight: FontWeight.w400,
                    fontSize: 24),
              ),
            ),
            Expanded(
              child: const SizedBox(),
            ),
            FutureBuilder<SharedPreferences>(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const SizedBox();
                }
                final SharedPreferences sp = snapshot.data!;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Won: ${sp.getInt("stats_won") ?? 0}",
                      style: TextStyle(
                        fontSize: 16,
                        color: FightClubColors.darkGreyText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Lost: ${sp.getInt("stats_lost") ?? 0}",
                      style: TextStyle(
                        fontSize: 16,
                        color: FightClubColors.darkGreyText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Draw: ${sp.getInt("stats_draw") ?? 0}",
                      style: TextStyle(
                        fontSize: 16,
                        color: FightClubColors.darkGreyText,
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                );
              },
            ),
            Expanded(
              child: const SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SecondaryActionButton(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  text: "back"),
            )
          ],
        ),
      ),
    );
  }
}
