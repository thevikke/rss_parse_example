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

Future<List<Information>> parseRSSToInformationList(RssFeed feed) {
  final dateRegexp = RegExp(r'(?=\s[A-G]).*(?<=\d\d\d\d\s)');
  final contentRegexp = RegExp(r'(?<=<p>)(.*?)(?=\<)');

  for (var item in feed.items) {
    Information blogInformation = Information(
      startTime: dateRegexp.firstMatch(item.pubDate!)?[0] ?? "Unknown",
      endTime: '',
      title: item.title!,
      text: contentRegexp
          .allMatches(item.content!.value)
          .first
          .group(0)
          .toString(),
      type: 'blog',
      imageUrl: item.content?.images.first,
      link: feed.items.first.link,
    );
    return blogInformation;
  }
}

class Information {
  String startTime;
  String endTime;
  String title;
  String text;
  String? link;
  String? imageUrl;
  String? uuid;
  String type;
  Information(
      {required this.startTime,
      required this.endTime,
      required this.title,
      required this.text,
      this.link,
      this.imageUrl,
      this.uuid,
      required this.type});
}
