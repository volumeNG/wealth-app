// Create a Layout Widget
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wealth/presentation/pages/widgets/user_login_popup.dart';
import 'package:wealth/storage/secure_storage.dart';

class BottomNavigationLayout extends StatefulWidget {
  final List<Widget> pages;

  const BottomNavigationLayout({Key? key, required this.pages})
      : super(key: key);

  @override
  _BottomNavigationLayoutState createState() => _BottomNavigationLayoutState();
}

class _BottomNavigationLayoutState extends State<BottomNavigationLayout> {
  int _selectedIndex = 0;
  SecureStorage _storage = new SecureStorage();

  Future<void> _onItemTapped(int index) async {
    var doesAccessExist = await _storage.readSecureData("accessToken");
    if (doesAccessExist != null &&
        doesAccessExist == "No data found!" &&
        index > 1) {
      showDialog(
        context: context,
// barrierDismissible: false,
        builder: (context) => UserLoginPopup(),
      );
      setState(() {
        _selectedIndex = 1;
      });
    } else {
      setState(
        () {
          _selectedIndex = index;
        },
      );
    }
  }

  ///This is the part where if the user isn't logged then there should be progressesd

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.pages[_selectedIndex],
      // backgroundColor: Colors.black,
      bottomNavigationBar: Container(
        // margin: EdgeInsets.only(left: 16, right: 16),

        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              offset: Offset(0, 0),
              blurRadius: 30,
            )
          ],
          color: Colors.white,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: NavWidget(
                path: "crowd_funding",
                label: "Crowd\nFunding",
              ),
              activeIcon: SelectedNavWidget(
                path: "crowd_funding",
                label: "Crowd\nFunding",
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: NavWidget(
                path: "Location",
                label: "Current\nLocations",
              ),
              activeIcon: SelectedNavWidget(
                path: "Location",
                label: "Current\nLocations",
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: NavWidget(
                path: "Buy",
                label: "Flipping\n(Buy/Sell)",
              ),
              activeIcon: SelectedNavWidget(
                path: "Buy",
                label: "Flipping\n(Buy/Sell)",
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: NavWidget(
                path: "Discount",
                label: "Promotions\n",
              ),
              activeIcon: SelectedNavWidget(
                path: "Discount",
                label: "Promotions\n",
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: NavWidget(
                path: "Chat",
                label: "Chat\n",
              ),
              activeIcon: SelectedNavWidget(
                path: "Chat",
                label: "Chat\n",
              ),
              label: '',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          // selectedFontSize: 14.0,
          // unselectedFontSize: 10.0,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedIconTheme: IconThemeData(size: 24, color: Colors.black),
          unselectedIconTheme: IconThemeData(size: 20, color: Colors.grey),
          backgroundColor: Colors.white,
          selectedLabelStyle:
              GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 5.sp),
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black.withOpacity(0.8),
        ),
      ),
    );
  }
}

class SelectedNavWidget extends StatelessWidget {
  const SelectedNavWidget({
    super.key,
    required this.path,
    required this.label,
  });

  final String path;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 5.sp,
        ),
        ImageIcon(
          AssetImage("assets/images/$path.png"),
          color: Colors.black,
        ),
        SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              color: Colors.black, fontSize: 8.sp, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class NavWidget extends StatelessWidget {
  const NavWidget({
    super.key,
    required this.path,
    required this.label,
  });

  final String path;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 5.sp,
        ),
        ImageIcon(
          AssetImage("assets/images/$path.png"),
          color: Colors.grey,
        ),
        SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              color: Colors.black, fontSize: 8.sp, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
