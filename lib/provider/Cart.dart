import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/Storage.dart';

class Cart with ChangeNotifier {
  List _cartList = [];
  bool _isCheckedAll = false;
  double _allPrice = 0;

  List get cartList => this._cartList;
  bool get isCheckedAll => this._isCheckedAll;
  double get allPrice => this._allPrice;

  Cart() {
    this.init();
  }

  init() async {
    try {
      List cartListData = json.decode(await Storage.getString('cartList'));
      this._cartList = cartListData;
    } catch (e) {
      this._cartList = [];
    }
    this._isCheckedAll = this.isCheckAll();
    this.computeAllPrice();

    notifyListeners();
  }

  updateCartList() {
    this.init();
  }

  itemCountChange() {
    Storage.setString("cartList", json.encode(this._cartList));
    this.computeAllPrice();

    notifyListeners();
  }

  checkAll(value) {
    for (var i = 0; i < this._cartList.length; i++) {
      this._cartList[i]["checked"] = value;
    }
    this._isCheckedAll = value;
    this.computeAllPrice();
    Storage.setString("cartList", json.encode(this._cartList));
    notifyListeners();
  }

  bool isCheckAll() {
    if (this._cartList.length > 0) {
      for (var i = 0; i < this._cartList.length; i++) {
        if (this._cartList[i]["checked"] == false) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  itemChage() {
    if (this.isCheckAll() == true) {
      this._isCheckedAll = true;
    } else {
      this._isCheckedAll = false;
    }

    this.computeAllPrice();
    Storage.setString("cartList", json.encode(this._cartList));
    notifyListeners();
  }

  computeAllPrice() {
    double tempAllPrice = 0;
    for (var i = 0; i < this._cartList.length; i++) {
      if (this._cartList[i]["checked"] == true) {
        tempAllPrice += this._cartList[i]["price"] * this._cartList[i]["count"];
      }
    }
    this._allPrice = tempAllPrice;
    notifyListeners();
  }

  removeItem() {
    List tempList=[];
    for (var i = 0; i < this._cartList.length; i++) {
      if (this._cartList[i]["checked"] == false) {
        tempList.add(this._cartList[i]);
      }
    }
    this._cartList=tempList;
    this.computeAllPrice();
    Storage.setString("cartList", json.encode(this._cartList));
    notifyListeners();
  }
}
