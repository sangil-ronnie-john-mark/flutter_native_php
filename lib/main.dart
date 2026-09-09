import 'package:flutter/cupertino.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LiquidGlassWidgets.initialize();
  runApp(LiquidGlassWidgets.wrap(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Widget> pages = [
    Center(child: Text('Homepage'),), // page 0
    Center(child: Text('Settings'),), // page 1
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: CupertinoThemeData(
        brightness: Brightness.dark
      ),
      debugShowCheckedModeBanner: false,
      home: GlassScaffold(
          appBar: GlassAppBar(
            actions: [
              GlassButtonGroup.icons(
                  settings: LiquidGlassSettings(
                    blur: 0.2
                  ),
                  items: [
                  GlassButtonGroupItem.menu(
                      menuWidth: 250,
                      icon: Icon(CupertinoIcons.ellipsis), menuItems: [
                    GlassMenuItem(
                        icon: Icon(CupertinoIcons.refresh),
                        title: 'Refresh',
                        subtitle: 'Updated as of 9:03AM',
                        onTap: (){}
                    ),
                    GlassMenuDivider(),
                    GlassMenuItem(
                        isDestructive: true,
                        icon: Icon(CupertinoIcons.delete),
                        title: 'Delete',
                        onTap: (){}
                    ),
                  ]),
                  GlassButtonGroupItem(icon: Icon(CupertinoIcons.add), onTap: (){}),
              ])
            ],
          ),
          body: pages[selectedIndex],
          bottomBar: GlassTabBar.bottom(tabs: [
            GlassTab(icon: Icon(CupertinoIcons.home), activeIcon: Icon(CupertinoIcons.home, color: CupertinoColors.systemPink,)),
            GlassTab(icon: Icon(CupertinoIcons.settings), activeIcon: Icon(CupertinoIcons.settings, color: CupertinoColors.systemPink,)),
          ], selectedIndex: selectedIndex, onTabSelected: (e){
            setState(() {
              selectedIndex = e;
            });
          }),
      ),
    );
  }
}
