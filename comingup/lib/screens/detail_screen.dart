import 'dart:io';

import 'package:comingup/screens/fix_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DetailScreen extends StatefulWidget {
  //const DetailScreen({super.key});
  //DetailScreen(this.id, {Key? key}) : super(key: key);

  final String title;
  final String date;
  final String image;
  final String content;
  final String path;
  final int index;

  const DetailScreen(
      this.title, this.date, this.image, this.content, this.path, this.index,
      {super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String _path = "";
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Future<String> getImagePath() async {
    final applicationDirectory =
        await getApplicationDocumentsDirectory(); // 디렉토리

    setState(() {
      _path = applicationDirectory.path;
    });

    return applicationDirectory.path;
  }

  @override
  initState() {
    super.initState();
    _path = widget.path;
    _controller.text = widget.title;

    // getImagePath().then((value) {
    //   print('Async done');
    // });

    // ignore: avoid_print
    print("initState Called");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FixScreen(
                          widget.title,
                          widget.date,
                          widget.image,
                          widget.content,
                          widget.path,
                          widget.index)));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                readOnly: true,
                enabled: true,
                controller: _controller,
                decoration: const InputDecoration(
                    hintText: "title",
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.black,
                      width: 0.5,
                    ))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      const Icon(CupertinoIcons.calendar, size: 50),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          widget.date,
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
                            //image: AssetImage("assets/images/jenni.jpeg"),
                            image: _getPhoto(widget.image),
                            height: 100,
                            width: 100,
                            fit: BoxFit.fitHeight),
                      ),
                    ],
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              height: 0.5,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.black,
                ),
                scrollController: _scrollController,
                readOnly: true,
                initialValue: widget.content,
                maxLines: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getPhoto(String imageStr) {
    if (imageStr == "") {
      return const AssetImage("assets/images/blank.jpeg");
    } else {
      return FileImage(File('$_path/$imageStr.jpeg'));
    }
  }
}
