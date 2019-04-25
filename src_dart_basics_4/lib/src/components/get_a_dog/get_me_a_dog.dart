import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:angular/angular.dart';

@Component(
  selector: 'get-me-a-dog',
  template: '''
  <div class="wrapper">
    <button class="button is-outlined is-info my-button" (click)="getMeADog()" [disabled]="disabled">
        亲爱的普京，我想要一条...</button>

    <div class="title is-dark my-title">{{randomDog}}</div>

    <img class="my-image" [src]="imageUrl">
  </div>
   ''',
  styleUrls: ['random_dog.css'],
)

class GetMeADog {

  String imageUrl = "";
  String randomDog = "";
  bool disabled = false;

  void getMeADog() {
    disabled = true;
    imageUrl = "";
    randomDog = "送狗大帝正在思考...";
    _getADog();
    disabled = false;
  }

  void _getADog() async {
    final resp = await http.get("https://dog.ceo/api/breeds/image/random");
    Map<String, dynamic> map = await json.decode(resp.body);
    imageUrl = map['message'];
    randomDog = await _parseDogName(map['message']);
  }

  Future<String> _parseDogName(String path) async {
    List<String> parts = path.split("/");
    String rawBreed = parts[parts.length - 2];
    String transBreed = "";
    if (rawBreed.contains("-")) {
      List<String> words = rawBreed.split("-");
      for (int i = words.length - 1; i >= 0; i--) {
        transBreed += words[i];
        if (i != 0) transBreed += " ";
      }
    } else transBreed = rawBreed;

    transBreed += " dog";
    return await _translate(transBreed);
  }

  Future<String> _translate(String line) async {
    final url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=zh-CN&dt=t&q=" + line;
    final resp = await http.get(url);
    List<dynamic> decoded = await json.decode(resp.body);
    final subList = decoded[0] as List<dynamic>;
    final subList2 = subList[0] as List<dynamic>;
    return subList2[0] as String;
  }

}