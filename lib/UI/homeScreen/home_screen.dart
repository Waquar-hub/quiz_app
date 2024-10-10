import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quiz_task/addEditQuestions/add_question.dart';
import 'package:quiz_task/auth/login_screen.dart';
import 'package:quiz_task/storage/shared_preferences.dart';

import '../score_board.dart';
import 'allQuestions_list.dart';

class QuestionScreen extends StatefulWidget {
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  String selectedOption = '';

  bool dataFetched = false;
  bool signOut = true;

  double totalScore = 0;
  double highestScore = 0;
  final TextEditingController _questionController = TextEditingController();
  String question = 'What is the capital of France?';
  getData() async{
    var ref = FirebaseDatabase.instance.ref("question");
    DatabaseEvent event = await ref.once();
    Map<dynamic, dynamic>? data = event.snapshot.value as Map<dynamic, dynamic>?;
    print("data ${data}");
    if (data != null) {
      setState(() {
        questions = data.entries.map((e) {
          return {
            'id': e.key,
            'title': e.value['title'],
            'options': List<String>.from(e.value['options']),
            'answer': e.value['answer'],
          };
        }).toList();
      });
      dataFetched = true;
      setState(() {
      });
    }
    print("question $questions");
  }

  @override
  void initState() {
    getData();
    super.initState();
    _questionController.text = question;
    if(UserSharedPreferences.getScore() == null){

    }else{
      highestScore = UserSharedPreferences.getScore()!;
    }
    print(highestScore);
    // Pre-fill with default question
  }

  // Submit the current answer
  void submitAnswer() {
    if (selectedOption.isNotEmpty) {

      // Move to next question if available
      if (currentQuestionIndex < questions.length - 1) {
        setState(() {
          selectedOption = '';
          currentQuestionIndex++;
        });
      } else {
        // Show a message if there are no more questions
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You have completed all the questions!'),
            duration: Duration(seconds: 2),
          ),
        );
        if(UserSharedPreferences.getScore() == null){
          UserSharedPreferences.setScore(totalScore);
        }else if(UserSharedPreferences.getScore()! < totalScore){
          UserSharedPreferences.setScore(totalScore);
        }
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return QuizResultScreen(totalQuestions: questions.length, correctAnswers: totalScore/10, wrongAnswers: (questions.length - (totalScore/10)), totalScore: totalScore,);
        }));
      }
    } else {
      // Show an error message if no option is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an option'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void addQuestion() {
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return AddQuestion();
    })).then((val){
      getData();
      _questionController.text = question;
    });
  }

  List<Map<String, dynamic>> questions = [];

  int currentQuestionIndex = 0;  // To store the selected option

  @override
  Widget build(BuildContext context) {
    var currentQuestion;
    var options;
    // Get the current question and options
    if(dataFetched == true){
       currentQuestion = questions[currentQuestionIndex];
       options = currentQuestion['options'] as List<String>;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question App'),
          actions:[
            ElevatedButton(
          onPressed: () async {
            setState(() {
              signOut = false;
            });
            await FirebaseAuth.instance.signOut();
            // Navigate the user back to the login screen or another screen

            UserSharedPreferences.clear();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(), // Replace with your HomePage widget
              ),
                  (Route<dynamic> route) => false, // This removes all previous routes
            );
          },
          child:signOut? const Text('Sign Out'):const Center(
            child: CircularProgressIndicator(),
          ),
        ),
            const SizedBox(width: 20,)
      ]
      ),
      body:dataFetched? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${currentQuestionIndex + 1}) ${currentQuestion['title']}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ...options.map((option) {
                        return RadioListTile(
                          title: Text(option),
                          value: option,
                          groupValue: selectedOption,
                          onChanged: (value) {
                            if(value == currentQuestion['answer']){
                              totalScore = totalScore  + 10;
                            }
                            setState(() {
                              selectedOption = value!;
                            });

                          },
                        );
                      }),
                      const Text("Every Question is of  10 marks",style: TextStyle(color: Colors.black54,fontSize: 16),)
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return const QuestionsList();
                  })).then((val){

                  });
                },
                child: const Text("Tap See All Questions List",style: TextStyle(color: Colors.blue,fontSize: 20),)),
            const SizedBox(height: 70),

             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text("Your Highest Score is : ",style: TextStyle(color: Colors.black54,fontSize: 20),),
                 Text(highestScore.toString(),style: TextStyle(color: Colors.red,fontSize: 20),),
               ],
             ),

            const SizedBox(height: 140),
            ElevatedButton(
              onPressed: submitAnswer,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: Text(currentQuestionIndex < questions.length - 1
                  ? 'Next Question'
                  : 'Submit Answer'),
            ),
          ],
        ),
      ):const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: addQuestion,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }
}