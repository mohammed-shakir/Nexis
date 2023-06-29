import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_providor.dart';
import '../../classes/route_names.dart';
import 'components/user_profile.dart';
import 'components/appearance.dart';
import '../../widgets/close_button.dart';
import '../../widgets/navigation_menu_item.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  Widget selectedContent = const UserProfile();

  void changeContent(Widget content) {
    setState(() {
      selectedContent = content;
    });
  }

  void logout() async {
    var navigator = Navigator.of(context);
    await Provider.of<UserProvider>(context, listen: false).logout();
    navigator.pushNamed(RouteNames.authPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              NavigationMenu(
                onSelectProfile: () => changeContent(const UserProfile()),
                onSelectAppearance: () => changeContent(const Appearance()),
                onLogout: logout,
              ),
              Expanded(child: selectedContent),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 50,
            right: 50,
            child: CustomCloseButton(
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationMenu extends StatefulWidget {
  final VoidCallback onSelectProfile;
  final VoidCallback onSelectAppearance;
  final VoidCallback onLogout;

  const NavigationMenu({
    Key? key,
    required this.onSelectProfile,
    required this.onSelectAppearance,
    required this.onLogout,
  }) : super(key: key);

  @override
  NavigationMenuState createState() => NavigationMenuState();
}

class NavigationMenuState extends State<NavigationMenu> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      color: Colors.grey[900],
      child: ListView(
        children: [
          NavigationMenuItem(
            title: 'Profile',
            isSelected: selectedIndex == 0,
            onTap: () {
              widget.onSelectProfile();
              setState(() {
                selectedIndex = 0;
              });
            },
          ),
          NavigationMenuItem(
            title: 'Appearance',
            isSelected: selectedIndex == 1,
            onTap: () {
              widget.onSelectAppearance();
              setState(() {
                selectedIndex = 1;
              });
            },
          ),
          NavigationMenuItem(
            title: 'Logout',
            isSelected: selectedIndex == 2,
            onTap: () async {
              setState(() {
                selectedIndex = 2;
              });
              widget.onLogout();
            },
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
