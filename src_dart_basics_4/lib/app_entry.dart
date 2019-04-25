import 'package:angular/angular.dart';

import 'package:skeleton_wlmq/src/directives/highlight.dart';

@Component(
  selector: 'app-entry',
  templateUrl: 'app_entry.html',
  styleUrls: ['app_entry.css'],
  directives: [HighlightDirective, NgFor],
)

class AppEntry {

  List<Poem> poems = [
    Poem("子夜四时歌：春歌", "秦地罗敷女，采桑绿水边。素手青条上，红妆白日鲜。蚕饥妾欲去，五马莫留连。"),
    Poem("子夜四时歌：夏歌", "镜湖三百里，菡萏发荷花。五月西施采，人看隘若耶。回舟不待月，归去越王家。"),
    Poem("子夜四时歌：秋歌", "长安一片月，万户捣衣声。秋风吹不尽，总是玉关情。何日平胡虏，良人罢远征？"),
    Poem("子夜四时歌：冬歌", "明朝驿使发，一夜絮征袍。素手抽针冷，那堪把剪刀。裁缝寄远道，几日到临洮？"),
  ];

}

class Poem {
  String title;
  String contents;
  Poem(this.title, this.contents);
}