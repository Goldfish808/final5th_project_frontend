import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_firestore_steam1/contoller/user_controller.dart';
import 'package:riverpod_firestore_steam1/core/theme.dart';
import 'package:riverpod_firestore_steam1/models/event.dart';
import 'package:riverpod_firestore_steam1/models/schedule/schedule_home.dart';
import 'package:riverpod_firestore_steam1/view/components/home_app_bar.dart';
import 'package:riverpod_firestore_steam1/view/pages/main_holder/home/components/home_page_top.dart';
import 'package:riverpod_firestore_steam1/view/pages/main_holder/home/my_home_page_view_model.dart';
import 'package:riverpod_firestore_steam1/view/pages/update_password/update_password_page.dart';

import '../../../../models/test/todo.dart';

List<ToDo> globalToDoItems = List.of(ToDoList);
List<Event> globalScheduleItems = List.of(eventList);

class MyHomePage extends ConsumerStatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  bool? _isChecked = false;
  List<Todo> pageTodos = [];

  @override
  Widget build(BuildContext context) {
    final uContrl = ref.read(userController);
    //User 와 더불어서 만들어지는 데이터가 수시로 변하기 때문에

    return Scaffold(
      appBar: HomeAppBar("유저이름", context: context),
      body: _homeBody(),
      endDrawer: _drawer(context, uContrl),
      endDrawerEnableOpenDragGesture: false,
      drawerEnableOpenDragGesture: false,
    );
  }

  Widget _homeBody() {
    return Column(
      children: [
        //Container(height: 320, child: HomePageTop()),
        Expanded(
          child: CustomScrollView(
            slivers: <Widget>[
              _buildHomeTop(),
              _buildToDoLists(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToDoLists() {
    MyHomePageModel model = ref.watch(myHomePageViewModel);
    ScheduleHome? scheduleHome = model.scheduleHome;

    if (scheduleHome == null) {
      return SliverToBoxAdapter(
        child: CircularProgressIndicator(),
      );
    } else {
      List<Todo> todos = scheduleHome.todos;
      pageTodos = todos;
      return SliverFixedExtentList(
        itemExtent: 58.0,
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return Container(
            alignment: Alignment.center,
            child: _ToDoList(todos[index], pageTodos[index]),
          );
        }, childCount: todos.length),
      );
    }
  }

  SliverAppBar _buildHomeTop() {
    return SliverAppBar(
      stretch: false,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      pinned: false,
      expandedHeight: 480.0,
      flexibleSpace: FlexibleSpaceBar(
        expandedTitleScale: 1,
        titlePadding: EdgeInsets.only(left: 0),
        title: Container(
          alignment: Alignment.centerLeft,
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "오늘 할 일",
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSans(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
        ),
        background: HomePageTop(),
      ),
    );
  }

  Widget _drawer(BuildContext context, uContrl) {
    return Drawer(
      child: ListView(
        children: [
          Container(
              height: 55,
              decoration: BoxDecoration(color: Colors.white),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 2, right: 14),
                    child: SizedBox(
                      width: 12,
                      height: 12,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        padding: EdgeInsets.zero,
                        icon: SvgPicture.asset("assets/icon_close.svg",
                            width: 12, height: 12),
                      ),
                    ),
                  ),
                  Text(
                    "설정",
                    style: textTheme(
                            color: kPrimaryColor(), weight: FontWeight.bold)
                        .headline2,
                  )
                ],
              )),
          Container(
            height: 62,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/img_banner.png'),
              ),
            ),
          ),
          _buildMenuList(text: "화면", fontColor: kPrimaryColor()),
          _buildMenuList(text: "알림", fontColor: kPrimaryColor()),
          _buildMenuList(text: "구독/결제", fontColor: kPrimaryColor()),
          _buildMenuList(text: "친구초대", fontColor: kPrimaryColor()),
          _buildMenuList(text: "비밀번호 변경", fontColor: kPrimaryColor()),
          _buildMenuList(text: "고객센터", fontColor: kPrimaryColor()),
          _buildMenuList(text: "버전", fontColor: kPrimaryColor()),
          _buildMenuList(
              text: "로그아웃", fontColor: kchacholGreyColor(), uContrl: uContrl),
        ],
      ),
    );
  }

  ListTile _buildMenuList(
      {required String text,
      Color? fontColor,
      FontWeight? fontWeight,
      uContrl}) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
      title: Text(text,
          style: textTheme(color: fontColor, weight: fontWeight).headline3),
      trailing: text != "로그아웃"
          ? SvgPicture.asset("assets/icon_arrow_next.svg", width: 8)
          : null,
      onTap: () {
        _ifPasswordMenu(text);
        _ifLogoutMenu(text, uContrl);
      },
      shape: Border(bottom: BorderSide(color: klightGreyColor(), width: 1.5)),
    );
  }

  void _ifPasswordMenu(String text) {
    text == "비밀번호 변경"
        ? Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UpdatePasswordPage()),
          )
        : null;
  }

  void _ifLogoutMenu(String text, UserController uContrl) {
    text == "로그아웃" ? uContrl.logout() : null;
  }

  Widget _ToDoList(Todo todo, Todo pageTodo) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.25,
        motion: const ScrollMotion(),
        // dismissible: DismissiblePane(onDismissed: () {
        //   setState(() {
        //     globalToDoItems.remove(globalToDoItems[index]);
        //   });
        // }),
        children: [
          SlidableAction(
            onPressed: (context) {
              Logger().d("클릭됨 1111");
              setState(() {
                //_removeToDoItem(context, todo.id);
              });
            },
            foregroundColor: primary,
            icon: CupertinoIcons.trash,
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 4),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Container(
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  //height: 60,
                  //padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  decoration: BoxDecoration(
                    color: klightGreyColor(),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        //width: 10,
                        padding: EdgeInsets.only(top: 4),
                        child: Checkbox(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          value: pageTodo.isFinished,
                          onChanged: (value) {
                            setState(() {
                              pageTodo.isFinished = !pageTodo.isFinished;
                            });
                          },
                        ),
                      ),
                      //SizedBox(width: 14),
                      Text(
                        todo.title,
                        style: todo.isFinished == true
                            ? TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 14,
                                height: 1.2,
                                color: kchacholGreyColor())
                            : textTheme().bodyText1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
