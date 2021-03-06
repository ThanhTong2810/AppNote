import 'package:app_note/controller/note_controller.dart';
import 'package:app_note/controller/user_controller.dart';
import 'package:app_note/theme/colors.dart';
import 'package:app_note/theme/dimens.dart';
import 'package:app_note/widget/animate_menu.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


final Screen myDashBoardScreen =  Screen(
    title: 'Dash Board Screen',
    contentBuilder: (BuildContext context) {
      return DashBoardScreen();
    });

class DashBoardScreen extends StatefulWidget {
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final NoteController noteController=Get.find();
  final UserController userController=Get.find();
  int touchedIndex;

  @override
  void initState() {
    noteController.getNote(userController.user.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Dimens.quarterHeight(context),
          AspectRatio(
            aspectRatio: 1.8,
            child: Row(
              children: <Widget>[
                const SizedBox(
                  height: 18,
                ),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                          pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                            setState(() {
                              if (pieTouchResponse.touchInput is FlLongPressEnd ||
                                  pieTouchResponse.touchInput is FlPanEnd) {
                                touchedIndex = -1;
                              } else {
                                touchedIndex = pieTouchResponse.touchedSectionIndex;
                              }
                            });
                          }),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 50,
                          sections: showingSections()),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Indicator(
                      color: AppColors.clickableText,
                      text: 'Done',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: AppColors.yellow,
                      text: 'Processing',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: AppColors.red,
                      text: 'Pending',
                      isSquare: true,
                    ),
                    SizedBox(
                      height: 18,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 28,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: AppColors.clickableText,
            value: ((noteController.doneLength.value/noteController.listNotes.length)*100).roundToDouble(),
            title: '${((noteController.doneLength.value/noteController.listNotes.length)*100).roundToDouble()==0.0?'':((noteController.doneLength.value/noteController.listNotes.length)*100).roundToDouble()}%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: AppColors.yellow,
            value: ((noteController.processingLength.value/noteController.listNotes.length)*100).roundToDouble(),
            title: '${((noteController.processingLength.value/noteController.listNotes.length)*100).roundToDouble()==0.0?'':'${((noteController.processingLength.value/noteController.listNotes.length)*100).roundToDouble()}%'}',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: AppColors.red,
            value: ((noteController.pendingLength.value/noteController.listNotes.length)*100).roundToDouble(),
            title: '${((noteController.pendingLength.value/noteController.listNotes.length)*100).roundToDouble()==0.0?'':'${((noteController.pendingLength.value/noteController.listNotes.length)*100).roundToDouble()}%'}',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        default:
          return null;
      }
    });
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key key,
    this.color,
    this.text,
    this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}
