import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_firestore_steam1/contoller/write_controller.dart';
import 'package:riverpod_firestore_steam1/core/theme.dart';
import 'package:riverpod_firestore_steam1/view/pages/main_holder/chat/chat_page.dart';
import 'package:riverpod_firestore_steam1/view/pages/main_holder/home/my_home_page.dart';
import 'package:riverpod_firestore_steam1/view/pages/main_holder/search/search_page.dart';

import '../../../models/test/todo.dart';
import '../login/components/line_button.dart';
import 'mypage/my_page.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends ConsumerState<MainPage> {
  int _selectedIndex = 0;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();
  final _todoTitle = TextEditingController(); // 추가
  //final _isFinished = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          MyHomePage(),
          ChatPage(),
          Container(child: Text("사용안하는 페이지")),
          SearchPage(),
          MyPage(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      //height: 55,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xffe2e2e2), width: 1.0)),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        iconSize: 20.0,
        //unselectedFontSize: 10.0,
        //selectedFontSize: 10.0,
        selectedLabelStyle: textTheme().caption,
        unselectedLabelStyle: textTheme().caption,
        currentIndex: _selectedIndex,
        backgroundColor: Colors.white,
        selectedItemColor: theme().primaryColor,
        unselectedItemColor: Color(0xff9999A3),
        onTap: (index) {
          index == 2
              ? _writeForm()
              : setState(() {
                  _selectedIndex = index;
                });
        },
        items: _buildBottomNavigationBarItems(),
      ),
    );
  }

  Future<dynamic> _writeForm() {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: _buildShowModalBottomSheetTODO(context, ref),
        );
      },
    );
  }

  Widget _buildMinToDoWrite() {
    return Form(
      key: _formKey,
      child: Container(
        height: MediaQuery.of(context).size.height / 3.5,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: 8),
                    child: ConstrainedBox(
                      //입력 만큼 height 늘어나려면 얘로 감싸고 1
                      constraints:
                          const BoxConstraints(maxHeight: 400), //얘를 주면 됨 2
                      child: TextFormField(
                        //validator: vali,
                        controller: _textController,
                        style: textTheme().headline3,
                        maxLines: null, //이걸 NULL 로 해주고 3
                        maxLength: 50,
                        decoration: const InputDecoration(
                            hintText: "할 일 작성",
                            hintStyle: TextStyle(
                                color: Color(0xff9999A3),
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff9999A3))),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff9999A3))),
                            focusColor: Color(0xff9999A3)),
                        onSaved: (value) {}, //얘는 값을 비워주기 위해서
                      ),
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(bottom: 8),
                    //decoration: BoxDecoration(),
                    //width: 48,
                    //height: 27,
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pop(context);
                          _textController.text = ""; // 얘로 폼필드 비워줘야함
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        padding: EdgeInsets.only(bottom: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        elevation: 0.0,
                      ),
                      child: Text(
                        "입력",
                        style: textTheme().bodyText1,
                      ),
                    ))
              ],
            ),
            SizedBox(height: 50),
            LineButton("일정 작성하러 가기", "/write"),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(text, WriteController wC) {
    print(text);
    setState(() {
      //ToDO 리스트에 주입하는 코드 서비스 로직ㄴㄷ
      globalToDoItems.add(ToDo(
        content: text,
        time: DateFormat("a K:m").format(new DateTime.now()),
        date: 08,
        day: "Mon",
        done: false,
      ));
    });
  }

  Container _buildShowModalBottomSheetTODO(
      BuildContext context, WidgetRef _ref) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      //위 패딩은 모달창의 터치 가능한 영역 내부 패딩
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        color: Colors.white,
      ),
      child: Container(
        padding: EdgeInsets.only(top: 18),
        child: Column(
          children: <Widget>[
            Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: kmidGreyColor(),
              ),
              //margin: EdgeInsets.only(bottom: 20),
            ),
            Text(" "),
            Row(),
            _buildMinToDoWrite(),
          ],
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavigationBarItems() {
    return [
      BottomNavigationBarItem(
        icon: SvgPicture.asset("assets/icon_bottom_home.svg", width: 20),
        activeIcon:
            SvgPicture.asset("assets/icon_bottom_home_on.svg", width: 20),
        label: "홈",
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset("assets/icon_bottom_chat.svg", width: 20),
        activeIcon:
            SvgPicture.asset("assets/icon_bottom_chat_on.svg", width: 20),
        label: "채팅",
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset("assets/icon_bottom_plus.svg", width: 22),
        activeIcon:
            SvgPicture.asset("assets/icon_bottom_plus_on.svg", width: 22),
        label: "글쓰기",
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset("assets/icon_bottom_search.svg", width: 20),
        activeIcon:
            SvgPicture.asset("assets/icon_bottom_search_on.svg", width: 20),
        label: "검색",
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset("assets/icon_bottom_my.svg", width: 20),
        activeIcon: SvgPicture.asset("assets/icon_bottom_my_on.svg", width: 20),
        label: "MY",
      ),
    ];
  }
}
