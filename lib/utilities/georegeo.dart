import 'package:dio/dio.dart';

Future<String> getRegeo({required double lat, required double lng}) async {
  return await Dio().get(
    "",
    queryParameters: {
      "key": "ad071fdc602c0751be489efc2ffe7af1",
      "location": "$lng,$lat"
    },
  ).then((value) {
    assert(value.data['status'] == '1');
    var component = value.data['regeocodes']['addressComponent'];
    return
      component['district'].toString() +
        component['township'] +
        component['neighborhood']['name'];
  });
}
