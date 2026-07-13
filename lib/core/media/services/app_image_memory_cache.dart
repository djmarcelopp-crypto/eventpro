import 'dart:typed_data';

class AppImageMemoryCache {
  AppImageMemoryCache({this.maxEntries = 20});

  final int maxEntries;
  final Map<String, Uint8List> _entries = {};
  final List<String> _order = [];

  Uint8List? get(String imageReference) => _entries[imageReference];

  void put(String imageReference, Uint8List bytes) {
    if (_entries.containsKey(imageReference)) {
      _order.remove(imageReference);
    }

    _entries[imageReference] = bytes;
    _order.add(imageReference);
    _evictIfNeeded();
  }

  void invalidate(String? imageReference) {
    if (imageReference == null) {
      return;
    }

    _entries.remove(imageReference);
    _order.remove(imageReference);
  }

  void clear() {
    _entries.clear();
    _order.clear();
  }

  void _evictIfNeeded() {
    while (_order.length > maxEntries) {
      final oldest = _order.removeAt(0);
      _entries.remove(oldest);
    }
  }
}
