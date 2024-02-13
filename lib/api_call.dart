import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiCall {
  Future<String> getRawData(String query, double temp) async {
    String rawData = '';
    try {
      dynamic data = {
        "contents": [
          {
            "parts": [
              {"text": query}
            ]
          }
        ],
        "generationConfig": {
          "temperature": temp,
          "topK": 1,
          "topP": 1,
          "maxOutputTokens": 2048,
          "stopSequences": []
        },
        "safetySettings": [
          {
            "category": "HARM_CATEGORY_HARASSMENT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
          },
          {
            "category": "HARM_CATEGORY_HATE_SPEECH",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
          },
          {
            "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
          },
          {
            "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
          }
        ]
      };

      http.Response res = await http.post(
        Uri.parse(
            "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyDIupkWOq9tuInCkuaNR7uMAiYb3QsXcb8"),
        body: json.encode(data),
      );
      var decodedJson = jsonDecode(res.body);

      if (res.statusCode == 200) {
        if (decodedJson.containsKey("candidates")) {
          rawData = jsonDecode(res.body)["candidates"][0]["content"]["parts"][0]
              ["text"];
        } else {
          rawData = "Sorry these prompt are not allowed";
        }
      }
    } catch (e) {
      print(e);
    }
    return rawData;
  }

  Future<String> getImageData(String query, File images, double temp) async {
    String rawData = '';
    try {
      String base64Image = base64Encode(await images.readAsBytes());

      dynamic data = {
        "contents": [
          {
            "parts": [
              {"text": "$query:\n"},
              {
                "inlineData": {"mimeType": "image/jpeg", "data": base64Image}
              }
            ]
          }
        ],
        "generationConfig": {
          "temperature": temp,
          "topK": 32,
          "topP": 1,
          "maxOutputTokens": 4096,
          "stopSequences": []
        },
        "safetySettings": [
          {
            "category": "HARM_CATEGORY_HARASSMENT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
          },
          {
            "category": "HARM_CATEGORY_HATE_SPEECH",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
          },
          {
            "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
          },
          {
            "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
          }
        ]
      };

      http.Response res = await http.post(
        Uri.parse(
            "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-vision:generateContent?key=AIzaSyDIupkWOq9tuInCkuaNR7uMAiYb3QsXcb8"),
        body: json.encode(data),
      );
      var decodedJson = jsonDecode(res.body);

      if (res.statusCode == 200) {
        if (decodedJson.containsKey("candidates")) {
          rawData = jsonDecode(res.body)["candidates"][0]["content"]["parts"][0]
              ["text"];
        } else {
          rawData = "Sorry these prompt are not allowed";
        }
      }
    } catch (e) {
      print(e);
    }
    return rawData;
  }
}
