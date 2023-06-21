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
  Future<SharedPreferences> prefsFuture = SharedPreferences.getInstance();
  final TextEditingController searchController = TextEditingController();
  late FocusNode searchFocusNode;
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    searchFocusNode = FocusNode();
    searchFocusNode.addListener(() {
      if (!searchFocusNode.hasFocus && searchController.text.isEmpty) {
        setState(() {
          isFocused = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var screenType = getScreenType(mediaQuery);

    return FutureBuilder<SharedPreferences>(
      future: prefsFuture,
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          SharedPreferences? prefs = snapshot.data;
          switch (screenType) {
            case ScreenType.mobile:
              return buildMobileServerNavbar(context, prefs);
            case ScreenType.tablet:
              return buildMobileServerNavbar(context, prefs);
            case ScreenType.desktop:
              return buildDesktopServerNavbar(context, prefs);
            default:
              return buildDesktopServerNavbar(context, prefs);
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget buildDesktopServerNavbar(
      BuildContext context, SharedPreferences? prefs) {
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
                  isCollapsed: true, // Prevent vertical padding changes
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
                    borderSide: BorderSide.none,
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

  Widget buildDesktopDMNavbar(BuildContext context, SharedPreferences? prefs) {
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
            CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(prefs?.getString('avatar') ?? ''),
            ),
            const SizedBox(width: 10),
            Text(
              prefs?.getString('displayName') ?? '',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.phone_in_talk),
              onPressed: () {},
              color: Colors.grey,
            ),
            IconButton(
              icon: const Icon(Icons.videocam_rounded),
              onPressed: () {},
              color: Colors.grey,
            ),
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
                  isCollapsed: true,
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
                    borderSide: BorderSide.none,
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

  Widget buildMobileServerNavbar(
      BuildContext context, SharedPreferences? prefs) {
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

  Widget buildMobileDMNavbar(BuildContext context, SharedPreferences? prefs) {
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
            CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage(prefs?.getString('avatar') ?? ''),
            ),
            const SizedBox(width: 10),
            Text(
              prefs?.getString('displayName') ?? '',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.phone_in_talk),
              onPressed: () {},
              color: Colors.grey,
            ),
            IconButton(
              icon: const Icon(Icons.videocam_rounded),
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
