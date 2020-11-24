import 'package:drawing_interface_learning/tab_test/controller_dropDownButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
typedef OnItemTap<T> = void Function(T value);
class MyDropdownButton extends StatefulWidget {
  //头部可选项列表
  final String initTab;
  //控制下拉目录的显示和隐藏
  final MyDropdownMenuController controller;
  //背景颜色
  final Color color;
  //背景高度
  final double height;
  //边框宽度
  final double borderWidth;
  //边框颜色
  final Color borderColor;
  //文字样式
  final TextStyle style;
  //下拉时文字样式
  final TextStyle dropDownStyle;
  //图标尺寸
  final double iconSize;
  //图标颜色
  final Color iconColor;
  //下拉图标颜色
  final Color iconDropDownColor;
  final double dividerHeight;
  final Color dividerColor;
  final GlobalKey stackKey;


  MyDropdownButton({
    Key key,
    @required this.initTab,
    @required this.controller,
    @required this.stackKey,
    this.color ,
    this.height = 40.0,
    this.borderWidth = 1,
    this.borderColor = const Color(0xFFeeede6),
    this.style = const TextStyle(color: Colors.deepOrange, fontSize: 12),
    this.dropDownStyle,
    this.iconSize = 20,
    this.iconColor,
    this.iconDropDownColor,
    this.dividerHeight = 20,
    this.dividerColor = const Color(0xFFeeede6),
   }):super(key: key);

  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> with SingleTickerProviderStateMixin{
  TextStyle _dropDownStyle;
  Color _iconDropDownColor;
  GlobalKey _keyDropDownButton = GlobalKey();
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if(mounted){
        setState(() {
        });
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
    widget.controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    _dropDownStyle = widget.dropDownStyle ?? TextStyle(color: Theme.of(context).primaryColor, fontSize: 13);
    _iconDropDownColor = widget.iconDropDownColor ?? Theme.of(context).primaryColor;

    return Container(
      key: _keyDropDownButton,
      height: widget.height,
      decoration: BoxDecoration(
        border: Border.all(color: widget.borderColor,width: widget.borderWidth)
      ),
      child: _menu(widget.initTab),
    );
  }
  _menu(String item){
    return GestureDetector(
      onTap: (){
        // print("onTap=====");
        final RenderBox overlay = widget.stackKey.currentContext.findRenderObject();
        final RenderBox dropDownItemRenderBox = _keyDropDownButton.currentContext.findRenderObject();
        var position = dropDownItemRenderBox.localToGlobal(Offset.zero, ancestor: overlay);
       //print("POSITION : $position ");
        var size = dropDownItemRenderBox.size;
       // print("SIZE : $size");
        widget.controller.dropDownHeaderHeight = size.height + position.dy;
        if (widget.controller.isShow) {
          widget.controller.hide();
          } else {
            widget.controller.show();
          }
        //    widget.controller.hide(isShowHideAnimation: false);
        setState(() {});
      },
      child: Container(
        width: 50,
        color: widget.color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      widget.initTab,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _dropDownStyle,
                    ),
                  ),
                  Icon(
                    !widget.controller.isShow ?  Icons.arrow_drop_down :  Icons.arrow_drop_up,
                    color: widget.controller.isShow ?  widget.iconColor :  widget.iconColor,
                    size:  widget.iconSize,
                  ),
                ],
              ),
            ),
            Container(
              height: widget.dividerHeight,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: widget.dividerColor, width: 1),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyDropDownHeaderItem {
  final String title;
  final IconData iconData;
  final double iconSize;
  final TextStyle style;
  MyDropDownHeaderItem(this.title, {this.iconData, this.iconSize, this.style});
}