import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TabBar with SliverAppBar',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('SliverAppBar with Tabs'),
              background: Image.network(
                'https://via.placeholder.com/600x300',
                fit: BoxFit.cover,
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Tab 1'),
                Tab(text: 'Tab 2'),
                Tab(text: 'Tab 3'),
              ],
            ),
          ),
          // 这里我们使用 SliverToBoxAdapter 来包裹 TabBarView
          SliverToBoxAdapter(
            child: Container(
              height: 400, // 可以根据需要调整高度
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTabContent(1),
                  _buildTabContent(2),
                  _buildTabContent(3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 这里我们为每个 Tab 返回一个 SliverList
  Widget _buildTabContent(int tabIndex) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return ListTile(title: Text('Item ${tabIndex * 10 + index}'));
        },
        childCount: 10, // 每个 Tab 的列表项数量
      ),
    );
  }
}
