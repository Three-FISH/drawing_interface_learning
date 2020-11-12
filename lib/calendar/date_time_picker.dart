import 'dart:math';

import 'package:drawing_interface_learning/common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'picker.dart' as picker;

showDateTimePicker(
    BuildContext context, {
      DateTime initial,
      Function(DateTime) onConfirm,
      Function onCancel,
    }) {
  assert(context != null);

  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      enableDrag: false,
      builder: (BuildContext context) {
        return WillPopScope(
            child:
            _DateTimePicker(initialDateTime: initial, onConfirm: onConfirm),
            onWillPop: () async {
              onCancel?.call();
              return true;
            });
      });
}

/// 高度像素比，用于适配屏幕高度
double _hpx = UISize.screenHeight / 812;

/// 宽度像素比，用于适配屏幕宽度
double _wpx = UISize.screenWidth / 375;

String _twoDig(int data) {
  if (data == null) return '';
  return data >= 10 ? '$data' : '0$data';
}

class _DateTimePicker extends StatefulWidget {
  final DateTime initialDateTime;
  final ValueChanged<DateTime> onConfirm;

  _DateTimePicker({this.initialDateTime, this.onConfirm});

  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<_DateTimePicker>
    with SingleTickerProviderStateMixin {
  /// true 时间控件 显示为日期模式 false 显示为时间模式
  bool _dateMode = true;

  /// 顶部小蓝条平移动画
  Animation<num> _translateAnimation;

  /// 顶部小蓝条缩放动画
  Animation<num> _scaleAnimation;

  /// 顶部TabBar左边颜色动画
  Animation<Color> _colorLeftAnimation;
  Animation<Color> _colorRightAnimation;
  AnimationController _controller;

  /// 进场与退场动画
  Animation<double> _slideDateAnimation;
  Animation<double> _slideTimeAnimation;

  /// 用户选择的时间
  DateTime _currentDateTime;

  String _selectHour;
  String _selectMinute;

  @override
  void initState() {
    final now = DateTime.now();
    _currentDateTime = widget.initialDateTime ?? now;
    _selectHour = widget.initialDateTime == null
        ? '${_twoDig(now.hour)}'
        : '${_twoDig(widget.initialDateTime.hour)}';
    _selectMinute = widget.initialDateTime == null
        ? '${_twoDig(now.minute)}'
        : '${_twoDig(widget.initialDateTime.minute)}';
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _scaleAnimation =
        Tween(begin: _wpx * 115.5, end: _wpx * 39.5).animate(_controller);
    _translateAnimation =
        Tween(begin: 0.0, end: _wpx * 131).animate(_controller);
    _colorLeftAnimation =
        ColorTween(begin: const Color(0xFF333333), end: const Color(0xFFAFB9CF))
            .animate(_controller);
    _colorRightAnimation =
        ColorTween(begin: const Color(0xFFAFB9CF), end: const Color(0xFF333333))
            .animate(_controller);

    _slideDateAnimation =
        Tween<double>(begin: UISize.screenWidth, end: 0).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.fastOutSlowIn,
          reverseCurve: Curves.fastOutSlowIn,
        ));
    _slideTimeAnimation =
        Tween<double>(begin: 0, end: UISize.screenWidth).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.fastOutSlowIn,
          reverseCurve: Curves.fastOutSlowIn,
        ));
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: UISize.screenWidth,
        height: _hpx * 357.5,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6*_wpx),
              topRight: Radius.circular(6*_wpx),
            )),
        child: Column(
          children: [
            Container(
              height: _hpx * 60,
              padding: EdgeInsets.symmetric(horizontal: 17 * _wpx),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: _hpx * 58,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(

                            onTap: () {
                              _onChangedUiMode(true);
                            },
                            behavior: HitTestBehavior.translucent,
                            child: Container(
                              width: _wpx * 115.5,
                              child: Column(
                                children: [
                                  Spacer(),
                                  AnimatedBuilder(
                                    animation: _colorLeftAnimation,
                                    builder: (_, __) {
                                      return Text(
                                          '${_currentDateTime?.year}年${_twoDig(_currentDateTime?.month)}月${_twoDig(_currentDateTime?.day)}日',
                                          style: TextStyle(
                                              color: _colorLeftAnimation.value,
                                              fontSize: 15*_wpx,
                                              fontWeight: FontWeight.w600));
                                    },
                                  ),
                                  Spacer()
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: _wpx * 15.5,
                          ),
                          GestureDetector(
                            onTap: () {
                              _onChangedUiMode(false);
                            },
                            child: Container(
                              width: _wpx * 39.5,
                              child: Column(
                                children: [
                                  Spacer(),
                                  AnimatedBuilder(
                                      animation: _colorRightAnimation,
                                      builder: (_, __) {
                                        return Text(
                                          '$_selectHour:$_selectMinute',
                                          style: TextStyle(
                                              color: _colorRightAnimation.value,
                                              fontSize: 14*_wpx,
                                              fontWeight: FontWeight.w600),
                                        );
                                      }),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ),
                          Expanded(child: Container()),
                          GestureDetector(
                              onTap: _onTapConfirmButton,
                              child: Center(
                                child: Text(
                                  '确定',
                                  style: TextStyle(
                                      color: const Color(0xFF2888FF),
                                      fontSize: 15*_wpx,
                                      fontWeight: FontWeight.w600),
                                ),
                              ))
                        ],
                      )),
                  Container(
                    height: 2 * _hpx,
                    width: UISize.screenWidth - 170.5 * _wpx,
                    child: Row(
                      children: [
                        AnimatedBuilder(
                            animation: _controller,
                            builder: (_, __) {
                              return Container(
                                margin: EdgeInsets.only(
                                    left: _translateAnimation.value),
                                color: const Color(0xFF2486FF),
                                width: _scaleAnimation.value,
                                height: 2 * _hpx,
                              );
                            })
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 1*_wpx,
              color: const Color(0xFFEFF4F8),
            ),
            Expanded(
                child: _dateMode
                    ? AnimatedBuilder(
                    animation: _slideDateAnimation,
                    builder: (_, __) {
                      return Row(
                        children: [
                          _DatePicker(
                            width: _slideDateAnimation.value,
                            initial: _currentDateTime,
                            onSelectedDate: (value, isClickDate) {
                              setState(() {
                                _currentDateTime = value;
                                if (isClickDate) {
                                  _dateMode = false;
                                  if (_controller.status ==
                                      AnimationStatus.completed) {
                                    _controller?.reverse();
                                  } else {
                                    _controller?.forward();
                                  }
                                }
                              });
                            },
                          )
                        ],
                      );
                    })
                    : AnimatedBuilder(
                    animation: _slideTimeAnimation,
                    builder: (_, __) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _TimePicker(
                            width: _slideTimeAnimation.value,
                            selectHour: _selectHour,
                            selectMinute: _selectMinute,
                            onHourSelected: _onHourSelected,
                            onMinuteSelected: _onMinuteSelected,
                          )
                        ],
                      );
                    }))
          ],
        ));
  }

  _onChangedUiMode(bool isDateMode) {
    if (isDateMode) {
      if (_dateMode) return;
    } else {
      if (!_dateMode) return;
    }
    if (_controller.status == AnimationStatus.completed) {
      _controller?.reverse();
    } else {
      _controller?.forward();
    }

    setState(() {
      _dateMode = isDateMode;
    });
  }

  _onTapConfirmButton() {
    widget.onConfirm?.call(DateTime(
      _currentDateTime.year,
      _currentDateTime.month,
      _currentDateTime.day,
      int.parse(_selectHour),
      int.parse(_selectMinute),
    ));
    Navigator.of(context).pop();
  }

  _onSelectedDate(DateTime value, bool isClickDate) {
    setState(() {
      _currentDateTime = value;
      if (isClickDate) {
        _dateMode = false;
        if (_controller.status == AnimationStatus.completed) {
          _controller?.reverse();
        } else {
          _controller?.forward();
        }
      }
    });
  }

  _onHourSelected(String value) {
    setState(() {
      _selectHour = value;
    });
  }

  _onMinuteSelected(String value) {
    setState(() {
      _selectMinute = value;
    });
  }
}

