import 'package:drawing_interface_learning/tab_test/controller_dropDownButton.dart';
import 'package:flutter/material.dart';
class MyDropdownMenuBuilder {
  final Widget dropDownWidget;
  final double dropDownHeight;

  MyDropdownMenuBuilder({@required this.dropDownWidget, @required this.dropDownHeight});
}

typedef DropdownMenuChange = void Function(bool isShow, int index);

class MyDropdownMenu extends StatefulWidget {
  final MyDropdownMenuController controller;
  final MyDropdownMenuBuilder menus;
  final int animationMilliseconds;
  final Color maskColor;
  final DropdownMenuChange dropdownMenuChanging;
  final DropdownMenuChange dropdownMenuChanged;

  const MyDropdownMenu({Key key,
    @required this.controller,
    @required  this.menus,
    this.animationMilliseconds,
    this.maskColor = const Color.fromRGBO(0, 0, 0, 0.2),
    this.dropdownMenuChanging,
    this.dropdownMenuChanged}) : super(key: key);
  @override
  _MyDropdownMenuState createState() => _MyDropdownMenuState();
}

class _MyDropdownMenuState extends State<MyDropdownMenu> with SingleTickerProviderStateMixin{
  bool _isShowDropDownItemWidget = false;
  bool _isShowMask = false;
  bool _isControllerDisposed = false;
  Animation<double> _animation;
  AnimationController _controller;

  double _dropDownHeight;
  double _maskColorOpacity;
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onController);
    _controller = new AnimationController(duration: Duration(milliseconds: widget.animationMilliseconds), vsync: this);

  }
  _onController(){
    _isShowDropDownItemWidget = !_isShowDropDownItemWidget;
    if (!_isShowMask) {
      _isShowMask = true;
    }
    _dropDownHeight = widget.menus.dropDownHeight;
    _animation?.removeListener(_animationListener);
    _animation?.removeStatusListener(_animationStatusListener);
    _animation = new Tween(begin: 0.0, end: _dropDownHeight).animate(_controller)
      ..addListener(_animationListener)
      ..addStatusListener(_animationStatusListener);

    if (_isControllerDisposed) return;
    if (widget.controller.isShow) {
      _controller.forward();
    } else if (widget.controller.isShowHideAnimation) {
      _controller.reverse();
    } else {
      _controller.value = 0;
    }
  }
  @override
  dispose() {
    super.dispose();
    _animation?.removeListener(_animationListener);
    _animation?.removeStatusListener(_animationStatusListener);
    widget.controller?.removeListener(_onController);
    _controller?.dispose();
    _isControllerDisposed = true;
    if (_isControllerDisposed) return;
  }
  void _animationListener() {
    var heightScale = _animation.value / _dropDownHeight;
    _maskColorOpacity = widget.maskColor.opacity * heightScale;
//    print('$_maskColorOpacity');
    //这行如果不写，没有动画效果
    setState(() {});
  }
  void _animationStatusListener(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.dismissed:
//        print('dismissed');
        _isShowMask = false;
        break;
      case AnimationStatus.forward:
        break;
      case AnimationStatus.reverse:
        break;
      case AnimationStatus.completed:
//        print('completed');
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Positioned(
        width:MediaQuery.of(context).size.width,
        top: widget.controller.dropDownHeaderHeight,
        left: 0,
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: _animation == null ? 0 : _animation.value,
              child: widget.menus.dropDownWidget,
            ),
            _mask()
          ],
        ));
  }
  Widget _mask() {
    if (_isShowMask) {
      return GestureDetector(
        onTap: () {
          widget.controller.hide();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: widget.maskColor.withOpacity(_maskColorOpacity),
//          color: widget.maskColor,
        ),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }
}
