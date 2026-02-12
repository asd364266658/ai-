import 'package:flutter/material.dart';
import 'package:vivo_ai_writer/screens/editor_screen.dart';
import 'package:vivo_ai_writer/widgets/draft_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Map<String, dynamic>> _drafts = [
    {
      'title': '项目计划书',
      'content': '这是一个关于新产品开发的项目计划...',
      'date': '2024-02-12',
      'time': '14:30'
    },
    {
      'title': '会议记录',
      'content': '今天讨论了关于AI功能优化的问题...',
      'date': '2024-02-11',
      'time': '10:15'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              Icons.edit,
              color: Color(0xFF415FFF),
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text('vivoAI写作'),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF00C853),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '免费版',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildCurrentScreen(),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditorScreen(),
                  ),
                );
              },
              backgroundColor: const Color(0xFF415FFF),
              child: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 28,
              ),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note),
            label: '写作',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            label: '灵感',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build_outlined),
            label: '工具箱',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '我的',
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0: // 写作页
        return _buildHomeContent();
      case 1: // 灵感页
        return _buildInspirationScreen();
      case 2: // 工具箱页
        return _buildToolboxScreen();
      case 3: // 我的页
        return _buildProfileScreen();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Center(
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF415FFF).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit,
                  color: Color(0xFF415FFF),
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '开始创作',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '最近草稿',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _drafts.length,
            itemBuilder: (context, index) {
              final draft = _drafts[index];
              return DraftCard(
                title: draft['title'],
                content: draft['content'],
                date: draft['date'],
                time: draft['time'],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditorScreen(
                        initialContent: draft['content'],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInspirationScreen() {
    return const Center(
      child: Text('灵感中心 - 这里有各种创作灵感'),
    );
  }

  Widget _buildToolboxScreen() {
    return const Center(
      child: Text('工具箱 - 各种写作辅助工具'),
    );
  }

  Widget _buildProfileScreen() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.dark_mode),
          title: const Text('深色模式'),
          trailing: Switch(
            value: false,
            onChanged: (value) {},
          ),
        ),
        ListTile(
          leading: const Icon(Icons.text_fields),
          title: const Text('字体大小'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.delete),
          title: const Text('清除缓存'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('关于我们'),
          onTap: () {},
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '本机存储，不上云',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}