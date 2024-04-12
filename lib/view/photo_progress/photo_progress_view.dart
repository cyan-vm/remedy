import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../common/colo_extension.dart';
import '../../common_widget/round_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import '/view/detail_screen.dart';

class PhotoProgressView extends StatefulWidget {
  const PhotoProgressView({Key? key}) : super(key: key);

  @override
  State<PhotoProgressView> createState() => _PhotoProgressViewState();
}

class _PhotoProgressViewState extends State<PhotoProgressView> {
  GlobalKey<FormState> key = GlobalKey();

  CollectionReference _reference =
  FirebaseFirestore.instance.collection('images'); // Updated collection reference

  List<String> selectedPhotos = [];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    String currentDate = DateFormat('MMMM dd, yyyy').format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leadingWidth: 0,
        leading: const SizedBox(),
        title: Text(
          "Progress Photo",
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              if (selectedPhotos.length == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ComparePhotosView(
                      photoUrls: selectedPhotos,
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please select two photos to compare.'),
                ));
              }
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 70, // increased width to accommodate text
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Compare",
                style: TextStyle(
                  color: TColor.gray,
                  fontSize: 12,
                ),
              ),
            ),
          )
        ],
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Gallery",
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ), // Adjust the height between the Row and the text below
                  Text(
                    currentDate,
                    style: TextStyle(
                      color: TColor.gray,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: _reference.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Placeholder while loading
                      }

                      // If there are no images
                      if (snapshot.data == null ||
                        snapshot.data!.docs.isEmpty) {
                        return Text('No images found.');
                      }

                      // Display images
                      // Inside the StreamBuilder where you display images
                      // Inside the StreamBuilder where you display images
                      // Inside the StreamBuilder where you display images
                      return GridView.count(
                        crossAxisCount: 3, // Number of columns
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: snapshot.data!.docs.map((doc) {
                            var imageUrl = doc['imageUrl'];
                            var isFavorite = doc['isFavorite'] ?? false;
                            var isSelected = selectedPhotos.contains(imageUrl); // Check if image is selected
                            return Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailScreen(
                                          imageUrl: imageUrl,
                                          timestamp: doc['timestamp'],
                                          isFavorite: isFavorite,
                                          onFavoriteToggle: (newValue) {
                                            // Update isFavorite value in Firestore
                                            doc.reference.update({'isFavorite': newValue});
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: TColor.lightGray,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        imageUrl,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: IconButton(
                                    icon: Icon(
                                      isFavorite ? Icons.favorite : Icons.favorite_border,
                                      color: isFavorite ? Colors.red : null,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                          // Toggle the favorite state
                                          isFavorite = !isFavorite;
                                          // Update the favorite state in Firestore
                                          doc.reference.update({'isFavorite': isFavorite});
                                      });
                                    },
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: Column(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          isFavorite ? Icons.favorite : Icons.favorite_border,
                                          color: isFavorite ? Colors.red : null,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                              // Toggle the favorite state
                                              isFavorite = !isFavorite;
                                              // Update the favorite state in Firestore
                                              doc.reference.update({'isFavorite': isFavorite});
                                          });
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                                          color: isSelected ? Colors.blue : null,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                              // Toggle the selection state
                                              if (isSelected) {
                                                selectedPhotos.remove(imageUrl);
                                              } else {
                                                selectedPhotos.add(imageUrl);
                                              }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                        }).toList(),
                      );

                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () async {
          print('this is a test');
          print('this is a test');
          ImagePicker imagePicker = ImagePicker();
          XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
          print('${file?.path}');

          if (file == null) return;
          FirebaseStorage storage = FirebaseStorage.instance;
          Reference ref = storage.ref().child('images/${DateTime.now()}.jpg');
          UploadTask uploadTask = ref.putFile(File(file.path));

          uploadTask.then((res) {
              res.ref.getDownloadURL().then((url) {
                  // New code: Get current date
                  DateTime currentDate = DateTime.now();
                  String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
                  // Save image URL and date to Firestore
                  _reference.add({'imageUrl': url, 'timestamp': formattedDate, 'isFavorite': false});
              });
          });
        },
        child: Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: TColor.secondaryG),
            borderRadius: BorderRadius.circular(27.5),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))],
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.photo_camera,
            size: 20,
            color: TColor.white,
          ),
        ),
      ),
    );
  }
}

class ComparePhotosView extends StatelessWidget {
  final List<String> photoUrls;

  const ComparePhotosView({Key? key, required this.photoUrls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compare Photos'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(
              photoUrls[0],
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Image.network(
              photoUrls[1],
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
