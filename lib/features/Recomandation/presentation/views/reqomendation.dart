import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Reqomendation extends StatefulWidget {
  const Reqomendation({super.key});

  @override
  _ReqomendationState createState() => _ReqomendationState();
}

class _ReqomendationState extends State<Reqomendation> {
  String? selectedSoil;
  String? selectedCrop;
  List<dynamic> predictions = [];
  bool isLoading = false;
  String errorMessage = '';
  final TextEditingController cityController = TextEditingController();

  final soilTypes = ['DRY', 'WET', 'MOIST'];
  final cropTypes = [
    'BANANA', 'SOYABEAN', 'CABBAGE', 'POTATO', 'RICE', 'MELON',
    'MAIZE', 'CITRUS', 'BEAN', 'WHEAT', 'MUSTARD', 'COTTON',
    'SUGARCANE', 'TOMATO', 'ONION'
  ];

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('الرجاء تفعيل خدمة الموقع');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse) {
        throw Exception('تم رفض إذن الوصول إلى الموقع');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getPredictions() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
      predictions = [];
    });

    try {
      final body = {};
      final city = cityController.text.trim();

      if (city.isNotEmpty) {
        body['city'] = city;
      } else {
        Position position = await _getCurrentLocation();
        body['latitude'] = position.latitude;
        body['longitude'] = position.longitude;
      }

      body['crop_type'] = selectedCrop;
      body['soil_type'] = selectedSoil;

      if (body['crop_type'] == null || body['soil_type'] == null) {
        throw Exception('الرجاء اختيار نوع التربة والمحصول');
      }

      final response = await http.post(
        Uri.parse('http://192.168.1.2:5000/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      
      if (response.statusCode == 200) {
        setState(() {
          predictions = responseBody['predictions'];
        });
      } else {
        String errorMsg = responseBody['error'] ?? 'حدث خطأ غير متوقع';
        if (errorMsg.contains('city not found')) {
          errorMsg = '⚠️ اسم المدينة غير صحيح';
        }
        throw Exception(errorMsg);
      }
    } on http.ClientException {
      setState(() => errorMessage = 'تعذر الاتصال بالخادم');
    } catch (e) {
      setState(() => errorMessage = e.toString().replaceAll('Exception: ', ''));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(title: const Text('حساب الاحتياجات المائية')
          ,centerTitle: true,backgroundColor: Colors.green[50],),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: 'اسم المدينة (اختياري)',
                  border: OutlineInputBorder(),
                  hintText: 'اتركه فارغا لاستخدام الموقع الحالي',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedSoil,
                      decoration: const InputDecoration(
                        labelText: 'حدد نوع التربة',
                        border: OutlineInputBorder(),
                      ),
                      items: soilTypes.map((soil) {
                        return DropdownMenuItem(
                          value: soil,
                          child: Text(soil),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => selectedSoil = value),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedCrop,
                      decoration: const InputDecoration(
                        labelText: 'حدد نوع المحصول',
                        border: OutlineInputBorder(),
                      ),
                      items: cropTypes.map((crop) {
                        return DropdownMenuItem(
                          value: crop,
                          child: Text(crop),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => selectedCrop = value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: _getPredictions,
                child: const Text('احسب كمية المياه',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
              const SizedBox(height: 26),
              if (isLoading) const Center(child: CircularProgressIndicator()),
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (predictions.isNotEmpty)
                SizedBox(
                  height: 300,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      dataRowHeight: 80,
                      columnSpacing: 30,
                      headingRowColor: MaterialStateColor.resolveWith(
                        (states) => Colors.grey.shade200,
                      ),
                      border: TableBorder.all(color: Colors.grey, width: 1),
                      columns: const [
                        DataColumn(
                          label: Text('التاريخ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                        DataColumn(
                          label: Text('درجة الحرارة',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                        DataColumn(
                          label: Text('كمية المياه',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                      ],
                      rows: predictions.map<DataRow>((prediction) {
                        return DataRow(
                          cells: [
                            DataCell(Text(prediction['date'].toString(),
                                style: const TextStyle(fontSize: 16))),
                            DataCell(
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('°C الدنيا: ${prediction['temp_min']}',
                                      style: const TextStyle(fontSize: 14)),
                                  const SizedBox(height: 5),
                                  Text('°C العليا: ${prediction['temp_max']}',
                                      style: const TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                            DataCell(Text(
                              '${prediction['water_required']?.toStringAsFixed(1)} لتر',
                              style: const TextStyle(fontSize: 16),
                            )),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}