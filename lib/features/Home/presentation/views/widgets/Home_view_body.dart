import 'package:flutter/material.dart';
import 'package:grow/features/Home/presentation/views/widgets/detalis_screen_apple.dart';
import 'package:grow/features/Home/presentation/views/widgets/detalis_screen_bananas.dart';
import 'package:grow/features/Home/presentation/views/widgets/detalis_screen_rice.dart';
import 'package:grow/features/Home/presentation/views/widgets/detalis_screen_corn.dart';
import 'package:grow/features/Home/presentation/views/widgets/weather_body.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            WeatherBody(),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DetalisScreenCorn()));
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 160,
                          height: 205,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              image: const DecorationImage(
                                image: AssetImage(
                                  'images/Rectangle 4343.png',
                                ),
                              )),
                        ),
                        SizedBox(height: 7),
                        Container(
                          width: 158,
                          height: 40,
                          color: Color(0xffCCEADA),
                          child: Center(
                            child: Text(
                              'corns',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DetalisScreenRice()));
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 160,
                          height: 205,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              image: const DecorationImage(
                                image: AssetImage(
                                  'images/Rectangle 4344.png',
                                ),
                              )),
                        ),
                        SizedBox(height: 7),
                        Container(
                          width: 158,
                          height: 40,
                          color: Color(0xffCCEADA),
                          child: Center(
                            child: Text(
                              'Rice',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DetalisScreenBananas()));
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 160,
                          height: 205,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              image: const DecorationImage(
                                image: AssetImage(
                                  'images/Rectangle 4345.png',
                                ),
                              )),
                        ),
                        SizedBox(height: 7),
                        Container(
                          width: 158,
                          height: 40,
                          color: Color(0xffCCEADA),
                          child: Center(
                            child: Text(
                              'Banana',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DetalisScreenApple()));
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 160,
                          height: 205,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              image: const DecorationImage(
                                image: AssetImage(
                                  'images/Rectangle 4346 (1).png',
                                ),
                              )),
                        ),
                        SizedBox(height: 7),
                        Container(
                          width: 158,
                          height: 40,
                          color: Color(0xffCCEADA),
                          child: Center(
                            child: Text(
                              'Apple',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
