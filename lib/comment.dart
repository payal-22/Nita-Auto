import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsSection extends StatefulWidget {
  @override
  _CommentsSectionState createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final TextEditingController _commentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String currentUserId =
      "some_user_id"; // Replace this with the actual logged-in user ID

  Future<void> _addComment() async {
    if (_commentController.text.isEmpty) return;

    User? user =
        FirebaseAuth.instance.currentUser; // Get the current authenticated user

    if (user != null) {
      await _firestore.collection('comments').add({
        'userId': user.uid, // Use the actual logged-in user ID
        'comment': _commentController.text,
        'timestamp': Timestamp.now(),
      });

      _commentController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("You must be logged in to submit a comment."),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _commentController,
          decoration: InputDecoration(labelText: 'Add a comment'),
        ),
        ElevatedButton(
          onPressed: _addComment,
          child: Text('Submit'),
        ),
        SizedBox(height: 20),
        Text('Comments:', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        // Use a fixed height container for the comment list
        Container(
          height: 250, // Fixed height for the list of comments
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('comments')
                .orderBy('timestamp')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Text('Loading comments...');

              final comments = snapshot.data!.docs;

              return ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return ListTile(
                    title: Text(comment['comment']),
                    subtitle: Text('User ID: ${comment['userId']}'),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
