import 'dart:html';

import 'package:http/http.dart';
import 'package:rss_dart/dart_rss.dart';

Future<RssFeed> getRssFeed(Client client) async {
  Response response = Response('', 200);
  try {
    response = await client.get(Uri(
      scheme: 'https',
      host: 'medium.com',
      path: '/feed/@ktuusj',
    ));
  } catch (e) {
    print(e);
  }

  return RssFeed.parse(response.body);
}
