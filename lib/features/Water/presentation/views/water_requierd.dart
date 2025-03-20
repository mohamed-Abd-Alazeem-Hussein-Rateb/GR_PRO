import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WaterRequired extends StatefulWidget {
  const WaterRequired({super.key});

  @override
  State<WaterRequired> createState() => _WaterRequiredState();
}

class _WaterRequiredState extends State<WaterRequired> {
  String? selectedCrop;
  String? selectedSoil;
  double waterRequired = 0.0;
  String locationName = '';
  bool isLoading = false;
  TextEditingController cityController = TextEditingController();
  Position? currentPosition;

  final List<String> cropTypes = [
    'BANANA',
    'SOYABEAN',
    'CABBAGE',
    'POTATO',
    'RICE',
    'MELON',
    'MAIZE',
    'CITRUS',
    'BEAN',
    'WHEAT',
    'MUSTARD',
    'COTTON',
    'SUGARCANE',
    'TOMATO',
    'ONION'
  ];

  final List<String> soilTypes = ['DRY', 'WET', 'MOIST'];

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions permanently denied';
      }

      currentPosition = await Geolocator.getCurrentPosition();
    } catch (e) {
      throw 'Error getting location: ${e.toString()}';
    }
  }

  Future<void> calculateWaterRequirement() async {
    if (selectedCrop == null || selectedSoil == null) {
      _showErrorDialog('الرجاء اختيار نوع المحصول ونوع التربة');
      return;
    }

    setState(() {
      isLoading = true;
      waterRequired = 0.0;
      locationName = '';
    });

    try {
      Map<String, dynamic> requestData = {
        'crop_type': selectedCrop,
        'soil_type': selectedSoil,
      };

      if (cityController.text.isNotEmpty) {
        requestData['city'] = cityController.text;
      } else {
        await _getCurrentLocation();
        requestData['latitude'] = currentPosition!.latitude;
        requestData['longitude'] = currentPosition!.longitude;
      }

      final response = await http
          .post(
            Uri.parse('http://192.168.1.2:5000/predict'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(requestData),
          )
          .timeout(const Duration(seconds: 15));

      final responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          waterRequired = responseBody['water_required'];
          locationName = responseBody['location'] ?? 'Unknown location';
        });
      } else {
        final errorMessage =
            responseBody['message'] ?? 'Unknown error occurred';
        throw errorMessage;
      }
    } on SocketException {
      _showErrorDialog('لا يوجد اتصال بالإنترنت');
    } on TimeoutException {
      _showErrorDialog('انتهى وقت الانتظار');
    } on http.ClientException catch (e) {
      _showErrorDialog('خطأ في الاتصال: ${e.message}');
    } catch (e) {
      _showErrorDialog(_translateError(e.toString()));
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('خطأ'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('حسناً'),
          )
        ],
      ),
    );
  }

  String _translateError(String error) {
    final translations = {
      'City not found': 'المدينة غير موجودة',
      'Invalid city data': 'بيانات المدينة غير صالحة',
      'Failed to fetch weather data': 'فشل في جلب بيانات الطقس',
      'Internal server error': 'خطأ في الخادم',
      'Missing required fields': 'الحقول المطلوبة مفقودة',
      'Invalid selection': 'اختيار غير صالح',
      'city not found': 'المدينة غير موجودة', // إضافة ترجمة جديدة
      'No data provided': 'لم يتم تقديم بيانات',
      'Missing coordinates': 'الإحداثيات مفقودة',
    };

    return translations[error] ?? error;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.green[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: 20,
          ),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.02),
              _buildTitle(screenWidth),
              SizedBox(height: screenHeight * 0.03),
              _buildCitySearch(),
              SizedBox(height: screenHeight * 0.03),
              _buildCropDropdown(),
              SizedBox(height: screenHeight * 0.04),
              _buildSoilDropdown(),
              SizedBox(height: screenHeight * 0.03),
              _buildPredictionSection(),
              SizedBox(height: screenHeight * 0.03),
              _buildWaterRequiredDisplay(),
              SizedBox(height: screenHeight * 0.04),
              _buildCalculateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(double screenWidth) {
    return Column(
      children: [
        Text(
          'Crop Water ',
          style: TextStyle(
            fontSize: screenWidth * 0.08,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        Text(
          'Requirement',
          style: TextStyle(
            fontSize: screenWidth * 0.08,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
      ],
    );
  }

  Widget _buildCitySearch() {
    return TextField(
      controller: cityController,
      decoration: InputDecoration(
        labelText: 'Search by City',
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.search),
      ),
    );
  }

  Widget _buildCropDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'CROP TYPE',
        border: const OutlineInputBorder(),
      ),
      value: selectedCrop,
      items: cropTypes.map((crop) {
        return DropdownMenuItem<String>(
          value: crop,
          child: Text(crop),
        );
      }).toList(),
      onChanged: (value) => setState(() => selectedCrop = value),
    );
  }

  Widget _buildSoilDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'SOIL TYPE',
        border: const OutlineInputBorder(),
      ),
      value: selectedSoil,
      items: soilTypes.map((soil) {
        return DropdownMenuItem<String>(
          value: soil,
          child: Text(soil),
        );
      }).toList(),
      onChanged: (value) => setState(() => selectedSoil = value),
    );
  }

  Widget _buildPredictionSection() {
    return Column(
      children: [
        Text(
          'Prediction',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        if (locationName.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Location: $locationName',
              style: const TextStyle(fontSize: 16),
            ),
          ),
      ],
    );
  }

  Widget _buildWaterRequiredDisplay() {
    return Column(
      children: [
        const Text(
          'Water Required:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        isLoading
            ? const CircularProgressIndicator()
            : Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue[100],
                  border: Border.all(color: Colors.green, width: 4),
                ),
                child: Center(
                  child: Text(
                    '${waterRequired.toStringAsFixed(2)} units',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildCalculateButton() {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff388E3C),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: isLoading ? null : calculateWaterRequirement,
        child: const Text(
          'احسب كمية المياه',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
