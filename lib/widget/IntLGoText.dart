import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../services/ScreenAdapter.dart';

class IntLGoText extends StatelessWidget {

  final String text;
  final bool password;
  final Object onChanged;
  final int maxLines;
  final double height;
  final TextEditingController controller;

  IntLGoText({Key key,this.text="输入内容",this.password=false,this.onChanged,this.maxLines=1,this.height=68,this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller:controller,
        maxLines:this.maxLines ,
        obscureText: this.password,
        decoration: InputDecoration(
            hintText: this.text,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none),
        ),
        onChanged: this.onChanged,
      ),
      height: ScreenAdapter.height(this.height),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 1,
                  color: Colors.black12
              )
          )
      ),
    );
  }
}
