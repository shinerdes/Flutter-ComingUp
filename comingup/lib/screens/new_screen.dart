import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:comingup/models/todo.dart';
import 'package:comingup/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class NewScreen extends StatefulWidget {
  const NewScreen({super.key});

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  DateTime date = DateTime.now();
  DateTime decideDate = DateTime.now();
  String inputText = "";
  String inputTextView = "";
  bool detectKeyboard = true;

  XFile? _pickedFile;

  List _todoListFin = [];

  late StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {
    super.initState();

    var keyboardVisibilityController = KeyboardVisibilityController();

    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible == true) {
        //키보드 나타남
        detectKeyboard = true;
      } else {
        detectKeyboard = false;
        //키보드 숨김
      }
    });
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }
  /*
  json file 불러오기 
  -> 1. 파일이 있음
      불러오고 decode -> 집어넣고 -> encoding -> 저장
  -> 2. 파일이 없음
      그냥 리스트에 집어 넣기 -> encoding -> 저장 
  */

  Future<void> getTodoList() async {
    // 가장 먼저 체크해야할 부분 : 제목이 비어있는지에 대한

    final applicationDirectory =
        await getApplicationDocumentsDirectory(); // 디렉토리

    //print(decideDate);
    ////2023-04-06 00:00:00.000

    DateFormat dateFormat = DateFormat("yyyy-MM-dd_HH-mm-ss");
    DateFormat theDateFormat = DateFormat("yyyy-MM-dd");
    String timeStamp = dateFormat.format(decideDate);
    String theDate = theDateFormat.format(date);
    // print(timeStamp);
    // print(theDate);
    // print("-------");

    if (await File('${applicationDirectory.path}/a.json').exists()) {
      print("File exists");
      final File file = File('${applicationDirectory.path}/a.json'); // 파일 지정

      if (_pickedFile != null) {
        // 불러온 이미지가 있다
        var aaaa = File(_pickedFile!.path);

        final File localImage = await aaaa
            .copy('${applicationDirectory.path}/$timeStamp.jpeg'); // 이미지 저장

        String data = await file.readAsString();
        final decodeData = await json.decode(data);

        setState(() {
          _todoListFin = decodeData;
        }); // 리스트에 삽입까지

        _todoListFin.add(
          Todo(
              title: inputText,
              date: theDate,
              image: timeStamp,
              content: inputTextView),
        );

        file.writeAsStringSync(json.encode(_todoListFin));

        _todoListFin = [];
      } else {
        print("불러온 이미지 없음");
        // 아무것도 없음

        String data = await file.readAsString();
        final decodeData = await json.decode(data);

        setState(() {
          _todoListFin = decodeData;
        }); // 리스트에 삽입까지

        _todoListFin.add(
          Todo(
              title: inputText,
              date: theDate,
              image: "",
              content: inputTextView),
        );

        file.writeAsStringSync(json.encode(_todoListFin));

        _todoListFin = [];
      }
      // 이미지 저장 확정
    } else {
      // 아예 없으면
      if (_pickedFile != null) {
        var aaaa = File(_pickedFile!.path);

        final File localImage =
            await aaaa.copy('${applicationDirectory.path}/$timeStamp.jpeg');

        _todoListFin.add(
          Todo(
              title: inputText,
              date: theDate,
              image: timeStamp,
              content: inputTextView),
        );

        final File file = File('${applicationDirectory.path}/a.json');

        setState(() {
          file.writeAsString(json.encode(_todoListFin));
        }); // 리스트에 삽입까지

        _todoListFin = [];
      } else {
        // 아무것도 없음
        _todoListFin.add(
          Todo(
              title: inputText,
              date: theDate,
              image: "",
              content: inputTextView),
        );

        final File file = File('${applicationDirectory.path}/a.json');

        setState(() {
          file.writeAsString(json.encode(_todoListFin));
        }); // 리스트에 삽입까지

        _todoListFin = [];
      }
    }

    // ignore: use_build_context_synchronously
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()))
        .then(onGoBack);
    // 홈으로
  }

  var userImage = Image.asset("assets/images/blank.jpeg");
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 196, 199, 98),
          foregroundColor: Colors.black,
          elevation: 1,
          title: const Text(
            "",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
              height: 100,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(CupertinoIcons.plus_circle_fill),
              onPressed: () {
                if (inputText == "") {
                  _showDialog();
                  // 제목 입력이 안되어 있어서 alert 출력
                } else {
                  getTodoList();
                }
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                    decoration: const InputDecoration(
                      labelText: 'title',
                      labelStyle: TextStyle(color: Colors.black),
                      hintText: '',
                      counterText: '',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      // counter text를 비움으로 설정
                    ),
                    maxLength: 15,
                    onChanged: (text) {
                      inputText = text;
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        const Icon(CupertinoIcons.calendar, size: 50),
                        ElevatedButton(
                          onPressed: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: date,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(DateTime.now().year + 10),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                date = selectedDate;
                              });
                            }
                          },
                          child: Text(
                            "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Container(
                      width: 0.5,
                      height: 100,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 20),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.5,
                            ),
                          ),
                          child: Image(
                              image: _getPhoto(_pickedFile),
                              height: 100,
                              width: 100,
                              fit: BoxFit.fill),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                icon: const Icon(CupertinoIcons.photo_fill),
                                color: Colors.black,
                                iconSize: 45.0,
                                onPressed: () => _getPhotoLibraryImage()),
                            IconButton(
                              icon: const Icon(CupertinoIcons.trash_fill),
                              color: Colors.black,
                              iconSize: 45.0,
                              onPressed: () {
                                _outPhotoImage();
                                // blank 처리
                                // _pickedFile 아웃
                              },
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  height: 0.5,
                  color: Colors.black,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2.0),
                        borderRadius: BorderRadius.circular(5.0),
                        gapPadding: 4.0,
                      ),
                    ),
                    maxLines: 15,
                    onChanged: (text) {
                      inputTextView = text;
                    },
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // maxLineKeyboard() {
  //   if (detectKeyboard == true) {
  //     print(detectKeyboard);
  //     return 15;
  //   } else {
  //     print(detectKeyboard);
  //     return 30;
  //   }
  // }

  onGoBack(dynamic value) {
    refreshData();
    setState(() {});
  }

  void refreshData() {}

  _getPhotoLibraryImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  _outPhotoImage() {
    if (_pickedFile != null) {
      setState(() {
        _pickedFile = null;
      });
    }
  }

  _getPhoto(pickedFile) {
    if (pickedFile == null) {
      return const AssetImage("assets/images/blank.jpeg");
    } else {
      return FileImage(File(pickedFile!.path));
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: const Text("제목이 없습니다"),
          content: const Text("제목을 입력하세요"),
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
