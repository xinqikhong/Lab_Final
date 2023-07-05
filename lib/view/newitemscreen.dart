import 'dart:convert';
import 'package:barterit/view/youritemscreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multiple_images_picker/multiple_images_picker.dart';
import '../model/config.dart';
import '../model/user.dart';
import 'mainscreen.dart';
//import 'package:sn_progress_dialog/sn_progress_dialog.dart';


class NewItemScreen extends StatefulWidget {
  final User user;
  const NewItemScreen({super.key, required this.user});

  @override
  State<NewItemScreen> createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
  bool _isChecked = false;
  double screenHeight = 0.0, screenWidth = 0.0;
  final _formKey = GlobalKey<FormState>();
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  final TextEditingController _itemNameEditingController =
      TextEditingController();
  final TextEditingController _itemDescEditingController =
      TextEditingController();
  final TextEditingController _itemValueEditingController =
      TextEditingController();
  final TextEditingController _itemStateEditingController =
      TextEditingController();
  final TextEditingController _itemLocalEditingController =
      TextEditingController();
  File? _image;
  var pathAsset = "assets/images/camera.jpg";
  late Position _currentPosition;
  String curloc = "";
  String curstate = "";
  String itemlat = "";
  String itemlong = "";
  final List<File?> _images = List.generate(3, (_) => null);

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text('New Item'),
        ),
        body: Column(
          children: [
            Flexible(
              flex: 4,
              child: 
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      width: 410,
                      height: 1200,
                      child: GestureDetector(
                        onTap: (){_selectImage(context, 0);},
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Card(
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: _images[0] == null
                                      ? AssetImage(pathAsset)
                                      : FileImage(_images[0]!) as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(                     
                      //flex: 10,
                      width: 410,
                      height: 1000,
                      child: GestureDetector(
                        onTap: () {_selectImage(context, 1);},
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Card(
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: _images[1] == null
                                      ? AssetImage(pathAsset)
                                      : FileImage(_images[1]!) as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      //flex: 10,
                      width: 410,
                      height: 1200,
                      child: GestureDetector(
                        onTap: (){_selectImage(context, 2);},
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Card(
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: _images[2] == null
                                      ? AssetImage(pathAsset)
                                      : FileImage(_images[2]!) as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text(
                          "Add Item Details",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          validator: (val) => val!.isEmpty || (val.length < 3)
                            ? "Item name must be longer than 3"
                            : null,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(focus);
                          },
                          controller: _itemNameEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                            labelText: 'Item Name',
                            labelStyle: TextStyle(
                            ),
                            icon: Icon(Icons.shopping_bag_rounded),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                              width: 2.0),
                            )
                          )
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          validator: (val) => val!.isEmpty || (val.length < 10)
                            ? "Item description must be longer than 10"
                            : null,
                          focusNode: focus,
                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(focus1);},
                          maxLines: 3,
                          controller: _itemDescEditingController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            labelText: 'Item Description',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.edit_document),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            )
                          )
                        ),
                        Row(
                          children: [
                            Flexible(
                              flex: 5,
                              child: TextFormField(
                              //...product value
                                textInputAction: TextInputAction.done,
                                validator: (val) => val!.isEmpty /*|| (val.length < 3)*/
                                  ? "Product value must contain value"
                                  : null,
                                focusNode: focus1,
                                /*onFieldSubmitted: (v) {
                                  FocusScope.of(context).requestFocus(focus2);
                                },*/
                                controller: _itemValueEditingController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Item Value (RM)',
                                  labelStyle: TextStyle(
                                  ),
                                  icon: Icon(Icons.money),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2.0
                                    ),
                                  )
                                )
                              )
                            ),
                            Flexible(
                              flex: 5,
                              child: CheckboxListTile(
                                title: const Text("Lawfull Item?"), //    <‐‐ label
                                value: _isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isChecked = value!;
                                  });
                                },
                              )
                            ),                     
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              flex: 5,
                              child: TextFormField(
                                //...product state
                                textInputAction: TextInputAction.next,
                                validator: (val) => val!.isEmpty || (val.length < 3)
                                  ? "Current State"
                                  : null,
                                enabled: false,
                                controller: _itemStateEditingController,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  labelText: 'Current States',
                                  labelStyle: TextStyle(
                                  ),
                                  icon: Icon(Icons.flag),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                     width: 2.0
                                    ),
                                  )
                                )
                              )
                            ),
                            Flexible(
                              flex: 5,
                              child: TextFormField(
                                //...product locality
                                textInputAction: TextInputAction.next,
                                enabled: false,
                                validator: (val) => val!.isEmpty || (val.length < 3)
                                  ? "Current Locality"
                                  : null,
                                controller: _itemLocalEditingController,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  labelText: 'Current Locality',
                                  labelStyle: TextStyle(
                                  ),
                                  icon: Icon(Icons.location_city_rounded),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2.0
                                    ),
                                  )
                                )
                              )
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(screenWidth, screenHeight / 13)
                          ),
                          child: const Text('Add Item'),
                          onPressed: () => {
                            _newItemDialog(),
                          },
                        ),
                      ],
                    )
                  )
                )
              )
            )
          ],
        )
      );
  }

  void _selectImage(BuildContext context, int imageIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: const Text(
            "Select from",
            style: TextStyle(
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(screenWidth / 4, screenHeight / 6)
                ),
                child: const Text('Gallery'),
                onPressed: () => {
                  Navigator.of(context).pop(),
                  _selectfromGallery(imageIndex),
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(screenWidth / 4, screenHeight / 6)
                ),
                child: const Text('Camera'),
                onPressed: () => {
                  Navigator.of(context).pop(),
                  _selectFromCamera(imageIndex),
                },
              ),
            ],
          )
        );
      },
    );
  }
  
  Future<void> _selectfromGallery(int imageIndex) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
    //List<XFile>? pickedFiles = await picker.pickMultiImage(
      source: ImageSource.gallery,
      maxHeight: 1200,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage(imageIndex);
    } else {
      // ignore: avoid_print
      print('No image selected.');
    }
  }
  
  Future<void> _selectFromCamera(int imageIndex) async {
    final picker = ImagePicker();
    //List<XFile>? pickedFiles = await picker.pickMultipleImages(
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1200,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage(imageIndex);
    } else {
      // ignore: avoid_print
      print('No image selected.');
    }
  }      
  
  Future<void> _cropImage(int imageIndex) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        // CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        // CropAspectRatioPreset.original,
        //CropAspectRatioPreset.ratio4x3,
        // CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.blueAccent,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio3x2,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      int? sizeInBytes = _image?.lengthSync();
      double sizeInMb = sizeInBytes! / (1024 * 1024);
      print(sizeInMb);
      if (imageIndex == 0){
        _images[0] = _image;
      } else if (imageIndex == 1){
        _images[1] = _image;
      }else{
        _images[2] = _image;
      }
      
      setState(() {});
    }
  }

    void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied.');
    }
    _currentPosition = await Geolocator.getCurrentPosition();
    _getAddress(_currentPosition);
    //return await Geolocator.getCurrentPosition();
  }

  _getAddress(Position pos) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks.isEmpty) {
      _itemLocalEditingController.text = "Changlun";
      _itemStateEditingController.text = "Kedah";
      itemlat = "6.443455345";
      itemlong = "100.05488449";
    } else {
      _itemLocalEditingController.text = placemarks[0].locality.toString();
      _itemStateEditingController.text =
          placemarks[0].administrativeArea.toString();
      itemlat = _currentPosition.latitude.toString();
      itemlong = _currentPosition.longitude.toString();
    }
    setState(() {});
  }

  void _newItemDialog() {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
        msg: "Please fill in all the required fields",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 14.0);
      return;
    }

    for (int i = 0; i < _images.length; i++) {
      if (_images[i] == null) {
        Fluttertoast.showToast(
            msg: "Please insert three images.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            //backgroundColor: Colors.red,
            //textColor: Colors.white,
            fontSize: 14.0);
        return;
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Add this item?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                addNewItem();
                //registerUser();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void addNewItem() {
    String itemName = _itemNameEditingController.text;
    String itemDesc = _itemDescEditingController.text;
    String itemValue = _itemValueEditingController.text;
    String itemState = _itemStateEditingController.text;
    String itemLocality = _itemLocalEditingController.text;
    String base64Image = base64Encode(_images[0]!.readAsBytesSync());

      http.post(Uri.parse("${Config.server}/barterit/php/add_item.php"),
          body: {
            "userid": widget.user.id.toString(),
            "itemName": itemName,
            "itemDesc": itemDesc,
            "itemValue": itemValue,
            "state": itemState,
            "locality": itemLocality,
            "latitude": itemlat,
            "longitude": itemlong,
            //"images": jsonEncode([base64Image]),
            "image": base64Image
            //"image[$i]": base64Image,
          }).then((response) {
            //var responseBody = response.body.replace("array(9)", "")
            //print(response.body);
            var responseBody = response.body;
            responseBody = responseBody.replaceFirst("array(9)", "");
            print('Response status code: ${response.statusCode}');
            print('Response body: ${response.body}');
            print("line 655");

            if (response.statusCode == 200) {
              //final jsonResponse = json.decode(responseBody);
              //print('Decoded response: $jsonResponse');
              print("line 660");
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Add Success")));
              Navigator.pop(context);
              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (content) => MainScreen(user: widget.user)));
          } else {
            print("HTTP request failed with status code: ${response.statusCode}");
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Add Failed")));
            Navigator.pop(context);
          }
          });
  }

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }
}