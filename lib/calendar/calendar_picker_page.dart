import 'package:drawing_interface_learning/calendar/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class CalendarPickerPage extends StatefulWidget {
  @override
  _CalendarPickerPageState createState() => _CalendarPickerPageState();
}

class _CalendarPickerPageState extends State<CalendarPickerPage> {
  DateTime _startDateTime;
  DateTime _endDateTime;
  @override
  void initState() {
    super.initState();
    _startDateTime = DateTime.now().add(Duration(days: -7));
    _endDateTime = DateTime.now();
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(375, 812), allowFontScaling: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("选择时间"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
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
