import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gwacheonhs_app/models/class_data.dart';
import 'package:gwacheonhs_app/pages/app_info_page.dart';
import 'package:gwacheonhs_app/repositories/class_info_repository.dart';
import 'package:gwacheonhs_app/utils/custom_style.dart';
import 'package:gwacheonhs_app/utils/url_handler.dart';
import 'package:gwacheonhs_app/widgets/custom_appbar.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info/package_info.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PackageInfo _packageInfo = PackageInfo(version: 'unknown');
  Future<ClassData> classInfo;
  List<int> classes = [0, 0, 0]; // construct default set
  int year = DateTime.now().year;
  int _selectedGrade = 1;
  int _selectedClass = 1;
  int _changedGrade = 1;
  int _changedClass = 1;
  bool _helpExpanded = false;
  var scheduleBox = Hive.box('schedule');

  @override
  void initState() {
    super.initState();
    _fetchClassData();
    _initClassData();
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: Text("설정", style: CustomStyle.appBarTitle),
        titleSpacing: 0,
      ),
      body: Container(
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            InkWell(
              child: ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(EvaIcons.personOutline, size: 20),
                    SizedBox(width: 10),
                    Text("반 정보"),
                  ],
                ),
                trailing: ValueListenableBuilder(
                    valueListenable: Hive.box('preferences').listenable(),
                    builder: (context, box, widget) {
                      var formatted =
                          box.get('grade', defaultValue: 1).toString() +
                              '학년 ' +
                              box.get('class', defaultValue: 1).toString() +
                              '반';
                      return Text(
                        formatted,
                        style: CustomStyle.settingsClickable,
                      );
                    }),
                onTap: () => classes[0] != 0
                    ? _handleClassSelection()
                    : _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Padding(
                          padding: EdgeInsets.all(15),
                          child: Text('반 정보를 불러오는 데 실패했습니다. 잠시 후 다시 시도해주세요.',
                              style: CustomStyle.snackBar),
                        ),
                        duration: Duration(seconds: 3),
                      )),
              ),
            ),
            Divider(),
            InkWell(
              child: ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(EvaIcons.calendarOutline, size: 20),
                    SizedBox(width: 10),
                    Text("DEBUG 일정 초기화"),
                  ],
                ),
                trailing: Text(
                  "초기화",
                  style: CustomStyle.settingsClickable,
                ),
              ),
              onTap: () {
                scheduleBox.delete('events');
                print(scheduleBox.values);
              },
            ),
            Divider(),
            InkWell(
              child: ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(EvaIcons.options2Outline, size: 20),
                    SizedBox(width: 10),
                    Text("버전 정보"),
                  ],
                ),
                trailing: Text(
                  _packageInfo.version,
                  style: CustomStyle.settingsDefault,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (BuildContext context) =>
                        AppInfoPage(packageInfo: _packageInfo),
                  ),
                );
              },
            ),
            Divider(),
            InkWell(
              child: ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(EvaIcons.paperPlaneOutline, size: 20),
                    SizedBox(width: 10),
                    Text("문의하기"),
                  ],
                ),
              ),
              onTap: () {
                UrlHandler.launchBrowser("https://forms.gle/NNfLaqhc5DoHt1n67");
              },
            ),
            Divider(),
            _buildHelpExpansionList(),
          ],
        ),
      ),
    );
  }

  _handleClassSelection() {
    // handle edge case(if class data fails to load)
    if (classes[0] != 0) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return _buildGradeModal();
        },
      );
    }
  }

  Widget _buildGradeModal() {
    return Container(
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CupertinoButton(
              child: Text("취소"),
              onPressed: () {
                Navigator.pop(context);
              }),
          Expanded(
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(
                initialItem: _selectedGrade - 1,
              ),
              itemExtent: 32,
              onSelectedItemChanged: (index) {
                _changedGrade = index + 1;
              },
              children: List<Widget>.generate(classes.length, (index) {
                return Center(
                  child: Text('${index + 1}'),
                );
              }),
            ),
          ),
          CupertinoButton(
            child: Text("학년 설정"),
            onPressed: () {
              Navigator.pop(context);
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return _buildClassModal();
                  });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildClassModal() {
    return Container(
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CupertinoButton(
              child: Text("취소"),
              onPressed: () {
                Navigator.pop(context);
              }),
          Expanded(
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(
                initialItem: _selectedClass - 1,
              ),
              itemExtent: 32,
              onSelectedItemChanged: (index) {
                _changedClass = index + 1;
              },
              children: List<Widget>.generate(
                classes[_selectedGrade - 1],
                (index) {
                  return Center(
                    child: Text("${index + 1}"),
                  );
                },
              ),
            ),
          ),
          CupertinoButton(
              child: Text("반 설정"),
              onPressed: () {
                setState(() {
                  _selectedGrade = _changedGrade;
                  _selectedClass = _changedClass;
                  _saveClassData(_changedGrade, _changedClass);
                });
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }

  Widget _buildHelpExpansionList() {
    return ExpansionPanelList(
      expandedHeaderPadding: EdgeInsets.zero,
      elevation: 0,
      children: [
        ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Row(
                children: <Widget>[
                  Icon(EvaIcons.questionMarkCircleOutline, size: 20),
                  SizedBox(width: 10),
                  Text("도움말"),
                ],
              ),
            );
          },
          body: Column(
            children: [
              ListTile(
                title: Text(
                  "데이터의 업데이트 주기가 어떻게 되나요?",
                  style: CustomStyle.helpTitle,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("공지사항은 실시간으로 업데이트되며 시간표, 급식, 학사일정은 매일 업데이트됩니다."),
                    Text("*시간표의 경우 수정이 이루어지지 않은 경우만 해당"),
                  ],
                ),
              ),
              ListTile(
                title:
                    Text("표시되는 시간표가 제 시간표와 달라요", style: CustomStyle.helpTitle),
                subtitle: Text(
                    "선택 과목이 있는 시간표의 경우 개인별 시간표를 모두 제공하기에는 어려움이 있어 각 반에 해당하는 시간표를 기본으로 제공하고 있습니다. 이 경우 시간표 수정 기능을 통해 본인의 시간표에 맞게 수정 후 사용하시면 됩니다."),
              ),
            ],
          ),
          isExpanded: _helpExpanded,
        ),
      ],
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _helpExpanded = !isExpanded;
        });
      },
    );
  }

  _saveClassData(schoolGrade, schoolClass) {
    var prefBox = Hive.box('preferences');
    prefBox.put('grade', schoolGrade);
    prefBox.put('class', schoolClass);
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Padding(
        padding: EdgeInsets.all(15),
        child: Text('반 정보가 저장되었습니다.', style: CustomStyle.snackBar),
      ),
      duration: Duration(seconds: 3),
    ));
  }

  _initClassData() {
    var prefBox = Hive.box('preferences');
    setState(() {
      _selectedGrade = _changedGrade = prefBox.get('grade');
      _selectedClass = _changedClass = prefBox.get('class');
    });
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future _fetchClassData() async {
    ClassInfoRepository().getClassInfo(year: year).then((value) => {
          for (var i = 0; i < 3; i++)
            {
              classes[i] = value.classInfo[1].row
                  .where((element) => int.parse(element.grade) == i + 1)
                  .length
            }
        });
  }
}
