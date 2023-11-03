import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dates.dart';
import 'hash.dart';

class HttpApi {
  final String url;
  final Map<String, String> data;
  final String CONTENT_TYPE = "application/json";
  final String AUTHORIZATION = dotenv.env['AUTHORIZATION'].toString();
  HttpApi({required this.url, required this.data});

  Future<String> postStringData() async{
    String date = getCurrentDateTime("yyyy-MM-dd HH:mm:ss");
    String token = generateBase64(generateMd5(date+AUTHORIZATION));
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': CONTENT_TYPE,
        'Authorization': AUTHORIZATION,
        'X-DATE': date,
        'X-TOKEN': token
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      String responseBody = response.body;
      print(responseBody);
      return responseBody;
    } else {
      throw Exception('Something went wrong...');
    }
  }


}
