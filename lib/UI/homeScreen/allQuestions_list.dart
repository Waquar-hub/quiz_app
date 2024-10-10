import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:quiz_task/addEditQuestions/add_question.dart';

class QuestionsList extends StatefulWidget {
  const QuestionsList({super.key});

  @override
  State<QuestionsList> createState() => _QuestionsListState();
}

class _QuestionsListState extends State<QuestionsList> {

  var ref = FirebaseDatabase.instance.ref("question");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Of Questions"),
      ),
      body: Column(children: [
        const SizedBox(height: 30,),
        Expanded(child: FirebaseAnimatedList(
          defaultChild:const Center(
            child: CircularProgressIndicator(),
          ),
          query: ref, itemBuilder: (context,
            snapshot,animation,index){
          return ListTile(
            title: Text(snapshot.child("title").value.toString()),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if(value == "Edit"){
                  Navigator.push(context,MaterialPageRoute(builder: (context) => AddQuestion(data:  snapshot ,))).then((va){
                  });
                }else{
                  ref.child(snapshot.child('id').value.toString()).remove();
                }
                setState(() {

                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'Edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem<String>(
                  value: 'Delete',
                  child: Text('Delete'),
                ),
              ],
            ),
          );

        },))
      ],),
    );
  }
}
