import 'package:dio/dio.dart';


class Requester {

  //O cliente Dio, configurado uma unica vez
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api-restaurantes-8qhh.onrender.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'}
    )
  );


  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    //Agora efetivamente o Post do submit
    try{
      final response = await _dio.post(path, data: body);
      return response.data;
    } on DioException catch (e) {
      //Transforma a mensagem de erro tecnica para melhorar a compreensão do usuario
      throw RequestException(_messageFor(e));
    }
  }

  String _messageFor(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'O servidor demorou para responder.';
      case DioExceptionType.connectionError:
        return 'Não foi possivel conectar ao servidor.';
      case DioExceptionType.badResponse:
        return _messageFromBody(e.response) ?? 'O servidor recusou o pedido' '(código ${e.response?.statusCode}).';

        default:
          return 'Erro inesperado na requisição.';
    }
  }
  String? _messageFromBody(Response? response) {
    final data = response?.data;
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return null;
  }
}

class RequestException implements Exception {
  final String message;

  RequestException(this.message);

  @override
  String toString() => message;
}