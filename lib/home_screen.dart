import 'package:flutter/material.dart';
import 'package:tb_mobile/authors_space_page.dart';
import 'package:tb_mobile/for_you_page.dart';
import 'package:tb_mobile/headlines_page.dart';
import 'package:tb_mobile/search_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _currentIndex = 0;

  final List<Widget> _pages = [
    ForYouPage(),
    HeadlinesPage(),
    AuthorPage(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          _currentIndex == 0
              ? "For you"
              : _currentIndex == 1
                  ? "Headlines"
                  : "Author's Space",
        ),
        centerTitle: false,
        actions: _currentIndex == 0 || _currentIndex == 1
            ? [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SearchPage()),
                    );
                  },
                ),
                const SizedBox(width: 12),
              ]
            : null,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "For You"),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Headlines"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Author's Space"),
        ],
      ),
    );
  }

  
}
