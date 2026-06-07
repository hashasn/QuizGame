/// Data-layer exceptions thrown by remote/local data sources and caught by repositories, which convert them to [Failure].
class ServerException implements Exception {}

class CacheException implements Exception {}

class QuizException implements Exception {}
