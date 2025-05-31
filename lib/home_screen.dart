import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        title: const Text("For you"),
        centerTitle: false,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile.png'),
            radius: 16,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Monday, September 12",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // --- Top Stories ---
          _sectionHeader("Top Stories"),
          const SizedBox(height: 12),
          _topStoryCard(),

          const SizedBox(height: 24),

          // --- Highlights ---
          _sectionHeader("Highlights"),
          const SizedBox(height: 12),
          _highlightList(),

          const SizedBox(height: 24),

          // --- Trending ---
          _sectionHeader("🔥 Trending"),
          const SizedBox(height: 12),
          _trendingCard(),
          _trendingCard(),

          const SizedBox(height: 24),

          // --- News List ---
          _newsItem(),
          _newsItem(),
          _newsItem(),

          const SizedBox(height: 16),
          _readMoreButton(),
          const SizedBox(height: 16),
          const Center(child: CircularProgressIndicator()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "For You"),
          BottomNavigationBarItem(icon: Icon(Icons.public), label: "Headlines"),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: "Bookmark",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Text("See all", style: TextStyle(color: Colors.orange)),
      ],
    );
  }

  Widget _topStoryCard() {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("assets/images/top_story.jpg", fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("sometechjournal.co", style: TextStyle(fontSize: 12)),
                SizedBox(height: 4),
                Text(
                  "Tech giant announces major investment in renewable energy",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text("3h ago", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _highlightList() {
    return SizedBox(
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _highlightItem("Stock market surges", "assets/images/top_story.jpg"),
          _highlightItem("Olympic gold medals", "assets/images/top_story.jpg"),
          _highlightItem("STEM competition", "assets/images/top_story.jpg"),
        ],
      ),
    );
  }

  Widget _highlightItem(String title, String imagePath) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(imagePath, height: 90, fit: BoxFit.cover),
          ),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Text(
            "2h ago",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _trendingCard() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("assets/images/top_story.jpg", fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("#GlobalCup", style: TextStyle(color: Colors.orange)),
                SizedBox(height: 4),
                Text(
                  "Underdog team shocks the world with stunning victory",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("5h ago", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _newsItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("scholarrandom.co", style: TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        const Text(
          "College admissions process faces reform amid scandals",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const Text(
          "In the wake of several high-profile admissions scandals that have rocked the nation...",
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset("assets/images/top_story.jpg"),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _readMoreButton() {
    return Center(
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.arrow_forward),
        label: const Text("Read full coverage"),
      ),
    );
  }
}
