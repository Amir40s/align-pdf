import 'package:get_storage/get_storage.dart';

class HistoryStorageService {
  static final HistoryStorageService instance = HistoryStorageService._();

  HistoryStorageService._();

  final GetStorage _box = GetStorage();

  static const String _historyKey = 'pdf_history';

  List<Map<String, dynamic>> getHistory() {
    final data = _box.read<List>(_historyKey);

    if (data == null) {
      return [];
    }

    return data.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  Future<void> addHistory({
    required String id,
    required String title,
    required String filePath,
    required int pages,
    required DateTime createdAt,
  }) async {
    final history = getHistory();

    history.insert(0, {
      'id': id,
      'title': title,
      'filePath': filePath,
      'pages': pages,
      'createdAt': createdAt.toIso8601String(),
    });

    await _box.write(_historyKey, history);
  }

  Future<void> deleteHistory(String id) async {
    final history = getHistory();

    history.removeWhere((item) => item['id'] == id);

    await _box.write(_historyKey, history);
  }

  Future<void> renameHistory(String id, String title) async {
    final history = getHistory();

    final index = history.indexWhere((item) => item['id'] == id);

    if (index == -1) {
      return;
    }

    history[index]['title'] = title;

    await _box.write(_historyKey, history);
  }

  Future<void> clearHistory() async {
    await _box.remove(_historyKey);
  }
}
