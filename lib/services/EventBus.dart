import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class ProductContentEvent{
  String str;
  ProductContentEvent(String str){
    this.str=str;
  }
}

class UserEvent{
  String str;
  UserEvent(String str){
    this.str=str;
  }
}

class AddressEvent{
  String str;
  AddressEvent(String str){
    this.str=str;
  }
}

class CheckOutEvent{
  String str;
  CheckOutEvent(String str){
    this.str=str;
  }
}
