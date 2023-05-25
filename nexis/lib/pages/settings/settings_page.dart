import 'package:flutter/material.dart';
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

  const NavigationMenu({
    Key? key,
    required this.onSelectProfile,
    required this.onSelectAppearance,
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
        ],
      ),
    );
  }
}
