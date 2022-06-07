//Constructor for token and message to be parametrized
import 'dart:convert';
import 'dart:math';
import 'package:listview_in_blocpattern/data/models/Models.dart';
import 'package:http/http.dart' as http;
import '../../res/API.dart';

// Main class for the ItemRepository
abstract class ItemRepository {
  //getData is the function to get the data from the API, and return in the type of FoodModel
  Future<ApiResultModel> sendMessage(String token, String title, String body);
}

//Subclass of the ItemRepository
class ItemRepositoryImpl implements ItemRepository {
  @override
  Future<ApiResultModel> sendMessage(
      String token, String title, String body) async {
    final response = await http.post(
      Uri.parse(AppStrings.apikey),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'key=AAAANjF9RUM:APA91bHIe7cj4KLN1mbl1GNjd5sZe7qusRflveuyU6TEWvuxJ9P0SXWqI_cDVfHwR71-z20gEByEL4R6B6W7kt6choPh6QkFDve2w8M_V7YJUeHAMrzXdzVtCX9nZWfvQr16DarVSCcR'
      },
      body: jsonEncode(<String, dynamic>{
        'to': token,
        "content_available": true,
        "notification": {
          "title": title,
          "body": body,
          "click_action": "fcm.ACTION.HELLO"
        },
        "data": {"extra": "Juice"}
      }),
    );
    if (response.statusCode == 200) {
      var body = await json.decode(response.body);
      if (body['success'] == 1) {
        return ApiResultModel.fromJson(body);
      } else {
        throw Exception();
      }
    } else {
      throw Exception();
    }
  }
}
