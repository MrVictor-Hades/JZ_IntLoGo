import 'dart:async';//Timer定时器需要引入
import 'package:flutter/material.dart';
import '../widget/IntLGoText.dart';
import '../widget/IntLGoButton.dart';
import '../services/ScreenAdapter.dart';
import '../config/Config.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';


// ignore: must_be_immutable
class RegisterSecondPage extends StatefulWidget {
  Map arguments;
  RegisterSecondPage({Key key,this.arguments}) : super(key: key);

  _RegisterSecondPageState createState() => _RegisterSecondPageState();
}

class _RegisterSecondPageState extends State<RegisterSecondPage> {
  String tel;
  bool sendCodeBtn=false;
  int seconds=60;
  String code;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.tel=widget.arguments['tel'];
    this._showTimer();
  }

  //倒计时
  _showTimer(){
    Timer t;
    t=Timer.periodic(Duration(milliseconds:1000), (timer){
      setState(() {
        this.seconds--;
      });
      if(this.seconds==0){
        t.cancel(); //清除定时器
        setState(() {
          this.sendCodeBtn=true;
        });
      }
    });

  }
  //重新发送验证码
  sendCode() async {
    setState(() {
      this.sendCodeBtn=false;
      this.seconds=60;
      this._showTimer();
    });
    var api = '${Config.domain}api/sendCode';
    var response = await Dio().post(api, data: {"tel": this.tel});
    if (response.data["success"]) {
      print(response);
    }
  }

  validateCode() async{

    var api = '${Config.domain}api/validateCode';
    var response = await Dio().post(api, data: {"tel": this.tel,"code": this.code});
    if (response.data["success"]) {
      Navigator.pushNamed(context, '/registerThird');
    }else{
      Fluttertoast.showToast(
        msg: '${response.data["message"]}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("用户注册-第二步"),
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenAdapter.width(20)),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 50),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text("验证码已经发送到了您的${this.tel}手机，请输入${this.tel}手机号收到的验证码"),
            ),
            SizedBox(height:40),
            Stack(
              children: <Widget>[
                IntLGoText(
                  text: "请输入验证码",
                  onChanged: (value) {
                    // print(value);
                    this.code=value;
                  },
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  // ignore: deprecated_member_use
                  child: this.sendCodeBtn?RaisedButton(
                    child: Text('重新发送'),
                    onPressed: this.sendCode,
                  // ignore: deprecated_member_use
                  ):RaisedButton(
                    child: Text('${this.seconds}秒后重发'),
                    onPressed: (){

                    },
                  ),
                )

              ],
            ),
            SizedBox(height: 20),
            IntLGoButton(
              text: "下一步",
              color: Colors.red,
              height: 74,
              cb: this.validateCode,
            )
          ],
        ),
      ),
    );
  }
}
