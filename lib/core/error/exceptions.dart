class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
}

class DataException implements Exception {
  final String message;
  const DataException(this.message);
}