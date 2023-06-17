import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../enums/screen_type.dart';

class NavBar extends StatefulWidget {
  final VoidCallback? openDrawer;
  final VoidCallback? openEndDrawer;

  const NavBar({
    Key? key,
    this.openDrawer,
    this.openEndDrawer,
  }) : super(key: key);

  @override
  NavBarState createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var screenType = getScreenType(mediaQuery);

    switch (screenType) {
      case ScreenType.mobile:
        return buildMobileNavbar(context);
      case ScreenType.tablet:
        return buildMobileNavbar(context);
      case ScreenType.desktop:
        return buildDesktopNavbar(context);
      default:
        return buildDesktopNavbar(context);
    }
  }

  Widget buildDesktopNavbar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: const Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget buildMobileNavbar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: const Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: widget.openDrawer,
              color: Colors.white,
            ),
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: widget.openEndDrawer,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
