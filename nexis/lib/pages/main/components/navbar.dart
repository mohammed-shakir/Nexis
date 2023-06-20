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
  final TextEditingController searchController = TextEditingController();
  late FocusNode searchFocusNode;
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
    searchFocusNode = FocusNode();
    searchFocusNode.addListener(() {
      if (!searchFocusNode.hasFocus && searchController.text.isEmpty) {
        setState(() {
          isFocused = false;
        });
      }
    });
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            const Icon(Icons.chat, color: Colors.grey),
            const SizedBox(width: 10),
            const Text('General', style: TextStyle(color: Colors.white)),
            const Spacer(),
            Transform.rotate(
              angle: 45 * 3.14159265358979323846264338327950288 / 180,
              child: IconButton(
                icon: const Icon(Icons.push_pin),
                onPressed: () {},
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 10),
              width:
                  (isFocused || searchController.text.isNotEmpty) ? 300 : 214,
              child: TextField(
                controller: searchController,
                focusNode: searchFocusNode,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  hintText: 'Search',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  prefixIcon:
                      const Icon(Icons.search, size: 20, color: Colors.grey),
                  suffixIcon: searchController.text.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(0),
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                searchController.clear();
                                searchFocusNode.unfocus();
                                isFocused = false;
                              });
                            },
                            padding: const EdgeInsets.all(0),
                          ),
                        )
                      : null,
                  prefixIconConstraints: const BoxConstraints(minWidth: 30),
                  fillColor: Theme.of(context).colorScheme.onBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onTap: () {
                  setState(() {
                    isFocused = true;
                  });
                },
                onSubmitted: (value) {
                  setState(() {
                    if (searchController.text.isEmpty) {
                      isFocused = false;
                    }
                  });
                },
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
          ],
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
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: widget.openDrawer,
              color: Colors.grey,
            ),
            const SizedBox(width: 20),
            const Row(
              children: [
                Icon(Icons.chat, color: Colors.grey, size: 20),
                SizedBox(width: 10),
                Text('General', style: TextStyle(color: Colors.white)),
              ],
            ),
            const Spacer(),
            Transform.rotate(
              angle: 45 * 3.14159265358979323846264338327950288 / 180,
              child: IconButton(
                icon: const Icon(Icons.push_pin),
                onPressed: () {},
                color: Colors.grey,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
              color: Colors.grey,
            ),
            IconButton(
              icon: const Icon(Icons.people_alt),
              onPressed: widget.openEndDrawer,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
