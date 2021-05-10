import 'dart:convert';
import 'Storage.dart';
import '../config/Config.dart';

class CartServices {
  static addCart(item) async {
    item = CartServices.formatCartData(item);
    try {
      List cartListData = json.decode(await Storage.getString('cartList'));
      bool hasData = cartListData.any((value) {
        return value['_id'] == item['_id'] &&
            value['selectedAttr'] == item['selectedAttr'];
      });

      if (hasData) {
        for (var i = 0; i < cartListData.length; i++) {
          if (cartListData[i]['_id'] == item['_id'] &&
              cartListData[i]['selectedAttr'] == item['selectedAttr']) {
            cartListData[i]["count"] = cartListData[i]["count"] + 1;
          }
        }
        await Storage.setString('cartList', json.encode(cartListData));
      } else {
        cartListData.add(item);
        await Storage.setString('cartList', json.encode(cartListData));
      }
    } catch (e) {
      List tempList = [];
      tempList.add(item);
      await Storage.setString('cartList', json.encode(tempList));
    }
  }

  static formatCartData(item) {

    String pic = item.pic;
    pic = Config.domain + pic.replaceAll('\\', '/');
    final Map data = new Map<String, dynamic>();
    data['_id'] = item.sId;
    data['title'] = item.title;

    if (item.price is int || item.price is double) {
      data['price'] = item.price;
    } else {
      data['price'] = double.parse(item.price);
    }
    data['selectedAttr'] = item.selectedAttr;
    data['count'] = item.count;
    data['pic'] = pic;
    data['checked'] = true;
    return data;
  }

  static getCheckOutData() async {
    List cartListData = [];
    List tempCheckOutData = [];
    try {
      cartListData = json.decode(await Storage.getString('cartList'));
    } catch (e) {
      cartListData = [];
    }
    for (var i = 0; i < cartListData.length; i++) {
      if (cartListData[i]["checked"] == true) {
        tempCheckOutData.add(cartListData[i]);
      }
    }

    return tempCheckOutData;
  }
}
