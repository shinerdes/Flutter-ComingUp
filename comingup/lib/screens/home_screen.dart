import 'dart:convert';

import 'package:comingup/screens/detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:comingup/screens/new_screen.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String comingUpNext = "";

  @override
  initState() {
    super.initState();

    getTodoList().then((value) {
      print('Async done');
      comingUpNext = comingUpText();
    });
  }

  var userImage = Image.asset("assets/images/jenni.jpeg");

  List _todoList = [];
  String _path = "";

  Future<void> getTodoList() async {
    final applicationDirectory = await getApplicationDocumentsDirectory();

    print(File('${applicationDirectory.path}/a.json').existsSync());

    if (File('${applicationDirectory.path}/a.json').existsSync() == true) {
      final File file = File('${applicationDirectory.path}/a.json');

      print(applicationDirectory.path);

      String data = await file.readAsString();
      final decodeData = await json.decode(data);

      setState(() {
        _path = applicationDirectory.path;
        _todoList = decodeData;
      });
    } else {}
  }

  Future<void> removeIndex(int index) async {
    final applicationDirectory = await getApplicationDocumentsDirectory();

    final File file = File('${applicationDirectory.path}/a.json');

    if (_todoList[index]["image"] != "") {
      try {
        final file = File(
            '${applicationDirectory.path}/${_todoList[index]["image"]}.jpeg');
        await file.delete();
      } catch (e) {
        return;
      }
    }

    setState(() {
      _todoList.removeAt(index); //
      file.writeAsString(json.encode(_todoList));
      comingUpNext = comingUpText();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 196, 199, 98),
        foregroundColor: Colors.black,
        elevation: 1,
        title: const Text(
          "",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(CupertinoIcons.add_circled_solid),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const NewScreen()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 244, 247, 230),
            width: double.infinity,
            height: 60,
            child: Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.calendar_today, size: 40),
                  const SizedBox(width: 8),
                  Text(
                    comingUpNext,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: myList()),
        ],
      ),
    );
  }

  ListView myList() {
    return ListView.separated(
        itemCount: _todoList.length,
        itemBuilder: (context, index) {
          //final item = _todoList[index];
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              //값을 완전히 삭제
              //image가 있다면 해당 파일 삭제

              setState(() {
                if (_todoList[index]["image"] != "") {}

                removeIndex(index);
              });
            },
            child: SizedBox(
              child: ListTile(
                visualDensity: const VisualDensity(vertical: 4.0),
                //tileColor: const Color.fromARGB(255, 230, 227, 227),
                minVerticalPadding: 20,
                dense: true,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => DetailScreen(
                            _todoList[index]["title"],
                            _todoList[index]["date"],
                            _todoList[index]["image"],
                            _todoList[index]["content"],
                            _path,
                            index)),
                  );
                },
                leading: SizedBox(
                  //height: double.maxFinite,
                  width: 100,
                  child: Image(
                    height: 100,
                    alignment: Alignment.center,
                    image: _getPhoto(_todoList[index]["image"]),
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  _todoList[index]["title"],
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  _todoList[index]["date"],
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                trailing: const SizedBox(
                  height: double.infinity,
                  child: Icon(Icons.arrow_forward_ios_outlined),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(
              height: 5.0,
              color: Colors.black,
            ));
  }

  _getPhoto(String imageStr) {
    if (imageStr == "") {
      return const AssetImage("assets/images/blank.jpeg");
    } else {
      return FileImage(File('$_path/$imageStr.jpeg'));
    }
  }

  comingUpText() {
    var dateList = [];
    var sortDateList = [];
    var first;
    var firstStr;
    final String dateStr;
    var length = _todoList.length;

    for (int i = 0; i < length; i++) {
      dateList.add(DateFormat("yyyy-MM-dd").parse(_todoList[i]["date"]));
    }

    sortDateList = dateList
      ..sort((a, b) => a.toString().compareTo(b.toString()));

    for (int j = 0; j < length; j++) {
      DateTime dt = DateTime.now();

      if (sortDateList[j].compareTo(dt) > 0 ||
          DateUtils.isSameDay(sortDateList[j], dt) == true) {
        first = sortDateList[j];
        break;
      }
    }

    dateStr = DateFormat('yyyy-MM-dd').format(first);

    for (int k = 0; k < length; k++) {
      if (_todoList[k]["date"] == dateStr) {
        firstStr = _todoList[k]["title"];
      }
    }

    return firstStr;
  }
}
