import 'package:flutter/material.dart';
import 'package:vivo_ai_writer/widgets/ai_function_card.dart';

class EditorScreen extends StatefulWidget {
  final String? initialContent;

  const EditorScreen({super.key, this.initialContent});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  bool _showAIFunctions = false;
  int _freeWritesLeft = 80;
  final List<Map<String, dynamic>> _aiFunctions = [
    {
      'icon': Icons.expand,
      'title': '扩写',
      'color': Colors.blue,
      'free': true,
    },
    {
      'icon': Icons.compress,
      'title': '缩写',
      'color': Colors.green,
      'free': true,
    },
    {
      'icon': Icons.brush,
      'title': '润色',
      'color': Colors.orange,
      'free': true,
    },
    {
      'icon': Icons.summarize,
      'title': '总结',
      'color': Colors.purple,
      'free': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialContent != null) {
      _textController.text = widget.initialContent!;
    }
    _textController.addListener(_checkTextSelection);
  }

  void _checkTextSelection() {
    final selection = _textController.selection;
    setState(() {
      _showAIFunctions = selection.extentOffset > selection.baseOffset;
    });
  }

  void _showAIGenerationDialog(String function) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('AI$function'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: '一句话描述你要写什么…',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // 模拟AI生成
                  _simulateAIGeneration(function);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF415FFF),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('免费生成'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _simulateAIGeneration(String function) {
    // 模拟AI生成结果
    String result = '';
    switch (function) {
      case '扩写':
        result = '这是AI扩写的内容，基于您选中的文本进行了扩展和丰富，使内容更加详细和完整。';
        break;
      case '缩写':
        result = '这是AI缩写的内容，保留了核心信息，更加简洁明了。';
        break;
      case '润色':
        result = '这是AI润色后的内容，语言更加流畅优美，表达更加专业。';
        break;
      case '总结':
        result = '这是AI总结的要点，概括了主要内容的关键信息。';
        break;
    }

    final selection = _textController.selection;
    // 确保选择范围有效
    if (selection.start >= 0 && selection.end <= _textController.text.length) {
      final newText = _textController.text.replaceRange(
        selection.start,
        selection.end,
        result,
      );
      setState(() {
        _textController.text = newText;
        _textController.selection = TextSelection.collapsed(
          offset: selection.start + result.length,
        );
      });
    } else {
      // 如果选择范围无效，直接添加到文本末尾
      setState(() {
        _textController.text = '${_textController.text}\n\n$result';
        _textController.selection = TextSelection.collapsed(
          offset: _textController.text.length,
        );
      });
    }
  }

  void _triggerContinueWrite() {
    if (_freeWritesLeft > 0) {
      setState(() {
        _freeWritesLeft--;
      });
      _simulateAIGeneration('续写');
    } else {
      _showLimitExceededDialog();
    }
  }

  void _showLimitExceededDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('提示'),
          content: const Text('今日免费次数用完，明天再来吧'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('新文档'),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            onPressed: _triggerContinueWrite,
            tooltip: 'AI续写 ($_freeWritesLeft次剩余)',
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // 自动保存逻辑
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('已自动保存到本地')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                scrollController: _scrollController,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '开始写作...',
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          if (_showAIFunctions) ...[
            const Divider(height: 1),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _aiFunctions.length,
                itemBuilder: (context, index) {
                  final function = _aiFunctions[index];
                  return AIFunctionCard(
                    icon: function['icon'],
                    title: function['title'],
                    color: function['color'],
                    free: function['free'],
                    onTap: () => _showAIGenerationDialog(function['title']),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}