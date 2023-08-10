import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Constants {
  static Map<String, dynamic> _data = {};

  static Future<void> load() async {
    if (_data.isNotEmpty) {
      return; // already loaded
    }

    String jsonString = await rootBundle.loadString('assets/constants.json');
    _data = json.decode(jsonString);
  }

  static double getFontSize(dynamic size) {
    return _getDouble('font_sizes', size);
  }

  static double getOffsetSize(dynamic size) {
    return _getDouble('offset_sizes', size);
  }

  static double getRoundSize(dynamic size) {
    return _getDouble('round_sizes', size);
  }

  static double getLengthSize(dynamic size) {
    return _getDouble('length_sizes', size);
  }

  static double _getDouble(String cat, dynamic size){
    if(size is String){
      try{
        return _data[cat][size.toString()].toDouble();
      }catch(e){
        print(e.toString());
        return 0.00;
      }
    }
    else if(size is double || size is int){
      return size.toDouble();
    }
    else{
      return 0.00;
    }
  }

  static String getString(String str) {
    return _data['strings'][str].toString();
  }
}
