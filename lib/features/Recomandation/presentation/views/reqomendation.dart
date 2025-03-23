import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';

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
  final Dio _dio = Dio();

  final List<String> soilTypes = ['DRY', 'WET', 'MOIST'];
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

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('الرجاء تفعيل خدمة الموقع');

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
      final Map<String, dynamic> requestBody = {};
      final String city = cityController.text.trim();

      if (city.isNotEmpty) {
        requestBody['city'] = city;
      } else {
        final Position position = await _getCurrentLocation();
        requestBody['latitude'] = position.latitude;
        requestBody['longitude'] = position.longitude;
      }

      requestBody['crop_type'] = selectedCrop;
      requestBody['soil_type'] = selectedSoil;

      if (requestBody['crop_type'] == null || requestBody['soil_type'] == null) {
        throw Exception('الرجاء اختيار نوع التربة والمحصول');
      }

      final response = await _dio.post(
        'http://192.168.1.3:5000/predict',
        data: requestBody,
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status! < 500,
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      if (response.statusCode == 200) {
        setState(() => predictions = response.data['predictions']);
      } else {
        final errorMsg = response.data['error'] ?? 'حدث خطأ غير متوقع';
        throw Exception(_translateError(errorMsg));
      }
    } on DioException catch (e) {
      setState(() => errorMessage = _handleDioError(e));
    } catch (e) {
      setState(() => errorMessage = _translateError(e.toString()));
    } finally {
      setState(() => isLoading = false);
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'انتهى وقت الانتظار';
      case DioExceptionType.connectionError:
        return 'لا يوجد اتصال بالإنترنت';
      case DioExceptionType.badResponse:
        return _translateError(e.response?.data['error'] ?? 'خطأ في الخادم');
      default:
        return 'خطأ في الاتصال: ${e.message}';
    }
  }

  String _translateError(String error) {
    const translations = {
      'internal server error': 'خطأ داخلي في الخادم',
      'failed to fetch weather data': 'فشل في جلب بيانات الطقس',
      'city not found': '⚠️ اسم المدينة غير صحيح',
      'connection error: 404 client error': 'المدينة غير موجودة',
      'يجب اختيار نوع المحصول ونوع التربة': 'الرجاء اختيار النوعين',
      'اسم المدينة غير صحيح': 'المدينة غير موجودة',
      'يجب إدخال جميع الحقول المطلوبة': 'الحقول المطلوبة مفقودة',
      'نوع المحصول أو التربة غير صحيح': 'اختيار غير صالح',
      'فشل في الحصول على توقعات الطقس': 'فشل في جلب بيانات الطقس',
    };
    final lowerError = error.toLowerCase();
    return translations[lowerError] ?? error;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text('حساب الاحتياجات المائية'),
        centerTitle: true,
        backgroundColor: Colors.green[50],
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(size.width * 0.04),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // حقل المدينة
              TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: 'اسم المدينة (اختياري)',
                  border: OutlineInputBorder(),
                  hintText: 'اتركه فارغا لاستخدام الموقع الحالي',
                ),
              ),
              SizedBox(height: size.height * 0.02),
              // Dropdown لاختيار نوع التربة والمحصول
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
                      items: soilTypes
                          .map((soil) => DropdownMenuItem(
                                value: soil,
                                child: Text(soil),
                              ))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => selectedSoil = value),
                    ),
                  ),
                  SizedBox(width: size.width * 0.02),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedCrop,
                      decoration: const InputDecoration(
                        labelText: 'حدد نوع المحصول',
                        border: OutlineInputBorder(),
                      ),
                      items: cropTypes
                          .map((crop) => DropdownMenuItem(
                                value: crop,
                                child: Text(crop),
                              ))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => selectedCrop = value),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.03),
              // زر الحساب
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.015,
                  ),
                ),
                onPressed: () {
                  if (selectedCrop == null || selectedSoil == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('الرجاء اختيار نوع المحصول والتربة'),
                      ),
                    );
                  } else {
                    _getPredictions();
                  }
                },
                child: Text(
                  'احسب كمية المياه',
                  style: TextStyle(
                    fontSize: size.width * 0.04,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              if (isLoading)
                Center(child: CircularProgressIndicator()),
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                  child: Text(
                    errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: size.width * 0.04,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (predictions.isNotEmpty)
                SizedBox(
                  height: size.height * 0.4,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      dataRowHeight: size.height * 0.1,
                      columnSpacing: size.width * 0.06,
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Colors.grey.shade200),
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
                      rows: predictions
                          .map<DataRow>((prediction) => DataRow(
                                cells: [
                                  DataCell(Text(
                                    prediction['date'].toString(),
                                    style: TextStyle(
                                        fontSize: size.width * 0.04),
                                  )),
                                  DataCell(
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '°C الدنيا: ${prediction['temp_min']}',
                                          style: TextStyle(
                                              fontSize: size.width * 0.035),
                                        ),
                                        SizedBox(height: size.height * 0.005),
                                        Text(
                                          '°C العليا: ${prediction['temp_max']}',
                                          style: TextStyle(
                                              fontSize: size.width * 0.035),
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      '${prediction['water_required']?.toStringAsFixed(1)} لتر',
                                      style: TextStyle(
                                          fontSize: size.width * 0.04),
                                    ),
                                  ),
                                ],
                              ))
                          .toList(),
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
