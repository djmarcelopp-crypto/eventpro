abstract class QuoteMoney {
  static int reaisToCents(double reais) {
    return (reais * 100).round();
  }

  static double centsToReais(int cents) {
    return cents / 100;
  }
}
