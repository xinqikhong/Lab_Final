import 'dart:convert';
import 'dart:developer';

import 'package:barterit/view/buyercartscreen.dart';
import 'package:barterit/view/buyerorderscreen.dart';
import 'package:barterit/view/itemdetailscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/config.dart';
import '../model/item.dart';
import '../model/user.dart';

class BuyerTabScreen extends StatefulWidget {
  final User user;
  const BuyerTabScreen({super.key, required this.user});

  @override
  State<BuyerTabScreen> createState() => _BuyerTabScreenState();
}

class _BuyerTabScreenState extends State<BuyerTabScreen> {
  String maintitle = "Buyer";
  List <Item> itemList = <Item>[];
  //List itemlist = [];
  String titlecenter = "Loading data...";
  late double screenHeight, screenWidth, resWidth;
  late int axiscount = 2;
  int numofpage = 1, curpage = 1;
  int numberofresult = 0;
  var color;
  int cartqty = 0;
  //final df = DateFormat('dd/MM/yyyy hh:mm a');

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print("User ID: ${widget.user.id}");
    loadItems();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    showsearchDialog();
                  },
                  icon: const Icon(Icons.search)),
              TextButton.icon(
                icon: const Icon(
                  Icons.shopping_cart, color: Colors.white
                ),
                label: Text(cartqty.toString(), style: const TextStyle(color: Colors.white),), // Your text here
                onPressed: () async {
                  if (cartqty > 0) {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (content) => BuyerCartScreen(
                                  user: widget.user,
                                )));
                    loadItems();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("No item in cart")));
                  }
                },
              ),
              PopupMenuButton(
                  // add icon, by default "3 dot" icon
                  // icon: Icon(Icons.book)
                  itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("My Order"),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text("New"),
                  ),
                ];
              }, onSelected: (value) async {
                if (value == 0) {
                  if (widget.user.id.toString() == "na") {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Please login/register an account")));
                    return;
                  }
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => BuyerOrderScreen(
                                user: widget.user,
                              )));
                } else if (value == 1) {
                } else if (value == 2) {}
              }),
            ],
          ),
          
        ],
      ),
      body: itemList.isEmpty
          ? const Center(
              child: Text(
                "No Data",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Column(
              children: [
                Container(
                  height: 24,
                  color: Theme.of(context).colorScheme.primary,
                  alignment: Alignment.center,
                  child: Text(
                    //"$numberofresult Items Found",
                    "${_getDisplayText(numberofresult)} Found",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: axiscount,
                    children: List.generate(itemList.length, (index) {
                      Item item = itemList[index];
                      return Card(
                        child: InkWell(
                          onTap: () async {
                                Item useritem =
                                    Item.fromJson(item.toJson());
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) =>
                                            ItemDetailScreen(
                                              user: widget.user,
                                              useritem: useritem, page: curpage,
                                            )));
                                //loadAllItems(1);
                                loadItems();
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
                    },),
                  ),
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
                          //loadAllItems(index + 1);
                          loadItems();
                        },
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(color: color, fontSize: 18),
                        ));
                  },
                ),
              ),
              ],
            ),
    );
  }

  /*String truncateString(String str) {
    if (str.length > 15) {
      str = str.substring(0, 15);
      return str + "...";
    } else {
      return str;
    }
  }*/

  String _getDisplayText(int count) {
    if (count == 1) {
      return "1 Item";
    } else {
      return "$count Items";
    }
  }

  /*void loadAllItems(int pg) {
    http.post(Uri.parse("${Config.server}/barterit/php/load_item.php"),
        body: {
          "cartuserid": widget.user.id,
          "pageno": pg.toString()
        }).then((response) {
        log(response.body);
        itemList.clear();
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          if (jsondata['status'] == "success") {
            numofpage = int.parse(jsondata['numofpage']); //get number of pages
            numberofresult = int.parse(jsondata['numberofresult']);
            print(numberofresult);
            var extractdata = jsondata['data'];
            /*cartqty = int.parse(jsondata['cartqty'].toString());
            print(cartqty);*/
            extractdata['items'].forEach((v) {
              itemList.add(Item.fromJson(v));
            });
            print(itemList[0].itemName);
          }
          setState(() {});
        }
      }
    );
  }*/

  void loadItems() {
    http.post(Uri.parse("${Config.server}/barterit/php/load_item.php"),
        body: {
          "cartuserid": widget.user.id,
          "pageno": curpage.toString()
        }).then((response) {
        itemList.clear();
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          print('Response Body: $jsondata'); 
          if (jsondata['status'] == "success") {
            numofpage = int.parse(jsondata['numofpage']); //get number of pages
            numberofresult = int.parse(jsondata['numberofresult']);
            var extractdata = jsondata['data'];
            //cartqty = int.parse(jsondata['cartqty'].toString());
            if (jsondata['cartqty'] == "na") {
              cartqty = 0; // Set a default value when cartqty is "na"
            } else {
              cartqty = int.parse(jsondata['cartqty'].toString(), onError: (_) => 0);
            }
            extractdata['items'].forEach((v) {
              itemList.add(Item.fromJson(v));
            });
          }
          setState(() {});
        } else {
          // Add additional error handling here if needed
          print('Request failed with status code: ${response.statusCode}');
          print('Response Body: ${response.body}');
        }
      }
    );
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

  void updateCartQty(int newCartQty) {
    print("Updating cart quantity to: $newCartQty");
    setState(() {
      cartqty = newCartQty;
    });
  }

}