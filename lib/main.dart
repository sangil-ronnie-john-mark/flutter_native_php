import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:http/http.dart' as http;

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
  String server = "http://192.168.254.106/";

  Future<void> getTask() async {
    final uri = server + "getTask.php";
    final response = await http.get(
      Uri.parse(uri)
    );
    print((jsonDecode(response.body)).runtimeType);
    setState(() {
      todo = jsonDecode(response.body);
    });

  }

  Future<void> addTask() async {
    final uri = server + "addTask.php";
    final response = await http.post(
      Uri.parse(uri),
      body: {
        "task" : _task.text
      }
    );
    getTask();
    print(response.body);
  }

  @override
  void initState() {
    getTask();
    super.initState();
  }

  List<dynamic> todo = [];
  List<Widget> get pages => [
    Padding(
      padding: const EdgeInsets.fromLTRB(10, 60, 10, 0),
      child: (todo.length == 0) ? Center(child: Text('Empty List', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),),) :
      ListView(
        children: [
          GlassGroupedSection(
            children:  List.generate(todo.length, (index){
              return GlassListTile(title: Text(todo[index]["task"]));
            }),
          ),
        ],
      ),
    ),
    Center(child: Text('Settings'),), // page 1
  ];
  int selectedIndex = 0;
  TextEditingController _task = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: CupertinoThemeData(
        brightness: Brightness.dark
      ),
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) {
          return GlassScaffold(
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
                      GlassButtonGroupItem(icon: Icon(CupertinoIcons.add), onTap: (){
                        showCupertinoDialog(context: context, builder: (context){
                            return GlassDialog(
                                content: GlassTextField(
                                  controller: _task,
                                  placeholder: 'Add Task',
                                ),
                                actions: [
                              GlassDialogAction(
                                  isDestructive: true,
                                  label: 'Close',
                                  onPressed: (){
                                    Navigator.pop(context);
                                  }
                              ),
                              GlassDialogAction(
                                  label: 'Save',
                                  onPressed: (){
                                    if (_task.text != "") {
                                      addTask();
                                      _task.text = "";
                                      Navigator.pop(context);
                                    }
                                  }
                              ),

                            ]
                            );
                        });
                      }),
                  ])
                ],
              ),
              body: pages[selectedIndex],
              bottomBar: GlassTabBar.bottom(
                  settings: LiquidGlassSettings(),
                  tabs: [
                GlassTab(icon: Icon(CupertinoIcons.home), activeIcon: Icon(CupertinoIcons.home, color: CupertinoColors.systemPink,)),
                GlassTab(icon: Icon(CupertinoIcons.settings), activeIcon: Icon(CupertinoIcons.settings, color: CupertinoColors.systemPink,)),
              ], selectedIndex: selectedIndex, onTabSelected: (e){
                setState(() {
                  selectedIndex = e;
                });
              }),
          );
        }
      ),
    );
  }
}
