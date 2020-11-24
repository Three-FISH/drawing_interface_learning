import 'package:drawing_interface_learning/calendar/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:write_text/write_text.dart';

class CalendarPickerPage extends StatefulWidget {
  @override
  _CalendarPickerPageState createState() => _CalendarPickerPageState();
}

class _CalendarPickerPageState extends State<CalendarPickerPage> with SingleTickerProviderStateMixin{
  DateTime _startDateTime;
  DateTime _endDateTime;
  AnimationController _controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _startDateTime = DateTime.now().add(Duration(days: -7));
    _endDateTime = DateTime.now();
    _controller = AnimationController(
      duration:Duration(seconds: 2),
      vsync: this
    );
    animation = new Tween(begin: 100.0,end: 200.0).animate(_controller);
    _controller.forward();
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("选择时间"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: GestureDetector(
              onTap: (){
                showDateTimePicker(
                  context,
                  onConfirm: (dateTime){
                    if (mounted) {
                      setState(() {
                          _startDateTime = dateTime;
                      });
                    }
                  }
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 10
                ),
                child: _renderDateTimeWidgetText(true),
              ),
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context ,Widget child){
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  height: 45,
                  width: animation.value,
                  alignment: Alignment.center,
                  child: _controller.value == 1.0
                  ? WriteText(
                     data:"集合吧，动物森友会!",
                     textStyle: TextStyle(fontSize: 16,color: Colors.white),
                     cursor: Container(
                       height: 16,
                       width: 2,
                       color: Colors.white,
                   ),
                  )
                      :Container(),
                );
              },

            ),

          )
        ],
      ),
    );
  }
  //开始时间和结束时间文字展示
  Widget _renderDateTimeWidgetText(bool isStartDateTime) {
    DateTime dateTime;
    if (isStartDateTime) {
      dateTime = _startDateTime;
    } else {
      dateTime = _endDateTime;
    }
    return Text(
      '${dateTime.year}年-${dateTime.month.toString().padLeft(2, '0')}月-${dateTime.day.toString().padLeft(2, '0')}日',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: ScreenUtil().setSp(14),
        decoration: TextDecoration.underline,
      ),
    );
  }
}
