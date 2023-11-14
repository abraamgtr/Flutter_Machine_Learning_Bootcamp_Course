import 'package:carousel_slider/carousel_slider.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController? _tabController;
  int _currentIndex = 0;
  int _tabIndex = 0;
  List<Widget> _tabs = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(microseconds: 3), () {
      setState(() {
        _tabs = [
          _mainWidget(),
          _mainWidget(),
          _mainWidget(),
        ];
        _tabController = TabController(length: _tabs.length, vsync: this);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      initialIndex: _tabIndex,
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.menu,
              color: Colors.black,
              size: 30.0,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 40.0,
                ))
          ],
          bottom: TabBar(
            controller: _tabController,
            unselectedLabelColor: Colors.black26,
            labelColor: Colors.black,
            labelStyle: TextStyle(
              fontSize: 20.0,
            ),
            indicator: DotIndicator(color: Colors.blue),
            onTap: (currentTabIndex) {
              setState(() {
                _tabIndex = currentTabIndex;
              });
            },
            tabs: _tabs.length > 0
                ? [
                    Tab(
                      text: 'Home',
                    ),
                    Tab(text: 'Favorites'),
                    Tab(text: 'Profile'),
                  ]
                : [],
          ),
        ),
        body: TabBarView(
          children: _tabs.length > 0 ? _tabs : [],
        ),
        bottomNavigationBar: DotNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int tabIndex) {
            setState(() {
              _currentIndex = tabIndex;
            });
          },
          items: [
            /// Home
            DotNavigationBarItem(
              icon: Icon(Icons.home),
              selectedColor: Colors.purple,
            ),

            /// Likes
            DotNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              selectedColor: Colors.pink,
            ),

            /// Search
            DotNavigationBarItem(
              icon: Icon(Icons.search),
              selectedColor: Colors.orange,
            ),

            /// Profile
            DotNavigationBarItem(
              icon: Icon(Icons.person),
              selectedColor: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }

  _mainWidget() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                height: 330.0,
              ),
              items: [1, 2, 3, 4, 5].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        margin: EdgeInsets.only(bottom: 20.0),
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: Image.asset(
                                  "assets/images/${i % 2 == 0 ? "building" : "car"}.jpg",
                                  fit: BoxFit.cover,
                                  height:
                                      MediaQuery.of(context).size.height / 4,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Card(
                                elevation: 2.0,
                                clipBehavior: Clip.hardEdge,
                                child: Container(
                                  // height: 100.0,
                                  margin:
                                      EdgeInsets.only(left: 10.0, right: 10.0),
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.verified_user,
                                            color: Colors.blue,
                                            size: 20.0,
                                          ),
                                          SizedBox(
                                            width: 8.0,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Test",
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.black45,
                                                  ),
                                                ),
                                                Text(
                                                  "Test",
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.black26,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.favorite,
                                                color: Colors.red.shade300,
                                                size: 20.0,
                                              ))
                                        ],
                                      ),
                                      Text(
                                        "Test",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "Test",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black45,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            SizedBox(
              height: 12.0,
            ),
            Text(
              "Recommended",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Column(
              children: [1, 2, 3]
                  .asMap()
                  .map((i, element) => MapEntry<int, Widget>(
                      i,
                      Container(
                        margin: EdgeInsets.only(
                            bottom: i == [1, 2, 3].length - 1 ? 50.0 : 0.0),
                        child: _newsItems(),
                      )))
                  .values
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  _newsItems() {
    return Container(
      constraints: BoxConstraints(maxHeight: 300.0),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.0),
            constraints: BoxConstraints(maxHeight: 125.0),
            child: Card(
              elevation: 2.0,
              clipBehavior: Clip.hardEdge,
              child: Container(
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                padding: EdgeInsets.only(left: 70.0, top: 8.0, bottom: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.verified_user,
                          color: Colors.blue,
                          size: 20.0,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Test",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black45,
                                ),
                              ),
                              Text(
                                "Test",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black26,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.favorite,
                              color: Colors.red.shade300,
                              size: 20.0,
                            ))
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Test",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Test",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              top: 0.0,
              left: 0.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  "assets/images/building.jpg",
                  height: 100.0,
                  width: 85.0,
                  fit: BoxFit.cover,
                ),
              )),
        ],
      ),
    );
  }
}

class DotIndicator extends Decoration {
  const DotIndicator({
    this.color = Colors.white,
    this.radius = 2.0,
  });
  final Color color;
  final double radius;
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _DotPainter(
      color: color,
      radius: radius,
      onChange: onChanged,
    );
  }
}

class _DotPainter extends BoxPainter {
  _DotPainter({
    required this.color,
    required this.radius,
    VoidCallback? onChange,
  })  : _paint = Paint()
          ..color = color
          ..style = PaintingStyle.fill,
        super(onChange);
  final Paint _paint;
  final Color color;
  final double radius;
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    canvas.drawCircle(
      Offset(rect.bottomCenter.dx, rect.bottomCenter.dy - radius),
      radius,
      _paint,
    );
  }
}
