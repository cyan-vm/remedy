import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailScreen extends StatelessWidget {
  final String imageUrl;
  final String timestamp;
  final bool isFavorite;
  final Function(bool) onFavoriteToggle;

  const DetailScreen({
      Key? key,
      required this.imageUrl,
      required this.timestamp,
      required this.isFavorite,
      required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          fit: StackFit.expand,
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
            Positioned(
              bottom: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Timestamp: $timestamp',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 60,
              right: 70,
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.pink,
                ),
                onPressed: () {
                  // Toggle the favorite state and update in Firestore
                  onFavoriteToggle(!isFavorite);
                },
              ),
            ),
            Positioned(
              bottom: 60,
              right: 20,
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // Find the document reference by imageUrl
                  var documentReference = FirebaseFirestore.instance.collection('images').where('imageUrl', isEqualTo: imageUrl);

                  documentReference.get().then((querySnapshot) {
                      querySnapshot.docs.forEach((doc) {
                          doc.reference.delete();
                      });
                  });

                  // After deleting, navigate back to the previous screen
                  Navigator.pop(context); // Close the detail screen
                },
                color: Colors.red, // Change color to red
              ),

            ),
            Positioned(
              top: 20,
              left: 20,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
