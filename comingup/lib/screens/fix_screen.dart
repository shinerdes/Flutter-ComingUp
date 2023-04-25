import 'dart:convert';
import 'dart:io';

import 'package:comingup/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class FixScreen extends StatefulWidget {
  final String title;
  final String date;
  final String image;
  final String content;
  final String path;
  final int index;

  const FixScreen(
      this.title, this.date, this.image, this.content, this.path, this.index,
      {super.key});

  @override
  State<FixScreen> createState() => _FixScreenState();
}

class _FixScreenState extends State<FixScreen> {
  String inputText = "";
  String inputTextView = "";
  DateTime date = DateTime.now();
  DateTime theDate = DateTime.now();
  XFile? _pickedFile;
  String _path = "";
  int _index = 0;
  List _todoList = [];
  DateTime decideDate = DateTime.now();

  final TextEditingController _controller = TextEditingController();

  @override
  initState() {
    super.initState();
    //date = DateFormat().parse(widget.date); // 여기서 초기화
    date = DateFormat("yyyy-MM-dd").parse(widget.date);
    //theDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.date);

    inputText = widget.title;
    inputTextView = widget.content;
    _controller.text = widget.title;
    _path = widget.path;
    _index = widget.index;
  }

  Future<void> getImagePath() async {
    final applicationDirectory = await getApplicationDocumentsDirectory();

    print(applicationDirectory.path); // 디렉토리
    setState(() {
      _path = applicationDirectory.path;
    });
  }

  fixSave() async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd_HH-mm-ss");
    DateFormat theDateFormat = DateFormat("yyyy-MM-dd");
    String theDate = theDateFormat.format(date);
    String timeStamp = dateFormat.format(decideDate);

    final File file = File('$_path/a.json');
    String data = await file.readAsString();
    final decodeData = await json.decode(data);

    setState(() {
      _todoList = decodeData; // json 파일에 있는거 긁어옴
    });

    if (_pickedFile != null) {
      if (widget.image == "") {
        // 비어있는 이미지
        // 새로 이미지 생성해야함
        // image 부분도 바꿔줘야함

        var aaaa = File(_pickedFile!.path);

        final File localImage = await aaaa.copy('$_path/$timeStamp.jpeg');

        _todoList[_index]["image"] =
            timeStamp; // 이건 이미지가 없었다가 등록했을떄 바뀜. 이미지 to 이미지는 x
      } else {
        var aaaa = File(_pickedFile!.path);
        final File localImage = await aaaa.copy('$_path/${widget.image}.jpeg');
        // 이미지가 이미 존재
        // timestamp말고 그냥 있던 파일에 덮어쓰기
      }

      var aaaa = File(_pickedFile!.path);

      final File localImage =
          await aaaa.copy('$_path/$timeStamp.jpeg'); // 이미지 저
    } else {
      // 바뀌는거 아무것도 없음
    }

    _todoList[_index]["title"] = inputText;
    _todoList[_index]["date"] = theDate;
    _todoList[_index]["content"] = inputTextView;

    file.writeAsStringSync(json.encode(_todoList));

    Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()))
        .then(onGoBack);
  }

  onGoBack(dynamic value) {
    refreshData();
    setState(() {});
  }

  void refreshData() {}

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
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(CupertinoIcons.pencil_circle_fill),
              onPressed: () {
                if (inputText == "") {
                  _showDialog();
                } else {
                  fixSave();
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
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'title',
                      labelStyle: TextStyle(color: Colors.black),
                      hintText: '',
                      counterText: '',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
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
                              image: _getPhoto(widget.image),
                              height: 100,
                              width: 100,
                              fit: BoxFit.fill),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                icon: const Icon(CupertinoIcons.photo_fill),
                                iconSize: 45.0,
                                onPressed: () => _getPhotoLibraryImage()),
                            IconButton(
                              icon: const Icon(CupertinoIcons.trash_fill),
                              iconSize: 45.0,
                              onPressed: () {
                                _outPhotoImage();
                              },
                            ),
                          ],
                        )
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
                    initialValue: inputTextView,
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

  _getPhoto(String imageStr) {
    if (_pickedFile == null) {
      if (imageStr == "") {
        return const AssetImage("assets/images/blank.jpeg");
      } else {
        return FileImage(File('$_path/$imageStr.jpeg'));
      }
    } else {
      return FileImage(File(_pickedFile!.path));
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
