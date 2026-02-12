import 'dart:convert';
import 'package:flutter/foundation.dart';

class Draft {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  Draft({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Draft.fromMap(Map<String, dynamic> map) {
    return Draft(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Draft.fromJson(String source) => Draft.fromMap(json.decode(source));
}

class StorageService {
  static final StorageService _instance = StorageService._internal();

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  final List<Draft> _drafts = [];

  // 获取所有草稿（按更新时间倒序）
  List<Draft> getAllDrafts() {
    _drafts.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return List.from(_drafts);
  }

  // 保存草稿
  void saveDraft(Draft draft) {
    final existingIndex = _drafts.indexWhere((d) => d.id == draft.id);
    if (existingIndex >= 0) {
      _drafts[existingIndex] = draft;
    } else {
      _drafts.add(draft);
    }
  }

  // 创建新草稿
  Draft createDraft({String title = '新文档', String content = ''}) {
    final draft = Draft(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    saveDraft(draft);
    return draft;
  }

  // 更新草稿内容
  Draft updateDraftContent(String id, String content) {
    final draft = _drafts.firstWhere((d) => d.id == id);
    final updatedDraft = Draft(
      id: draft.id,
      title: _generateTitleFromContent(content),
      content: content,
      createdAt: draft.createdAt,
      updatedAt: DateTime.now(),
    );
    saveDraft(updatedDraft);
    return updatedDraft;
  }

  // 从内容生成标题
  String _generateTitleFromContent(String content) {
    if (content.isEmpty) return '新文档';
    final lines = content.split('\n');
    final firstLine = lines.first.trim();
    if (firstLine.isNotEmpty && firstLine.length > 20) {
      return '${firstLine.substring(0, 20)}...';
    }
    return firstLine.isNotEmpty ? firstLine : '新文档';
  }

  // 删除草稿
  void deleteDraft(String id) {
    _drafts.removeWhere((draft) => draft.id == id);
  }

  // 获取草稿数量
  int getDraftCount() {
    return _drafts.length;
  }

  // 清空所有草稿
  void clearAllDrafts() {
    _drafts.clear();
  }

  // 导入导出功能（模拟）
  String exportDrafts() {
    final draftsMap = _drafts.map((draft) => draft.toMap()).toList();
    return json.encode(draftsMap);
  }

  void importDrafts(String jsonString) {
    try {
      final List<dynamic> draftsList = json.decode(jsonString);
      _drafts.clear();
      for (var draftMap in draftsList) {
        _drafts.add(Draft.fromMap(draftMap));
      }
    } catch (e) {
      if (kDebugMode) {
        print('导入失败: $e');
      }
    }
  }
}