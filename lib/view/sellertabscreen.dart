import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../model/config.dart';
import '../model/item.dart';
import '../model/user.dart';
import 'newitemscreen.dart';
import 'package:http/http.dart' as http;
import 'edititemscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SellerTabScreen extends StatefulWidget {
  final User user;
  const SellerTabScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<SellerTabScreen> createState() => _SellerTabScreenState();
}

class _SellerTabScreenState extends State<SellerTabScreen> {
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  late List<Widget> tabchildren;
  List<Item> itemList = <Item>[];
  String maintitle = "Seller";
  int numofpage = 1, curpage = 1;
  int numberofresult = 0;
  var color;
  
  TextEditingController searchController = TextEditingController();
  //late List<Widget> tabchildren;


  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(maintitle),
        actions: [
          IconButton(
              onPressed: () {
                showsearchDialog();
              },
              icon: const Icon(Icons.search)),
        ],
      ),
      body: itemList.isEmpty
            ? const Center(
                child: Text('No Data',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
            : Column (
                children: [
                  Container(
                    height: 24,
                    color: Theme.of(context).colorScheme.primary,
                    alignment: Alignment.center,
                    child: Text(
                      "${_getDisplayText(itemList.length)} Found",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: axiscount,
                      children: List.generate(
                        itemList.length,
                        (index) {
                          return Card(
                            child: InkWell(
                              onLongPress: () {
                                onDeleteDialog(index);
                              },
                              onTap: () async {
                                Item singleitem =
                                Item.fromJson(itemList[index].toJson());
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (content) => EditItemScreen(
                                      user: widget.user,
                                      useritem: singleitem,
                                    )
                                  )
                                );
                                loadOwnerItem(1);
                              },
                              child: Column(
                                children: [
                                  CachedNetworkImage(
                                    width: screenWidth,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                    "${Config.server}/barterit/images/items/${itemList[index].itemId}.png",
                                    placeholder: (context, url) =>
                                    const LinearProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                  ),
                                  const SizedBox(
                                    height: 5
                                  ),
                                  Text(
                                    itemList[index].itemName.toString(),
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  const SizedBox(
                                    height: 3
                                  ),
                                  Text(
                                    "RM ${double.parse(itemList[index].itemPrice.toString()).toStringAsFixed(2)}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "${itemList[index].itemQty} in stock",
                                    style: const TextStyle(fontSize: 14),
                                  ),

                                  /*Text(
                                    "${itemList[index].itemLocal.toString()}, ${itemList[index].itemState.toString()}",
                                    style: const TextStyle(fontSize: 14),
                                  ),*/
                                ]
                              ),
                            ),
                          );
                        },
                      )
                    )
                  ),
                  SizedBox(
                height: 50,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: numofpage,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    //build the list for textbutton with scroll
                    if ((curpage - 1) == index) {
                      //set current page number active
                      color = Colors.red;
                    } else {
                      color = Colors.black;
                    }
                    return TextButton(
                        onPressed: () {
                          curpage = index + 1;
                          loadOwnerItem(index + 1);
                        },
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(color: color, fontSize: 18),
                        ));
                  },
                ),
              ),
                ]
              ),
              //],
            //)
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.add),
            label: "New Item",
            labelStyle: const TextStyle(),
            onTap: _newItem 
          ),
        ],
      ),
    );
  }

  String _getDisplayText(int count) {
    if (count == 1) {
      return "1 Item";
    } else {
      return "$count Items";
    }
  }

  void showsearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Search?",
            style: TextStyle(),
          ),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
                controller: searchController,
                decoration: const InputDecoration(
                    labelText: 'Search',
                    labelStyle: TextStyle(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0),
                    ))),
            const SizedBox(
              height: 4,
            ),
            ElevatedButton(
                onPressed: () {
                  String search = searchController.text;
                  searchItem(search);
                  Navigator.of(context).pop();
                },
                child: const Text("Search"))
          ]),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
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

  void searchItem(String search) {
    http.post(Uri.parse("${Config.server}/barterit/php/load_item.php"),
        body: {
          "cartuserid": widget.user.id,
          "search": search
        }).then((response) {
      //print(response.body);
      log(response.body);
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });
          numberofresult = int.parse(jsondata['numberofresult']);
          print(itemList[0].itemName);
        }
        setState(() {});
      }
    });
  }

  void _newItem() {
    if (widget.user.email == "na") {
      Fluttertoast.showToast(
        msg: "Only registered account can use this feature",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1, 
        fontSize: 14.0
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => NewItemScreen(user: widget.user)
      )
    );
  }

  void loadOwnerItem(int pg) {
    if (widget.user.id == "na") {
      setState(() {
        // titlecenter = "Unregistered User";
      });
      return;
    }

    http.post(Uri.parse("${Config.server}/barterit/php/load_item.php"),
        body: {"userid": widget.user.id}).then((response) {
      //print(response.body);
      log(response.body);
      //itemList = <Item>[];
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          numofpage = int.parse(jsondata['numofpage']); //get number of pages
          numberofresult = int.parse(jsondata['numberofresult']);
          print(numberofresult);
          var extractdata = jsondata['data'];
          if (extractdata.containsKey('items')) {
            extractdata['items'].forEach((v) {
              itemList.add(Item.fromJson(v));
            });
            print(itemList[0].itemName);
            print("line 171");
          } else {
            print("No items found");
          }
        } else {
          print("API request failed");
        }
        setState(() {});
      } else{
        print("API request failed with status code: ${response.statusCode}");
      }
    });
  }

  void onDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Delete ${itemList[index].itemName}?",
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                deleteItem(index);
                Navigator.of(context).pop();
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

  void deleteItem(int index) {
    http.post(Uri.parse("${Config.server}/barterit/php/delete_item.php"),
        body: {
          "userid": widget.user.id,
          "itemid": itemList[index].itemId
        }).then((response) {
      print(response.body);
      //catchList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Success")));
          loadOwnerItem(1);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed")));
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadOwnerItem(1);
    //print("Owner");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

}