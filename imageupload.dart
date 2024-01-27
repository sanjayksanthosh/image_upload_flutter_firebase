import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadPage extends StatefulWidget {
  const ImageUploadPage({Key? key}) : super(key: key);

  @override
  State<ImageUploadPage> createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  String? img;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
      Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
          img ==null?CircularProgressIndicator():Image.network(img!),
          ElevatedButton(onPressed: ()async{
            ImagePicker imagePicker = ImagePicker();
            XFile? file =
                await imagePicker.pickImage(source: ImageSource.camera);
            print('${file?.path}');

            if (file == null) return;
            //Import dart:core
            String uniqueFileName =
            DateTime.now().millisecondsSinceEpoch.toString();
            Reference referenceRoot = FirebaseStorage.instance.ref();
            Reference referenceDirImages =
            referenceRoot.child('images');

            //Create a reference for the image to be stored
            Reference referenceImageToUpload =
            referenceDirImages.child(uniqueFileName+".png");

            //Handle errors/success
            try {
              //Store the file
              await referenceImageToUpload.putFile(File(file.path));
              //Success: get the download URL
             var imageUrl = await referenceImageToUpload.getDownloadURL();

             print(imageUrl);
             setState(() {
               img = imageUrl;
             });
            } catch (error) {
              //Some error occurred
            }

          }, child: Text("press"))
        ]),
      ),);
  }
}
