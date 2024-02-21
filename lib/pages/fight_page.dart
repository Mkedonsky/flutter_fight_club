import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_result.dart';
import 'package:flutter_fight_club/resources/fight_club_icons.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import '../resources/fight_club_colors.dart';
import '../resources/fight_club_images.dart';
import '../widgets/action_button.dart';

class FightPage extends StatefulWidget {
  const FightPage({Key? key}) : super(key: key);

  @override
  FightPageState createState() => FightPageState();
}

class FightPageState extends State<FightPage> {
  static const maxLive = 5;

  BodyPart? defendingBodyPart;
  BodyPart? attackingBodyPart;
  BodyPart whatEnemyAttacks = BodyPart.random();
  BodyPart whatEnemyDefends = BodyPart.random();

  int yourLives = maxLive;
  int enemysLives = maxLive;

  String gameInfoText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: FightClubColors.background,
        body: SafeArea(
          child: Column(
            children: [
              FightersInfo(
                maxLivesCount: maxLive,
                yourLivesCount: yourLives,
                enemysLivesCount: enemysLives,
              ),
              const SizedBox(height: 30),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ColoredBox(
                  color: FightClubColors.backgroundGameInfo,
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(
                        child: Text(
                      gameInfoText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 10, color: FightClubColors.darkGreyText),
                    )),
                  ),
                ),
              )),
              const SizedBox(height: 30),
              ControlsWidget(
                defendingBodyPart: defendingBodyPart,
                selectDefendingBodyPart: _selectDefendingBodyPart,
                attackingBodyPart: attackingBodyPart,
                selectAttackingBodyPart: _selectAttackingBodyPart,
              ),
              SizedBox(height: 7),
              ActionButton(
                text: yourLives == 0 || enemysLives == 0 ? "Back" : "Go",
                onTap: _checkSelectAction,
                color: _changeColorButton(),
              ),
            ],
          ),
        ));
  }

  void _selectDefendingBodyPart(final BodyPart value) {
    if (yourLives == 0 || enemysLives == 0) {
      return;
    }
    setState(() {
      defendingBodyPart = value;
    });
  }

  void _selectAttackingBodyPart(final BodyPart value) {
    if (yourLives == 0 || enemysLives == 0) {
      return;
    }
    setState(() {
      attackingBodyPart = value;
    });
  }

  void _checkSelectAction() {
    if (yourLives == 0 || enemysLives == 0) {
      Navigator.of(context).pop();
    } else if (defendingBodyPart != null && attackingBodyPart != null) {
      setState(() {
        final bool enemyLoseLife = attackingBodyPart != whatEnemyDefends;
        final bool youLoseLife = defendingBodyPart != whatEnemyAttacks;

        if (enemyLoseLife) {
          enemysLives -= 1;
        }
        if (youLoseLife) {
          yourLives -= 1;
        }
        final FightResult? fightResult =
            FightResult.calculateResult(yourLives, enemysLives);
        if (fightResult != null) {

          SharedPreferences.getInstance().then((sharedPreferences) {
            sharedPreferences.setString(
                "last_fight_result", fightResult.result);
             String key = "stats_${fightResult.result.toLowerCase()}";
            final int currentValue = sharedPreferences.getInt(key) ?? 0;
            sharedPreferences.setInt(key, currentValue + 1);
          });
        }
        gameInfoText = _calculateGameInfoText(youLoseLife, enemyLoseLife);
        whatEnemyDefends = BodyPart.random();
        whatEnemyAttacks = BodyPart.random();

        defendingBodyPart = null;
        attackingBodyPart = null;
      });
    }
  }

  String _calculateGameInfoText(
      final bool youLoseLife, final bool enemyLoseLife) {
    if (enemysLives == 0 && yourLives == 0) {
      return "Draw";
    } else if (enemysLives == 0) {
      return "You won";
    } else if (yourLives == 0) {
      return "Enemy won";
    } else {
      final String first = enemyLoseLife
          ? "You hit enemy’s ${attackingBodyPart!.name.toLowerCase()}. "
          : "Your attack was blocked.";
      final String second = youLoseLife
          ? "Enemy hit your ${whatEnemyAttacks.name.toLowerCase()}. "
          : "Enemy’s attack was blocked.";

      return "$first\n$second";
    }
  }

  Color _changeColorButton() {
    if (yourLives == 0 || enemysLives == 0) {
      return FightClubColors.blackButton;
    } else if (attackingBodyPart == null || defendingBodyPart == null) {
      return FightClubColors.greyButton;
    } else {
      return FightClubColors.blackButton;
    }
  }
}

class FightersInfo extends StatelessWidget {
  final maxLivesCount;
  final yourLivesCount;
  final enemysLivesCount;

