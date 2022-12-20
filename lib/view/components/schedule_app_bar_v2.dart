import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:riverpod_firestore_steam1/core/theme.dart';

class ScheduleAppBarV2 extends AppBar implements PreferredSizeWidget {
  ScheduleAppBarV2({required this.context, super.key, required this.titlename});
  final String? titlename;
  final BuildContext context;

  // @override
  // bool get automaticallyImplyLeading => false;
  @override
  // TODO: implement foregroundColor
  Color? get foregroundColor => Colors.black;

  @override
  double? get titleSpacing => -10;

  @override
  Color? get backgroundColor => Colors.white;

  @override
  Widget? get leading => InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              SvgPicture.asset("assets/icon_arrow_back.svg", width: 10),
            ],
          ),
        ),
      );

  @override
  Widget? get title => Text(
        "${titlename}",
        style: textTheme(color: kPrimaryColor(), weight: FontWeight.bold)
            .headline2,
      );

  @override
  List<Widget>? get actions => [
        IconButton(
          onPressed: () {},
          icon:
              SvgPicture.asset("assets/icon_notice.svg", width: 20, height: 20),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 14),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset("assets/icon_setting.svg",
              width: 20, height: 20),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 20),
      ];

  // @override
  // ShapeBorder? get shape => RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10)),
  //     );

  @override
  ShapeBorder? get shape =>
      Border(bottom: BorderSide(width: 1, color: klightGreyColor()));

  @override
  //final Size preferredSize; // This didnot work for me.
  Size get preferredSize => const Size.fromHeight(55);
}