class _DatePicker extends StatefulWidget {
  final DateTime initial;
  final Function(DateTime, bool) onSelectedDate;
  final double width;

  _DatePicker({this.width, this.initial, this.onSelectedDate});

  @override
  __DatePickerState createState() => __DatePickerState();
}

class __DatePickerState extends State<_DatePicker> {
  /// 日期模式标题
  List<String> _titles = ['日', '一', '二', '三', '四', '五', '六'];

  /// 当前显示的天数的列表
  List<DateTime> _days = [];

  /// 当前列表中属于本月份的第一个下标
  int _currentMonthIndex = 0;

  /// 当前列表中本月份的长度
  int _currentMonthLength = 0;

  /// 用于无限滚动目前只能前后滚动50000000次

  int _pageViewLength = 100000000;
  int _showPageIndex;

  /// 定义初始化滚动页
  PageController _pageController;

  /// 用户选择的时间
  DateTime _currentDateTime;

  final double _minTextScale = 1.0;
  double _textScale = 1.0;
  MediaQueryData _data;

  @override
  void initState() {
    _showPageIndex = _pageViewLength ~/ 2;
    _pageController = PageController(initialPage: _showPageIndex);
    _initDate(dateTime: widget.initial ?? DateTime.now());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final data = MediaQuery.of(context);
    _textScale = min(_minTextScale, data.textScaleFactor);
    _data = data.copyWith(textScaleFactor: _textScale);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant _DatePicker oldWidget) {
    if (widget.initial.millisecondsSinceEpoch !=
        oldWidget.initial.millisecondsSinceEpoch) {
      _pageController?.dispose();
      _pageController = PageController(initialPage: _showPageIndex);
      _initDate(dateTime: widget.initial ?? DateTime.now());
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _titles.clear();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: _data,
      child: Container(
        width: widget.width ?? UISize.screenWidth,
        height: 296.5 * _hpx,
        child: PageView.builder(
            controller: _pageController,
            itemCount: 100000000,
            onPageChanged: _onPageChanged,
            itemBuilder: (_, index) {
              var i = 0;
              return Wrap(
                spacing: 0,
                alignment: WrapAlignment.center,
                runSpacing: 0,
                runAlignment: WrapAlignment.center,
                children: [..._titles, ..._days].map((e) {
                  i++;
                  if (e is String)
                    return Container(
                      width: (UISize.screenWidth - 30 * _wpx) / 7,
                      height: 296.5 / 7 * _hpx,
                      child: Center(
                        child: Text(
                          e,
                          style: TextStyle(
                              fontSize: 11*_wpx,
                              color: const Color(0xFF333333),
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    );
                  if (e is DateTime)
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _currentDateTime = e;
                          if (i < _currentMonthIndex ||
                              i >
                                  (_currentMonthIndex +
                                      _currentMonthLength -
                                      1)) {
                            _days = _getShowDateArray(dateTime: e);
                          }
                        });
                        widget.onSelectedDate?.call(
                            DateTime(
                              _currentDateTime.year,
                              _currentDateTime.month,
                              _currentDateTime.day,
                            ),
                            true);
                      },
                      child: Container(
                        width: (UISize.screenWidth - 30 * _wpx) / 7,
                        height: 296.5 / 7 * _hpx,
                        child: Center(
                            child: _days[_currentMonthIndex]?.month ==
                                e.month &&
                                e.day == 1
                                ? Builder(builder: (_) {
                              if (_isSameDay(_currentDateTime, e))
                                return Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2888FF),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(4*_wpx)),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${e.month}',
                                          style: TextStyle(
                                              fontSize: 12*_wpx,
                                              color: Colors.white,
                                              fontWeight:
                                              FontWeight.w600),
                                        ),
                                        Text(
                                          '月',
                                          style: TextStyle(
                                              fontSize: 8*_wpx,
                                              color: Colors.white,
                                              fontWeight:
                                              FontWeight.w400),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              return Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${e.month}',
                                    style: TextStyle(
                                        fontSize: 12*_wpx,
                                        color: const Color(0xFF2888FF),
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '月',
                                    style: TextStyle(
                                        fontSize: 8*_wpx,
                                        color: const Color(0xFF2888FF),
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              );
                            })
                                : _isSameDay(_currentDateTime, e)
                                ? Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2888FF),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4*_wpx)),
                              ),
                              child: Center(
                                child: Text(
                                  '${e.day}',
                                  style: TextStyle(
                                      fontSize: 14*_wpx,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            )
                                : _isSameDay(DateTime.now(), e)
                                ? Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0x552888FF),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4*_wpx)),
                              ),
                              child: Center(
                                child: Text(
                                  '${e.day}',
                                  style: TextStyle(
                                      fontSize: 14*_wpx,
                                      color:
                                      const Color(0xFF2888FF),
                                      fontWeight:
                                      FontWeight.w400),
                                ),
                              ),
                            )
                                : Text(
                              '${e.day}',
                              style: TextStyle(
                                  fontSize: 14*_wpx,
                                  color: _days[_currentMonthIndex]
                                      ?.month !=
                                      e.month
                                      ? const Color(0xFFAFB9CF)
                                      : const Color(0xFF333333),
                                  fontWeight: FontWeight.w400),
                            )),
                      ),
                    );
                  throw 'Unknown data type';
                }).toList(),
              );
            }),
      ),
    );
  }

  void _initDate({DateTime dateTime}) {
    assert(dateTime != null);
    _currentDateTime = dateTime;
    _days.clear();
    setState(() {
      _days = _getShowDateArray(dateTime: _currentDateTime);
    });
  }

  void _onPageChanged(int index) {
    var offset = index - _showPageIndex;
    DateTime dateTime;
    if (offset < 0) {
      dateTime = _previousMonth(_days[_currentMonthIndex]);
      _currentDateTime = _getPreviousMonth(_currentDateTime);
    } else {
      dateTime = _nextMonth(_days[_currentMonthIndex]);
      _currentDateTime = _getNextMonth(_currentDateTime);
    }
    _days = _getShowDateArray(dateTime: dateTime);
    _showPageIndex = index;
    setState(() {});
    widget.onSelectedDate?.call(
        DateTime(
          _currentDateTime.year,
          _currentDateTime.month,
          _currentDateTime.day,
        ),
        false);
  }

  List<DateTime> _getShowDateArray({DateTime dateTime}) {
    List<DateTime> dates = [];
    final firstDayOfMonth = _firstDayOfMonth(dateTime);
    final weekday = firstDayOfMonth.weekday;
    final lenOfPreMonth = weekday == 7 ? 0 : weekday;
    for (var i = lenOfPreMonth; i > 0; i--) {
      dates.add(firstDayOfMonth.subtract(Duration(days: i)));
    }
    _currentMonthIndex = lenOfPreMonth;
    final lastDayOfMonth = _lastDayOfMonth(dateTime);
    _currentMonthLength = lastDayOfMonth.day - firstDayOfMonth.day + 1;
    for (var i = 0; i < 42 - lenOfPreMonth; i++) {
      dates.add(firstDayOfMonth.add(Duration(days: i)));
    }
    return dates;
  }

  DateTime _firstDayOfMonth(DateTime month) {
    return DateTime(month.year, month.month);
  }

  DateTime _lastDayOfMonth(DateTime month) {
    var beginningNextMonth = (month.month < 12)
        ? DateTime(month.year, month.month + 1, 1)
        : DateTime(month.year + 1, 1, 1);
    return beginningNextMonth.subtract(Duration(days: 1));
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  DateTime _previousMonth(DateTime m) {
    var year = m.year;
    var month = m.month;
    if (month == 1) {
      year--;
      month = 12;
    } else {
      month--;
    }
    return DateTime(year, month);
  }

  DateTime _getPreviousMonth(DateTime m) {
    var year = m.year;
    var month = m.month;
    var day = m.day;
    if (month == 1) {
      year--;
      month = 12;
    } else {
      month--;
    }
    var dateTime = DateTime(year, month);
    var lastDay = _lastDayOfMonth(dateTime).day;
    if (day > lastDay) {
      day = lastDay;
    }
    return DateTime(year, month, day);
  }

  DateTime _getNextMonth(DateTime m) {
    var year = m.year;
    var month = m.month;
    var day = m.day;
    if (month == 12) {
      year++;
      month = 1;
    } else {
      month++;
    }
    var dateTime = DateTime(year, month);
    var lastDay = _lastDayOfMonth(dateTime).day;
    if (day > lastDay) {
      day = lastDay;
    }
    return DateTime(year, month, day);
  }

  DateTime _nextMonth(DateTime m) {
    var year = m.year;
    var month = m.month;

    if (month == 12) {
      year++;
      month = 1;
    } else {
      month++;
    }
    return DateTime(year, month);
  }
}

