import 'package:flutter/material.dart';
import 'package:grow/features/Home/data/modle/weather_modle.dart';

class WeatherBodyCubit extends StatelessWidget {
  const WeatherBodyCubit({super.key, required this.weather});
  final WeatherModel weather;
  @override
  Widget build(BuildContext context) {
    return Container(
              width: double.infinity,
              height: 230,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage(
                    'images/Frame.png',
                  ), // صورة الخلفية
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 56,
                    left: 20,
                    child: Text(
                      '${weather.temp.toInt()}°',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 20,
                    child: SizedBox(
                      width:300,
                      child: Row(
                        children: [
                          Text(
                            '${weather.country}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                      
                          Text(
                            ',${weather.city}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          Spacer(),
                          Text(
                            '${weather.description}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
  }
}