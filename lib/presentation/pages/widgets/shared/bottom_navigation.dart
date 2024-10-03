import 'package:flutter/cupertino.dart';

class BottomNavigationBar extends StatefulWidget {
  const BottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Column(
            children: [
              ImageIcon(AssetImage("assets/images/crowd.png"), ),
              Text("Crowd Funding"),
            ],
          )
        ],
      ),
    );
  }
}