  const FightersInfo({
    Key? key,
    required this.maxLivesCount,
    required this.yourLivesCount,
    required this.enemysLivesCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: ColoredBox(color: FightClubColors.backgroundYouField)),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        FightClubColors.backgroundYouField,
                        FightClubColors.backgroundEnemyField
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                  child:
                      ColoredBox(color: FightClubColors.backgroundEnemyField)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              LivesWidget(
                  overallLivesCount: maxLivesCount,
                  currentLivesCount: yourLivesCount),
              Column(
                children: [
                  const SizedBox(height: 16),
                  Text("You",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: FightClubColors.darkGreyText)),
                  const SizedBox(height: 12),
                  Image.asset(
                    FightClubImages.youAvatar,
                    width: 93,
                    height: 93,
                  )
                ],
              ),
              SizedBox(
                height: 44,
                width: 44,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: FightClubColors.blueButton,
                  ),
                  child: Center(
                    child: Text(
                      "vs",
                      style: TextStyle(
                          color: FightClubColors.whiteText, fontSize: 16),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 16),
                  Text("Enemy",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: FightClubColors.darkGreyText)),
                  const SizedBox(height: 12),
                  Image.asset(
                    FightClubImages.enemyAvatar,
                    width: 93,
                    height: 93,
                  )
                ],
              ),
              LivesWidget(
                  overallLivesCount: maxLivesCount,
                  currentLivesCount: enemysLivesCount),
            ],
          ),
        ],
      ),
    );
  }
}

class LivesWidget extends StatelessWidget {
  final int overallLivesCount;
  final int currentLivesCount;

  const LivesWidget({
    Key? key,
    required this.overallLivesCount,
    required this.currentLivesCount,
  })  : assert(overallLivesCount >= 1),
        assert(currentLivesCount >= 0),
        assert(currentLivesCount <= overallLivesCount),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        overallLivesCount,
        (index) {
          if (index < currentLivesCount) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: index < overallLivesCount - 1 ? 4 : 0),
              child:
                  Image.asset(FightClubIcons.heartFull, width: 18, height: 18),
            );
          } else {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: index < overallLivesCount - 1 ? 4 : 0),
              child:
                  Image.asset(FightClubIcons.heartEmpty, width: 18, height: 18),
            );
          }
        },
      ),
    );
  }
}

class BodyPartButton extends StatelessWidget {
  final bool selected;
  final BodyPart bodyPart;
  final ValueSetter<BodyPart> bodyPartSetter;

  const BodyPartButton({
    Key? key,
    required this.bodyPart,
    required this.selected,
    required this.bodyPartSetter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: GestureDetector(
        onTap: () => bodyPartSetter(bodyPart),
        child: SizedBox(
          height: 40,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: selected ? FightClubColors.blueButton : Colors.transparent,
              border: !selected
                  ? Border.all(color: FightClubColors.darkGreyText, width: 2)
                  : null,
            ),
            child: Center(
              child: Text(
                bodyPart.name.toUpperCase(),
                style: TextStyle(
                  color: FightClubColors.darkGreyText,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BodyPart {
  final String name;

  const BodyPart._(this.name);

  static const head = BodyPart._("Head");
  static const torso = BodyPart._("Torso");
  static const legs = BodyPart._("Legs");

  @override
  String toString() {
    return 'BodyPart{name: $name}';
  }

  static const List<BodyPart> _values = [head, torso, legs];

  static BodyPart random() {
    return _values[Random().nextInt(_values.length)];
  }
}

class ControlsWidget extends StatelessWidget {
  final BodyPart? defendingBodyPart;
  final ValueSetter<BodyPart> selectDefendingBodyPart;

  final BodyPart? attackingBodyPart;
  final ValueSetter<BodyPart> selectAttackingBodyPart;

  const ControlsWidget({
    Key? key,
    required this.defendingBodyPart,
    required this.selectDefendingBodyPart,
    required this.attackingBodyPart,
    required this.selectAttackingBodyPart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              Text("Defend".toUpperCase(),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: FightClubColors.darkGreyText)),
              SizedBox(height: 9),
              BodyPartButton(
                  bodyPart: BodyPart.head,
                  selected: defendingBodyPart == BodyPart.head,
                  bodyPartSetter: selectDefendingBodyPart),
              BodyPartButton(
                  bodyPart: BodyPart.torso,
                  selected: defendingBodyPart == BodyPart.torso,
                  bodyPartSetter: selectDefendingBodyPart),
              BodyPartButton(
                  bodyPart: BodyPart.legs,
                  selected: defendingBodyPart == BodyPart.legs,
                  bodyPartSetter: selectDefendingBodyPart),
            ],
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              Text("Attack".toUpperCase(),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: FightClubColors.darkGreyText)),
              const SizedBox(height: 9),
              BodyPartButton(
                  bodyPart: BodyPart.head,
                  selected: attackingBodyPart == BodyPart.head,
                  bodyPartSetter: selectAttackingBodyPart),
              BodyPartButton(
                  bodyPart: BodyPart.torso,
                  selected: attackingBodyPart == BodyPart.torso,
                  bodyPartSetter: selectAttackingBodyPart),
              BodyPartButton(
                  bodyPart: BodyPart.legs,
                  selected: attackingBodyPart == BodyPart.legs,
                  bodyPartSetter: selectAttackingBodyPart),
            ],
          ),
        ),
        SizedBox(width: 16),
      ],
    );
  }
}
