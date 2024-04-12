import 'package:flutter/material.dart';
import 'package:fitness/common_widget/meal_recommed_cell.dart';
import '../../common/colo_extension.dart';
import '../../common_widget/today_meal_row.dart';

class MealPlannerView extends StatefulWidget {
  const MealPlannerView({Key? key});

  @override
  State<MealPlannerView> createState() => _MealPlannerViewState();
}

class _MealPlannerViewState extends State<MealPlannerView> {
  List<Map<String, dynamic>> recommendArr = [
    {
      "name": "Honey Pancake",
      "image": "assets/img/rd_1.png",
      "kcal": "180kCal",
    },
    {
      "name": "Canai Bread",
      "image": "assets/img/m_4.png",
      "kcal": "230kCal",
    },
  ];

  List<Map<String, dynamic>> todayMealArr = [];

  void addToTodayMeal(int index) {
    setState(() {
      todayMealArr.add(recommendArr[index]);
    });
  }

  void deleteFromTodayMeal(int index) {
    setState(() {
      todayMealArr.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset(
              "assets/img/black_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          "Meal Planner",
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today Meals",
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: todayMealArr.length,
                      itemBuilder: (context, index) {
                        var mObj = todayMealArr[index];
                        return TodayMealRow(
                          mObj: mObj,
                          onDelete: () {
                            deleteFromTodayMeal(index);
                          },
                        );
                      }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Your meals",
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: media.width * 0.6,
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: recommendArr.length,
                  itemBuilder: (context, index) {
                    var fObj = recommendArr[index];
                    return MealRecommendCell(
                      fObj: fObj,
                      index: index,
                      onAddToToday: () {
                        addToTodayMeal(index);
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
