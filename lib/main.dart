
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_club_colors.dart';
import 'package:flutter_fight_club/fight_club_icons.dart';
import 'package:flutter_fight_club/fight_club_images.dart';
import 'package:google_fonts/google_fonts.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.pressStart2pTextTheme(
          Theme
              .of(context)
              .textTheme,
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  static const maxLive = 5;

  BodyPart? defendingBodyPart;
  BodyPart? attackingBodyPart;
  BodyPart whatEnemyAttacks = BodyPart.random();
  BodyPart whatEnemyDefends = BodyPart.random();

  int yourLives = maxLive;
  int enemysLives = maxLive;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: FightClubColors.background,
        body: SafeArea(
          child: Column(
            children: [
              Stack(
                children: [

                  Align(
                      alignment: Alignment.topCenter,
                      child: FieldWidget()),
                  Align(
                    alignment: Alignment.topCenter,
                    child: FightersInfo(
                      maxLivesCount: maxLive,
                      yourLivesCount: yourLives,
                      enemysLivesCount: enemysLives,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30,),
                  
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        child: ColoredBox(color: FightClubColors.backgroundGameInfo,
                          child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                // child: Text(_checkWin()),
                              )),
                          // children: [
                          //       Center(
                          //       child: Padding(
                          //         padding: const EdgeInsets.symmetric(vertical: 2),
                          //         // child: Text(_infoAttacking()),
                          //       )),
                          //     ],
                                  // child: Text(_infoDefending()),
                          
                          
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(child: SizedBox(height: 30,)),
              ControlsWidget(
                defendingBodyPart: defendingBodyPart,
                selectDefendingBodyPart: _selectDefendingBodyPart,
                attackingBodyPart: attackingBodyPart,
                selectAttackingBodyPart: _selectAttackingBodyPart,
              ),
              SizedBox(height: 7),
              GoButton(
                text: yourLives == 0 || enemysLives == 0
                    ? " Start new game"
                    : "Go",
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
      setState(() {
        yourLives = maxLive;
        enemysLives = maxLive;
      });
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

        whatEnemyDefends = BodyPart.random();
        whatEnemyAttacks = BodyPart.random();

        defendingBodyPart = null;
        attackingBodyPart = null;
      });
    }
  }

  // _checkWin() {
  //   String i = " ";
  //   if (yourLives == 0 && enemysLives == 0) {
  //     return i = "Draw";
  //   } else if (enemysLives == 0 && yourLives > 0) {
  //     return i = "You won";
  //   } else if (enemysLives > 0 && yourLives == 0) {
  //     return i = "Enemy won";
  //   }
  //   return i;
  // }

  // _infoDefending() {
  //   String i = " ";
  //   if (yourLives != 0 && enemysLives != 0) {
  //     if (defendingBodyPart == whatEnemyAttacks) {
  //       return i = "Enemy’s attack\n was blocked.";
  //     } else {
  //       return i = "Enemy hit your\n " + whatEnemyAttacks.name + ".";
  //     }
  //   }
  //   return i;
  // }
  //
  // _infoAttacking() {
  //   String i = " ";
  //   if (yourLives != 0 && enemysLives != 0) {
  //     if (attackingBodyPart == whatEnemyDefends) {
  //       return i = "Your attack was blocked.";
  //     } else {
  //       return i = "You hit enemy’s\n ${attackingBodyPart.toString()}.";
  //     }
  //   }
  //   return i;
  // }

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

class FieldWidget extends StatelessWidget {
  const FieldWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ColoredBox(
            color: FightClubColors.backgroundYouField,
            child: SizedBox(height: 160),
          ),
        ),
        Expanded(
          child: ColoredBox(
            color: FightClubColors.backgroundEnemyField,
            child: SizedBox(height: 160),
          ),
        )
      ],
    );
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
      child: Row(
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
          ColoredBox(
            color: Colors.green,
            child: SizedBox(height: 44, width: 44),
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
          child: ColoredBox(
            color: selected
                ? FightClubColors.blueButton
                : FightClubColors.greyButton,
            child: Center(
              child: Text(
                bodyPart.name.toUpperCase(),
                style: TextStyle(color: FightClubColors.darkGreyText),
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

class LivesWidget extends StatelessWidget {
  final int overallLivesCount;
  final int currentLivesCount;

  const LivesWidget({
    Key? key,
    required this.overallLivesCount,
    required this.currentLivesCount,
  })
      : assert(overallLivesCount >= 1),
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
              padding: const EdgeInsets.symmetric(vertical: 2),
              child:
              Image.asset(FightClubIcons.heartFull, width: 18, height: 18),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child:
              Image.asset(FightClubIcons.heartEmpty, width: 18, height: 18),
            );
          }
        },
      ),
    );
  }
}

class GoButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final Color color;

  const GoButton(
      {Key? key, required this.onTap, required this.color, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: 40,
          child: ColoredBox(
            color: color,
            child: Center(
              child: Text(
                text.toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: FightClubColors.whiteText),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
