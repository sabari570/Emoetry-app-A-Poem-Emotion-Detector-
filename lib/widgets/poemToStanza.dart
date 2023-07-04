import 'dart:convert';

import 'package:http/http.dart' as http;

Future<String?> fetchResult(String stanza) async {
  String url =
      "https://882c-2409-40f3-2e-7044-cc-2c96-cb38-7dfc.ngrok-free.app/predict_poem_emotion";
  Map<String, String> inputData = {"stanza": stanza};
  try {
    var client = http.Client();
    final inputDataJson = jsonEncode(inputData);
    final response = await client.post(Uri.parse(url),
        body: inputDataJson, headers: {"Content-Type": "application/json"});
    print("Result is: ${response.body}");
    var decodedResult = jsonDecode(response.body);
    print("DecodedResult: ${decodedResult['emotion']}");
    return decodedResult['emotion'];
  } catch (e) {
    print("Exception is: " + e.toString());
    return null;
  }
}

Future<Map<String, dynamic>> convertPoemToStanza(String poem) async {
  //Splitting the poem into lines
  List<String> lines = poem.split("\n");

  //Grouping the lines into each stanza containing 4 lines
  List<List<String>> stanzas = [];
  List<String> emotions = [];
  Map<String, dynamic> resultMap = {};
  String predictedEmotion;

  for (int i = 0; i < lines.length; i += 4) {
    int end = i + 4;
    if (end > lines.length) {
      end = lines.length;
    }
    stanzas.add(lines.sublist(i, end));
  }

  for (var stanza in stanzas) {
    print(stanza.join("\n"));
    print('----');
    predictedEmotion = (await fetchResult(stanza.join("\n")))!;
    emotions.add(predictedEmotion);
  }
  print("Stanzas: $stanzas");
  print("Emotions: $emotions");
  resultMap = {"stanzas": stanzas, "emotions": emotions};
  return resultMap;
}
