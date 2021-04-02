import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;

class RestfulUtil {
  static Future<Response<dynamic>> get(
      {required String url,
      Map<String, String>? headers = const {
        "Accept": "application/json"
      }}) async {
    // function:
    var response = await Dio().get(url,
        options: Options(
            method: "GET",
            headers: headers!
              ..addAll(
                {"User-Agent": "EasyTripApp/1.0 "},
              )));
    // var response = await http.get(
    //     Uri.parse(url),
    //     headers: headers!..addAll(
    //       {"User-Agent": "EasyTripApp/1.0 "},
    //       //{"Cookies": "111"},
    //     ));
    return response;
  }

  static Future<Response<dynamic>> post(
      {required String url,
      Map<String, String>? headers = const {
        "Accept": "application/json"
      }}) async {
    return await Dio().post(url,
        options: Options(
            method: "post",
            headers: headers!
              ..addAll(
                {"User-Agent": "EasyTripApp/1.0 "},
              )));
  }
}
