import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import 'dart:math';
import 'package:english_words/english_words.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {Widget build(c) => MaterialApp(home: Page());}

class Page extends StatefulWidget {_PageState createState() => _PageState();}

class _PageState extends State<Page> {
  int maxDepth = 15;

  initState() {
    super.initState();
    ShakeDetector.autoStart(onPhoneShake: () {setState(() {});});
  }

  @override
  Widget build(c) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: getRandColor(),
        title: Text("Randomize"),
        actions: <Widget>[
          DropdownButton(
            onChanged: (v) {
              setState(() {
                maxDepth = v;
              });
            },
            items: List.generate(30, (v) {
              return DropdownMenuItem(child: Text("Allowed Depth: " + (v + 1).toString()), value: v + 1);
            }),
            value: maxDepth,
          ),
          InkWell(
            onTap: () => setState(() {}),
            child: Padding(padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.refresh),
            ),
          )
        ],
      ),
      body: ListView(children: [buildTopNode()]),
      floatingActionButton: FloatingActionButton.extended(onPressed: () {}, icon: buildIcon(0), label: buildText(0)),
    );
  }

  buildTopNode() {
    var list = [buildListView, buildGridView, buildNode, buildPgView];
    return Center(child: list[getRandNum(list.length)](getRandNum(list.length)));
  }

  buildNode(int i) {
    if (i > maxDepth)
      return buildText(i);
    var list = [buildHorizontalWrap, buildVertWrap, buildContainer, buildCPI, buildText, buildButton, buildCA, buildCard, buildIcon];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: list[getRandNum(list.length)](i)),
    );
  }

  buildPgView(int i) {
    int rand = getRandNum(10);
    return LayoutBuilder(builder: (c, constraints) {
      return Container(
        height: constraints.hasBoundedHeight ? null : MediaQuery.of(c).size.height - 70.0,
        child: PageView.builder(
          itemBuilder: (context, position) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 8.0,
                child: buildNode(i + 1),
              ),
            );
          }, itemCount: rand == 0 ? 2 : rand,
        ),
      );
    });
  }

  buildListView(i) {
    int rand = getRandNum(10, zeroAllowed: false);
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (c, p) => buildNode(i + 1),
      itemCount: rand == 0 ? 5 : rand,
    );
  }

  buildGridView(i) {
    int gridColCnt = getRandNum(4, zeroAllowed: false);
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (c, p) => buildNode(i + 1),
      itemCount: getRandNum(10, zeroAllowed: false),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: gridColCnt),
    );
  }

  buildHorizontalWrap(i) {
    int num = getRandNum(5, zeroAllowed: false);
    List<Widget> list = [];
    for (int i = 0; i < num; i++) {list.add(buildNode(i + 1));}
    return FittedBox(child: Wrap(children: list));
  }

  buildVertWrap(i) {
    int num = getRandNum(5, zeroAllowed: false);
    List<Widget> list = [];
    for (int i = 0; i < num; i++) {
      list.add(buildNode(i + 1));
    }
    return FittedBox(
      child: Wrap(children: list, direction: Axis.vertical),
    );
  }

  buildContainer(i) => Container(color: getRandColor(), child: buildNode(i + 1));

  buildButton(i) => FlatButton(onPressed: () {}, child: buildNode(i + 1), color: getRandColor());

  buildCPI(i) {
    if (i < 3) {
      return buildNode(i + 1);
    }
    return CircularProgressIndicator(backgroundColor: getRandColor());
  }

  buildText(i) => Text(nouns[getRandNum(nouns.length)]);


  buildCard(i) {
    return Card(
      child: buildNode(i + 1),
      elevation: 8.0,
      color: getRandColor(),
    );
  }

  buildCA(i) => CircleAvatar(backgroundColor: getRandColor(), child: buildNode(i + 1));


  buildIcon(int i) {
    return Icon(IconData(
            OMIcons.codePoints.values.toList()[getRandNum(OMIcons.codePoints.values.toList().length)],
            fontFamily: 'outline_material_icons',
            fontPackage: 'outline_material_icons'), color: getRandColor());
  }

  getRandNum(int max, {bool zeroAllowed = true}) {
    var num = Random().nextInt(max);
    return zeroAllowed ? num : num != 0 ? num : num + 1;
  }

  getRandColor() => Colors.primaries[getRandNum(Colors.primaries.length)];
}
