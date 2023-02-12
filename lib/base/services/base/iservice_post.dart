abstract class IService<T> {
  Future<List<T>> getOffline();
  Future<List<T>> postOffline();
}

abstract class MixinService<T> implements IService {
  @override
  Future<List<T>> getOffline();
  @override
  Future<List<T>> postOffline();
}
