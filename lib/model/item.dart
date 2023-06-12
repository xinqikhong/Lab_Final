class Item {
  String? itemId;
  String? userId;
  String? itemName;
  String? itemDesc;
  String? itemValue;
  String? itemState;
  String? itemLocal;
  String? itemlat;
  String? itemlong;
  String? itemDate;

  Item(
      {required this.itemId,
      required this.userId,
      required this.itemName,
      required this.itemDesc,
      required this.itemValue,
      required this.itemState,
      required this.itemLocal,
      required this.itemlat,
      required this.itemlong,
      required this.itemDate,
      });

  Item.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    userId = json['user_id'];
    itemName = json['item_name'];
    itemDesc = json['item_desc'];
    itemValue = json['item_value'];
    itemState = json['item_state'];
    itemLocal = json['item_local'];
    itemlat = json['item_lat'];
    itemlong = json['item_long'];
    itemDate = json['item_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_id'] = itemId;
    data['user_id'] = userId;
    data['item_name'] = itemName;
    data['item_desc'] = itemDesc;
    data['item_value'] = itemValue;
    data['item_state'] = itemState;
    data['item_local'] = itemLocal;
    data['item_lat'] = itemlat;
    data['item_long'] = itemlong;
    data['item_date'] = itemDate;
    return data;
  }
}