import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailScreen extends StatelessWidget {
  final String imageUrl;

  const DetailScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Hero(
                tag: imageUrl,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                var documentReference = FirebaseFirestore.instance.collection('imagesWithTimestamp').where('imageUrl', isEqualTo: imageUrl);

                documentReference.get().then((querySnapshot) {
                    querySnapshot.docs.forEach((doc) {
                        doc.reference.delete();
                    });
                });

                // After deleting, navigate back to the previous screen
                Navigator.pop(context); // Close the detail screen
              },
            ),
          ],
        ),
      ),
    );
  }
}
