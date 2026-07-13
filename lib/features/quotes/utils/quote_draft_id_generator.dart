class QuoteDraftIdGenerator {
  int _counter = 0;

  String nextLineDraftId() {
    _counter += 1;
    return 'line_$_counter';
  }
}
