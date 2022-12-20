import 'package:flutter/material.dart';
import 'package:riverpod_firestore_steam1/core/theme.dart';
import 'package:riverpod_firestore_steam1/models/test/follow.dart';

class FollowBox extends StatelessWidget {
  const FollowBox({Key? key, required this.follow}) : super(key: key);
  final Follow follow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildFollowImg(),
          SizedBox(width: 10),
          _buildFollowContent(),
          _buildFollowBtn("unfollow"),
        ],
      ),
    );
  }

  Container _buildFollowBtn(String follow) {
    return Container(
        height: 28,
        child: follow != true
            ? ElevatedButton(
                onPressed: () {},
                child: Text(
                  "팔로우",
                  style: textTheme(color: Colors.white).bodyText1,
                ),
                style: ElevatedButton.styleFrom(
                  primary: createMaterialColor(Color(0xff6E34DA)),
                  //padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6),
                    ),
                  ),
                  elevation: 0.0,
                ),
              )
            : ElevatedButton(
                onPressed: () {},
                child: Text(
                  "팔로잉",
                  style: textTheme(color: Colors.white).bodyText1,
                ),
                style: ElevatedButton.styleFrom(
                  primary: kchacholGreyColor(),
                  //padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6),
                    ),
                  ),
                  elevation: 0.0,
                ),
              ));
  }

  Expanded _buildFollowContent() {
    return Expanded(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(follow.name,
                  style:
                      textTheme(color: kPrimaryColor(), weight: FontWeight.bold)
                          .headline3),
              Container(
                width: 180,
                child: Text(
                  follow.intro,
                  style: textTheme(color: kchacholGreyColor()).bodyText1,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _buildFollowImg() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        //color: kmidGreyColor(),
        image: DecorationImage(
            image: AssetImage(follow.userImg), fit: BoxFit.cover),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }
}
