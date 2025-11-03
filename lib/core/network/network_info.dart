import 'package:injectable/injectable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get connectivityStream;
}

@Injectable(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;
  final Dio _dio;

  NetworkInfoImpl(this._connectivity, this._dio);

  @override
  Future<bool> get isConnected async {
    try {
      // Check connectivity status
      final result = await _connectivity.checkConnectivity();
      if (result == ConnectivityResult.none) {
        return false;
      }

      // Try to make a simple HTTP request to verify internet connectivity
      final response = await _dio.get(
        'https://www.google.com',
        options: Options(
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<bool> get connectivityStream {
    return _connectivity.onConnectivityChanged.asyncMap((result) async {
      if (result == ConnectivityResult.none) {
        return false;
      }

      // Verify actual internet connectivity
      return await isConnected;
    });
  }
}