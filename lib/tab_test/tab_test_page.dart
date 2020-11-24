import 'package:drawing_interface_learning/tab_test/widget_dropMenu.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'controller_dropDownButton.dart';
import 'widget_dropButtom.dart';
class SortCondition {
  String name;
  bool isSelected;

  SortCondition({this.name, this.isSelected});
}

class TabTestPage extends StatefulWidget {
  @override
  _TabTestPageState createState() => _TabTestPageState();
}

class _TabTestPageState extends State<TabTestPage> with TickerProviderStateMixin{
  List<SortCondition> _disTestSortConditions = [];
  SortCondition _selectGridSortCondition;
  List<String> tabTestData =[
    "全部",
    "语文",
    "数学",
    "英语",
    "政治",
    "化学",
    "物理",
    "音乐",
    "美术",
    "体育"
  ];
  int initialTabIndex;
  String dropDownValue = "全部";
  TabController _tabController;
  MyDropdownMenuController _dropdownMenuController = MyDropdownMenuController();
  GlobalKey _myStackKey = GlobalKey();

  @override
  void initState() {
    super.initState();
     initialTabIndex = 0;
    _tabController = TabController(initialIndex: initialTabIndex,length: tabTestData.length,vsync: this);
    _tabController.addListener(() {
      setState(() {
        dropDownValue = tabTestData[_tabController.index];
      });
    });
    _disTestSortConditions.add(SortCondition(name:"全部",isSelected: true));
    _disTestSortConditions.add(SortCondition(name:"语文",isSelected: true));
    _disTestSortConditions.add(SortCondition(name:"数学",isSelected: true));
    _disTestSortConditions.add(SortCondition(name:"英语",isSelected: true));
    _disTestSortConditions.add(SortCondition(name:"政治",isSelected: true));
    _disTestSortConditions.add(SortCondition(name:"化学",isSelected: true));
    _disTestSortConditions.add(SortCondition(name:"物理",isSelected: true));
    _disTestSortConditions.add(SortCondition(name:"音乐",isSelected: true));
    _disTestSortConditions.add(SortCondition(name:"美术",isSelected: true));
    _disTestSortConditions.add(SortCondition(name:"体育",isSelected: true));

    _selectGridSortCondition = _disTestSortConditions[0];
  }
  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        key: _myStackKey,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10,),
              Row(
                children: <Widget>[
                  Flexible(
                    child:TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabs: tabTestData.map((e) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 6),
                            child: Text(e,style: TextStyle(fontSize: 20),),
                          ),
                        );
                      }).toList(),
                      labelColor: Colors.deepOrange,
                      unselectedLabelColor: Colors.grey,
                      indicatorSize:TabBarIndicatorSize.label,
                      indicatorWeight: 4.0,
                    ) ,
                  ),
                  MyDropdownButton(
                    initTab: dropDownValue,
                    controller: _dropdownMenuController,
                    stackKey: _myStackKey,
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                    dropDownStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,),
                    iconColor: Colors.indigo,
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: tabTestData.isEmpty
                      ?[]
                      :tabTestData.map(
                          (e) {
                        return Center(
                          child: Text(e),
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
          MyDropdownMenu(
              controller: _dropdownMenuController,
              animationMilliseconds: 300,
              menus: MyDropdownMenuBuilder(
                  dropDownHeight: 10.0 * _disTestSortConditions.length,
                  dropDownWidget: _buildGridWidget(_disTestSortConditions, (value) {
                    _selectGridSortCondition = value;
                    dropDownValue = _selectGridSortCondition.name;
                    _dropdownMenuController.hide();
                    _tabController.index = tabTestData.indexOf(dropDownValue);
                    setState(() {
                    });
                  })
              )
          )
        ],
      ),
    );
  }
  _buildGridWidget(items, void itemOnTap(SortCondition sortCondition)){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: GridView.custom(
        physics : NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          //单个子Widget的水平最大宽度
            maxCrossAxisExtent: 60,
            //水平单个子Widget之间间距
            mainAxisSpacing: 4.0,
            //垂直单个子Widget之间间距
            crossAxisSpacing: 4.0,
            childAspectRatio: 2.0
        ),
        childrenDelegate: SliverChildBuilderDelegate((context, position) {
          SortCondition gridSortCondition = items[position];
          return GestureDetector(
            onTap: () {
              for (var value in items) {
                value.isSelected = false;
              }
              gridSortCondition.isSelected = true;
              itemOnTap(gridSortCondition);
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: gridSortCondition.isSelected? Colors.blue:Colors.deepOrange
              ),
              alignment: Alignment.center,
              child: Text(
                gridSortCondition.name,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          );
        },
            childCount: items.length
        ),
      ),
    );
  }
}