class _TimePicker extends StatefulWidget {
  final String selectHour;
  final String selectMinute;
  final Function(String) onHourSelected;
  final Function(String) onMinuteSelected;
  final double width;

  _TimePicker(
      {this.width,
        this.selectHour,
        this.selectMinute,
        this.onHourSelected,
        this.onMinuteSelected});

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<_TimePicker> {
  List<String> _hours;
  List<String> _minutes;

  FixedExtentScrollController _hourController;
  FixedExtentScrollController _minuteController;

  String _selectHour;
  String _selectMinute;

  @override
  void initState() {
    _selectHour = widget.selectHour ?? '${_twoDig(DateTime.now().hour)}';
    _selectMinute = widget.selectMinute ?? '${_twoDig(DateTime.now().minute)}';
    _hours = List.generate(24, (index) => _twoDig(index));
    _minutes = List.generate(60, (index) => _twoDig(index));
    final selectedHourIndex = widget.selectHour != null
        ? _hours.indexOf(widget.selectHour)
        : _hours.indexOf(_twoDig(DateTime.now().hour));
    final selectedMinuteIndex = widget.selectMinute != null
        ? _minutes.indexOf(widget.selectMinute)
        : _minutes.indexOf(_twoDig(DateTime.now().minute));
    _hourController =
        FixedExtentScrollController(initialItem: selectedHourIndex);
    _minuteController =
        FixedExtentScrollController(initialItem: selectedMinuteIndex);
    super.initState();
  }

  @override
  void dispose() {
    _hours?.clear();
    _minutes?.clear();
    _hourController?.dispose();
    _minuteController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);
    final pickerTextStyle = cupertinoTheme.textTheme.pickerTextStyle
        .copyWith(fontSize: 14*_wpx, color: const Color(0xFF2888FF));
    final textTheme =
    cupertinoTheme.textTheme.copyWith(pickerTextStyle: pickerTextStyle);
    return Container(
      width: widget.width ?? UISize.screenWidth,
      height: 296.5 * _hpx,
      child: Center(
        child: CupertinoTheme(
          data: cupertinoTheme.copyWith(
            textTheme: textTheme,
          ),
          child: Container(
            height: 39 * 5 * _hpx,
            width: 123 * _wpx,
            child: Row(
              children: [
                Expanded(child: Builder(builder: (_) {
                  var i = 0;
                  return picker.CupertinoPicker(
                    scrollController: _hourController,
                    backgroundColor: Colors.transparent,
                    diameterRatio: 1,
                    itemExtent: 39 * _hpx,
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        _selectHour = _hours[index];
                      });
                      widget.onHourSelected?.call(_selectHour);
                    },
                    children: _hours?.map((e) {
                      i++;
                      final _currentIndex = _hours.indexOf(_selectHour);
                      return Container(
                        padding: EdgeInsets.only(
                            left: 15 * _wpx, right: 15 * _wpx),
                        child: Center(
                          child: Text(
                            e,
                            style: TextStyle(
                                fontSize: 15*_wpx,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                color: (i - 1) == _currentIndex
                                    ? const Color(0xFF2888FF)
                                    : const Color(0xFFAFB9CF)),
                          ),
                        ),
                      );
                    })?.toList() ??
                        [],
                    looping: true,
                  );
                })),
                Expanded(child: Builder(
                  builder: (_) {
                    var i = 0;
                    return picker.CupertinoPicker(
                      scrollController: _minuteController,
                      backgroundColor: Colors.transparent,
                      diameterRatio: 1,
                      itemExtent: 39 * _hpx,
                      onSelectedItemChanged: (int index) {
                        setState(() {
                          _selectMinute = _minutes[index];
                        });
                        widget.onMinuteSelected?.call(_selectMinute);
                      },
                      children: _minutes?.map((e) {
                        i++;
                        final _currentIndex =
                        _minutes.indexOf(_selectMinute);
                        return Container(
                          padding: EdgeInsets.only(
                              left: 15 * _wpx, right: 15 * _wpx),
                          child: Center(
                            child: Text(
                              e,
                              style: TextStyle(
                                  fontSize: 15*_wpx,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  color: (i - 1) == _currentIndex
                                      ? const Color(0xFF2888FF)
                                      : const Color(0xFFAFB9CF)),
                            ),
                          ),
                        );
                      })?.toList() ??
                          [],
                      looping: true,
                    );
                  },
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
