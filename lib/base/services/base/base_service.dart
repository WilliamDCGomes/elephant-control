import 'package:elephant_control/base/context/elephant_context.dart';
import 'package:elephant_control/base/services/user_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../flavors.dart';

class BaseService extends GetConnect {
  SharedPreferences? sharedPreferences;
  late final ElephantContext context;
  final String baseUrlApi = F.baseURL;

  BaseService() {
    httpClient.timeout = const Duration(seconds: 30);
    allowAutoSignedCert = true;
    context = ElephantContext();
  }
  Future<String> getToken({bool getTokenForcado = false}) async {
    try {
      sharedPreferences ??= sharedPreferences = await SharedPreferences.getInstance();
      String? token = sharedPreferences!.getString('Token');
      final String? expiracaoToken = sharedPreferences?.getString('ExpiracaoToken');
      if (getTokenForcado || (expiracaoToken != null && DateTime.now().compareTo(DateTime.parse(expiracaoToken)) >= 0)) {
        String? _token = (await UserService().authenticate())?.token;
        if (_token == null) throw Exception();
        token = _token;
        sharedPreferences!.setString('Token', _token);
      }
      return token!;
    } catch (_) {
      throw Exception();
    }
  }

  bool hasErrorResponse(Response response) {
    return response.unauthorized || response.status.hasError || response.body == null;
  }

  @override
  Future<Response<T>> get<T>(String url,
      {Map<String, String>? headers, String? contentType, Map<String, dynamic>? query, Decoder<T>? decoder}) async {
    final response = await httpClient.get<T>(
      url,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
    );
    if (!response.unauthorized) return response;
    final token = await getToken(getTokenForcado: true);
    return httpClient.get<T>(
      url,
      contentType: contentType,
      query: query,
      headers: {"Authorization": 'Bearer ' + token},
      decoder: decoder,
    );
  }

  @override
  Future<Response<T>> post<T>(String? url, dynamic body,
      {String? contentType,
      Map<String, String>? headers,
      Map<String, dynamic>? query,
      Decoder<T>? decoder,
      Progress? uploadProgress}) async {
    final response = await httpClient.post<T>(
      url,
      body: body,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
    );
    if (!response.unauthorized) return response;
    final token = await getToken(getTokenForcado: true);
    return httpClient.post<T>(
      url,
      body: body,
      contentType: contentType,
      query: query,
      headers: {"Authorization": 'Bearer ' + token},
      decoder: decoder,
    );
  }
}
