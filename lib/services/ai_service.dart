class AIService {
  static final AIService _instance = AIService._internal();

  factory AIService() {
    return _instance;
  }

  AIService._internal();

  // AI功能免费次数配置
  final Map<String, Map<String, dynamic>> _freeLimits = {
    'continueWrite': {'dailyLimit': 80, 'current': 80},
    'expand': {'dailyLimit': -1, 'current': -1}, // 无限次
    'shrink': {'dailyLimit': -1, 'current': -1}, // 无限次
    'polish': {'dailyLimit': -1, 'current': -1}, // 无限次
    'summarize': {'dailyLimit': 60, 'current': 60},
    'titleGenerate': {'dailyLimit': 70, 'current': 70},
  };

  // 检查免费次数
  bool canUseFeature(String feature) {
    final limit = _freeLimits[feature];
    if (limit == null) return false;
    if (limit['dailyLimit'] == -1) return true; // 无限次
    return limit['current'] > 0;
  }

  // 使用功能并减少次数
  void useFeature(String feature) {
    final limit = _freeLimits[feature];
    if (limit != null && limit['dailyLimit'] != -1) {
      if (limit['current'] > 0) {
        _freeLimits[feature]!['current'] = limit['current'] - 1;
      }
    }
  }

  // 获取剩余次数
  int getRemainingCount(String feature) {
    final limit = _freeLimits[feature];
    if (limit == null) return 0;
    if (limit['dailyLimit'] == -1) return -1; // 无限次
    return limit['current'];
  }

  // 模拟AI生成
  String generateContent(String feature, String inputText, {String? prompt}) {
    if (!canUseFeature(feature)) {
      throw Exception('今日免费次数已用完');
    }

    useFeature(feature);

    // 模拟不同的AI功能
    switch (feature) {
      case 'continueWrite':
        return '$inputText\n\n这是AI续写的内容，基于上文进行了自然的延续和发展，保持了原文的风格和语气。';

      case 'expand':
        return '$inputText\n\n这是AI扩写的内容，对原文进行了详细的扩展和补充，增加了更多的细节和描述，使内容更加丰富和完整。';

      case 'shrink':
        return '这是AI缩写后的内容：${inputText.substring(0, inputText.length ~/ 2)}...';

      case 'polish':
        return '这是AI润色后的文本：${inputText}。语言更加流畅优美，表达更加精准专业。';

      case 'summarize':
        return '总结要点：\n• 主要内容概括\n• 关键信息提取\n• 核心观点总结';

      case 'titleGenerate':
        return '精彩标题：${inputText.isNotEmpty ? inputText.split(' ').take(3).join(' ') : 'AI生成'}的完美标题';

      default:
        return inputText;
    }
  }

  // 重置每日限制（模拟每日重置）
  void resetDailyLimits() {
    for (var feature in _freeLimits.keys) {
      final limit = _freeLimits[feature]!;
      if (limit['dailyLimit'] != -1) {
        _freeLimits[feature]!['current'] = limit['dailyLimit'];
      }
    }
  }

  // 获取所有功能的剩余次数
  Map<String, int> getAllRemainingCounts() {
    final Map<String, int> counts = {};
    for (var feature in _freeLimits.keys) {
      counts[feature] = getRemainingCount(feature);
    }
    return counts;
  }
}