import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import 'secrets.dart';

class OpenAIService {
  final client = Client();
  final headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $openAIApiKey"
  };

  final List<Map<String, String>> messages = [];

  Future<String> isArtPromptAPI(String prompt) async {
    try {
      print(prompt);
      final response = await client.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: headers,
        body: jsonEncode(
          {
            "model": "gpt-3.5-turbo",
            "messages": [
              {
                "role": "user",
                "content":
                    "Does this message want to generate an AI picture, image, art or anything similar? $prompt . Simply answer with yes or no.",
              }
            ]
          },
        ),
      );

      print('response: ${response.statusCode}');
      print('response: ${response.body}');

      if (response.statusCode == 200) {
        final content = jsonDecode(response.body)['choices'][0]['message']
                ['content']
            .trim();

        switch (content) {
          case "Yes.":
          case "Yes":
          case "yes":
          case "yes.":
          case "YES":
            final res = dallEAPI(prompt);
            return res;
          default:
            final res = chatGPTAPI(prompt);
            return res;
        }
      } else {
        return (response.statusCode.toString());
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> chatGPTAPI(String prompt) async {
    log("********** chatGPTAPI || open **********");
    messages.add({
      "role": "user",
      "content": prompt,
    });

    try {
      print(prompt);
      final response = await client.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: headers,
        body: jsonEncode(
          {
            "model": "gpt-3.5-turbo",
            "messages": messages,
          },
        ),
      );

      print('response: ${response.statusCode}');
      print('response: ${response.body}');

      if (response.statusCode == 200) {
        final content = jsonDecode(response.body)['choices'][0]['message']
                ['content']
            .trim();

        messages.add({
          "role": "assistant",
          "content": content,
        });
        log("********** chatGPTAPI || end **********");
        return content;
      } else {
        log("********** chatGPTAPI || end **********");
        return (response.statusCode.toString());
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> dallEAPI(String prompt) async {
    log("********** Dall-E API || open **********");
    messages.add({
      "role": "user",
      "content": prompt,
    });

    try {
      print(prompt);
      final response = await client.post(
        Uri.parse('https://api.openai.com/v1/images/generations'),
        headers: headers,
        body: jsonEncode(
          {"prompt": prompt, "n": 1, "size": "1024x1024"},
        ),
      );

      print('response: ${response.statusCode}');
      print('response: ${response.body}');

      if (response.statusCode == 200) {
        final imageUrl = jsonDecode(response.body)['data'][0]['url'];

        messages.add({
          "role": "assistant",
          "content": imageUrl,
        });
        log("********** Dall-E API || end **********");
        return imageUrl;
      } else {
        log("********** Dall-E API  || end **********");
        return (response.statusCode.toString());
      }
    } catch (e) {
      return e.toString();
    }
  }
}
