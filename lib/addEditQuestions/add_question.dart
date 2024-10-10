import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddQuestion extends StatefulWidget {
  DataSnapshot? data ;
  AddQuestion({super.key, this.data});
  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {


  String correctAns = "";
  late DatabaseReference _question;
  TextEditingController _questionController = TextEditingController();
  TextEditingController _option1Controller = TextEditingController();
  TextEditingController _option2Controller = TextEditingController();
  TextEditingController _option3Controller = TextEditingController();
  TextEditingController _option4Controller = TextEditingController();
  String? correctOption;

  void submitQuestion() async{
    if (_questionController.text.isEmpty ||
        _option1Controller.text.isEmpty ||
        _option2Controller.text.isEmpty ||
        _option3Controller.text.isEmpty ||
        _option4Controller.text.isEmpty ||
        correctOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and select the correct option'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      String id = DateTime.now().microsecondsSinceEpoch.toString();
      try{
        if(widget.data != null){
          _question.child(widget.data!.child("id").value.toString()).update(
              {
                "id":widget.data!.child("id").value.toString(),
                "title":_questionController.text,
                "options":[
                  _option1Controller.text,
                  _option2Controller.text,
                  _option3Controller.text,
                  _option4Controller.text
                ],
                "answer":correctAns.toString(),
              }
          );
        }else{
          await  _question.child(id).set(
              {
                "id":id.toString(),
                "title":_questionController.text,
                "options":[
                  _option1Controller.text,
                  _option2Controller.text,
                  _option3Controller.text,
                  _option4Controller.text
                ],
                "answer":correctAns.toString(),
              }
          );
        }
        Navigator.pop(context);
      }catch(e){
        print("eerrrr$e");
      }
      // Handle the question submission logic here
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text(widget.data!=null?"Question Updated successfully!":'Question added successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  setInitial(){
    if(widget.data != null){
      _questionController.text  = widget.data!.child("title").value.toString();
      _option1Controller.text  = widget.data!.child("options").child("0").value!.toString();
      _option2Controller.text  = widget.data!.child("options").child("1").value!.toString();
      _option3Controller.text  = widget.data!.child("options").child("2").value!.toString();
      _option4Controller.text  = widget.data!.child("options").child("3").value!.toString();
      correctOption = widget.data!.child("answer").value.toString();
      setState(() {
      });
    }


  }

  @override
  void initState() {
    print("${widget.data}");
    _question = FirebaseDatabase.instance.ref('question');
    setInitial();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data != null?"Edit Question":'Add Question'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (val){
                setState(() {
                  correctOption = null;
                });
              },
              controller: _questionController,
              decoration: InputDecoration(
                labelText: 'Enter Question',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (val){
                setState(() {
                  correctOption = null;
                });
              },
              controller: _option1Controller,
              decoration: InputDecoration(
                labelText: 'Enter Option 1',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              onChanged: (val){
                setState(() {
                  correctOption = null;
                });
              },
              controller: _option2Controller,
              decoration: InputDecoration(
                labelText: 'Enter Option 2',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              onChanged: (val){
                setState(() {
                  correctOption = null;
                });
              },
              controller: _option3Controller,
              decoration: InputDecoration(
                labelText: 'Enter Option 3',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              onChanged: (val){
                setState(() {
                  correctOption = null;
                });
              },
              controller: _option4Controller,
              decoration: InputDecoration(
                labelText: 'Enter  Option 4',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            PopupMenuButton<String>(
              onSelected: (value) {
                if(value == "Option 1"){
                  correctAns = _option1Controller.text;
                }else if(value == "Option 2"){
                  correctAns = _option2Controller.text;
                }else if(value == "Option 3"){
                  correctAns = _option3Controller.text;
                }else{
                  correctAns = _option4Controller.text;
                }
                print("correct ans ${correctAns}");
                setState(() {
                  correctOption = value;
                  print("value $value");
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'Option 1',
                  child: Text('Option 1'),
                ),
                PopupMenuItem<String>(
                  value: 'Option 2',
                  child: Text('Option 2'),
                ),
                PopupMenuItem<String>(
                  value: 'Option 3',
                  child: Text('Option 3'),
                ),
                PopupMenuItem<String>(
                  value: 'Option 4',
                  child: Text('Option 4'),
                ),
              ],
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text(
                      correctOption ?? 'Select Correct Option',
                      style: TextStyle(
                        color: Colors.teal,
                        fontSize: 16,
                      ),
                    ),
                    Icon(Icons.arrow_drop_down_sharp)
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: submitQuestion,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: Text(widget.data != null?"Update Question":'Submit Question'),
              ),
            ),
        ])
      ),
    );
  }
}