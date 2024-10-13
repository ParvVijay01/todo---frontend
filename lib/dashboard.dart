import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:todo/config.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login_page.dart';


class Dashboard extends StatefulWidget {
  final token;
  const Dashboard({@required this.token, super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String userId;
  TextEditingController _todoTitle = TextEditingController();
  TextEditingController _todoDesc = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

    userId = jwtDecodedToken['_id'];
  }

  void addTodo() async {
    if(_todoTitle.text.isNotEmpty && _todoDesc.text.isNotEmpty){
      var regBody = {
        "userid": userId,
        "title": _todoTitle.text,
        "desc": _todoDesc.text
      };

      var response = await http.post(Uri.parse(addtodo),
          headers: {"Content-Type": "application/json"},
          body:jsonEncode(regBody)
      );

      var jsonresponse = jsonDecode(response.body);

      print(jsonresponse['status']);

      if(jsonresponse['status']){
        _todoTitle.clear();
        _todoDesc.clear();
        Navigator.pop(context);}
       else{
        print("Something went wrong!!");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(userId),
            ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayTextInputDialog(context),
        child: const Icon(Icons.add),
        tooltip: 'Add-ToDo',
      ),
    );
  }


  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add To-Do'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _todoTitle,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                      )
                  ),
                ).p4().px8(),
                TextField(
                  controller: _todoDesc,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Description",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                      )
                  ),
                ).p4().px8(),
                ElevatedButton(onPressed: (){
                  addTodo();
                }, child: const Text('Add'))
              ],
            ),
          );
        }
    );
  }
}

