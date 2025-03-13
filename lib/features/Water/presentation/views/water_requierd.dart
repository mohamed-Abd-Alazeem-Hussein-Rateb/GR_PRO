import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class WaterRequierd extends StatefulWidget {
  const WaterRequierd({super.key});

  @override
  State<WaterRequierd> createState() => _WaterRequierdState();
}

class _WaterRequierdState extends State<WaterRequierd> {
  String? selectedCrop;
  String? selectedSoil;
  double waterRequired = 0.0;
  String locationName = '';
  bool isLoading = false;
  TextEditingController cityController = TextEditingController();
  Position? currentPosition;

  final List<String> cropTypes = [
    'BANANA', 'SOYABEAN', 'CABBAGE', 'POTATO', 'RICE', 'MELON',
    'MAIZE', 'CITRUS', 'BEAN', 'WHEAT', 'MUSTARD', 'COTTON',
    'SUGARCANE', 'TOMATO', 'ONION'
  ];

  final List<String> soilTypes = ['DRY', 'WET', 'MOIST'];

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    currentPosition = await Geolocator.getCurrentPosition();
  }

  Future<void> calculateWaterRequirement() async {
    setState(() {
      isLoading = true;
      waterRequired = 0.0;
      locationName = cityController.text.isNotEmpty ? cityController.text : '';
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

      final response = await http.post(
        Uri.parse('http://192.168.1.5:5000/predict'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          waterRequired = data['water_required'];
          if (cityController.text.isEmpty) {
            locationName = data['location'];
          }
        });
      } else {
        throw Exception('Failed to get prediction');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('OK'),
            )
          ],
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
              _buildPredictionSection(context, screenWidth, screenHeight),
              SizedBox(height: screenHeight * 0.03),
              _buildWaterRequiredDisplay(screenWidth, screenHeight),
              SizedBox(height: screenHeight * 0.04),
              _buildCalculateButton(screenWidth, screenHeight),
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
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.search),
      ),
    );
  }

  Widget _buildCropDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'CROP TYPE',
        border: OutlineInputBorder(),
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
        border: OutlineInputBorder(),
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

  Widget _buildPredictionSection(BuildContext context, double screenWidth, double screenHeight) {
    return Column(
      children: [
        Text(
          'Prediction',
          style: TextStyle(
            fontSize: screenWidth * 0.07,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        if (locationName.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.02),
            child: Text(
              'Location: $locationName',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.grey[700],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildWaterRequiredDisplay(double screenWidth, double screenHeight) {
    return Column(
      children: [
        Text(
          'Water Required:',
          style: TextStyle(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        isLoading
            ? CircularProgressIndicator()
            : Container(
                width: screenWidth * 0.4,
                height: screenWidth * 0.4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue[100],
                  border: Border.all(color: Colors.green, width: 10),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${waterRequired.toStringAsFixed(2)} units',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildCalculateButton(double screenWidth, double screenHeight) {
    return SizedBox(
      width: screenWidth * 0.8,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff388E3C),
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.02,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: (selectedCrop == null || selectedSoil == null || isLoading)
            ? null
            : calculateWaterRequirement,
        child: Text(
          'احسب كمية المياه',
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}