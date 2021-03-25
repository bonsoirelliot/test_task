import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';

class ShopScreenModel extends Model {
  bool canSwipe = true;
  int pages_count;
  List<Item> items = new List<Item>();
  String url = 'https://d-element.ru/test_api.php';

  Future<void> getData() async {
    var response = await http.get(url);

    if (response.statusCode == 200) {
      items = (json.decode(response.body)['items'] as List)
          .map((e) => Item.fromJson(e))
          .toList();

      pages_count =
          items.length % 6 == 0 ? (items.length) ~/ 6 : (items.length) ~/ 6 + 1;
      return items;
    }
  }

  void setBoolTrue() {
    canSwipe = true;
    notifyListeners();
  }

  void setBoolFalse() {
    canSwipe = false;
    notifyListeners();
  }

  int item_count(int pagenum) {
    if (items.length % 6 == 0) {
      return 6;
    } else {
      int c = items.length ~/ 6;
      if (pagenum < c) {
        return 6;
      } else {
        return items.length % 6;
      }
    }
  }
}

class Item {
  int id;
  String name;
  double price;
  int article;
  String image;

  Item(this.id, this.name, this.article, this.image, this.price);

  factory Item.fromJson(dynamic json) {
    return Item(json['id'], json['name'], json['article'], json['image'],
        json['price'] != null ? double.parse(json['price'].toString()) : 0);
  }
}
