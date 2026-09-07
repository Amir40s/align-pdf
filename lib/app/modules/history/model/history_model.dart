class HistoryItem {
  final String id;
  final String title;
  final String filePath;
  final int pages;
  final DateTime createdAt;

  const HistoryItem({
    required this.id,
    required this.title,
    required this.filePath,
    required this.pages,
    required this.createdAt,
  });

  factory HistoryItem.fromMap(Map<String, dynamic> map) {
    return HistoryItem(
      id: map['id'] as String,
      title: map['title'] as String,
      filePath: map['filePath'] as String,
      pages: map['pages'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
