import 'package:flutter/material.dart';
import 'package:quiz_task/storage/shared_preferences.dart';

import 'homeScreen/home_screen.dart';

class QuizResultScreen extends StatelessWidget {
  final int totalQuestions;
  final double correctAnswers;
  final double wrongAnswers;
  final double totalScore;

  const QuizResultScreen({
    Key? key,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.totalScore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              'Congratulations!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal[700],
              ),
            ),
            const SizedBox(height: 20),
            _buildResultCard(
              'Total Questions',
              totalQuestions.toString(),
              Icons.help_outline,
              Colors.orange,
            ),
            _buildResultCard(
              'Correct Answers',
              correctAnswers.toString(),
              Icons.check_circle_outline,
              Colors.green,
            ),
            _buildResultCard(
              'Wrong Answers',
              wrongAnswers.toString(),
              Icons.cancel_outlined,
              Colors.red,
            ),
            _buildResultCard(
              'Total Score',
              totalScore.toString(),
              Icons.star_border,
              Colors.purple,
            ),
            _buildResultCard(
              'Highest Score',
              UserSharedPreferences.getScore().toString(),
              Icons.star_border,
              Colors.purple,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionScreen(), // Replace with your HomePage widget
                  ),
                      (Route<dynamic> route) => false, // This removes all previous routes
                );
                // Logic to restart quiz or go to the home screen
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.teal,
              ),
              child: const Text('Play Again',style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(String label, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        trailing: Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
