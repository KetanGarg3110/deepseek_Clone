import 'dart:convert';
import 'dart:io';
import 'package:deepseek/data/remote/api/urls.dart';
import 'package:http/http.dart' as httpClient;

class ApiHelper {
  // apis ko hit karne ka logic .
  Future<Map<String, dynamic>> generateAiMessage({
    required String url,
    required String prompt,
  }) async {
    //Exception handling
    try {
      // jab bhi data ko send kar rahe ho to post main hi hogi
      var mUri = Uri.parse(url);

      var response = await httpClient.post(
        mUri,
        // jana main pana ho to jsonEncode
        body: jsonEncode({
          "model": "deepseek/deepseek-r1-0528:free",
          "messages": [
            {
              "role": "user",
              "content": prompt,
            }
          ]
        }), // body: jsonEncode({
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${Urls.CHAT_COMPELETION_API_KEY}",
        },
      );
      //  print(response.body.toString());
      print('Api Response :${response.body}');
      // In Flutter, a status code refers to the HTTP response status received from an API when making network requests using packages like http or dio
      if (response.statusCode == 200) {
        Map<String, dynamic> mData = jsonDecode(response.body);

        // Safely access message content
        String content = mData['choices'][0]['message']['content'];
        print(content); // Output: Hello! How can I assist you today?

        if (mData['error'] != null) {
          throw (HttpException("Error : ${mData['error']['message']}"));
        } else {
          // Returning the parsed JSON map
          return mData;
        }
      } else {
        // esme alag alg status codes ki exception handling kar sakte hai .
        // Server returned an error status code
        throw (HttpException("Server error :${response.statusCode}"));
      }
    } catch (e) {
      // Catch any exception and wrap it in HttpException
      throw (HttpException(e.toString()));
    }
  }
}
