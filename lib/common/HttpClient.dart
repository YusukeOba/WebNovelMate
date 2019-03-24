import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

enum HttpMethod { post, get, put, delete }

/// 依存側でマッピング処理を変更できるようにしてある
typedef Mapper<T> = T Function(String responseBody);

/// 汎用のHTTPリクエスト処理
class CustomHttpClient {
  /// 指定された[url]をもとにHTTPSリクエストを行う
  /// リクエストするHTTPメソッドの種類は[method]
  /// リクエストヘッダは[header]で指定する
  ///
  /// レスポンス結果は[mapper]で依存元が変換を行う
  static Future<T> request<T>(HttpMethod method, String url, Mapper<T> mapper,
      {bool gzipCompress = false, Map<String, String> header}) async {
    if (method == HttpMethod.get) {
      return http.get(url, headers: header).then((response) async {
        // 通信エラー
        if (response.statusCode >= 300) {
          throw Exception("Error. Http response not invalid.");
        }

        String responseText;
        if (gzipCompress) {
          responseText = await _deCompressGzip(response.bodyBytes);
        } else {
          responseText = utf8.decode(response.bodyBytes);
        }

        return Future.value(mapper(responseText));
      });
    }

    // TODO: post, put, delete 実装
    throw Exception("ERROR. NOT IMPLEMENTS.");
  }

  /// gzip圧縮済のバイト配列を解凍して返す
  static Future<String> _deCompressGzip(List<int> encodedBytes) {
    return Future(() {
      final decodedBytes = gzip.decode(encodedBytes);
      final decodedString = String.fromCharCodes(decodedBytes);
      return decodedString;
    });
  }
}
