import 'package:http/http.dart';
import 'package:rss_dart/dart_rss.dart';

void main(List<String> arguments) {
  Client client = Client();
  getRssFeed(client).then((value) {
    List<Information> informationList = parseRSS(value);
    printInformationList(informationList);
  });
}

void printInformationList(List<Information> informationList) {
  print('--- Information List ---');
  for (var information in informationList) {
    print('Date: ${information.date}');
    print('Title: ${information.title}');
    print('Text: ${information.text}');
    print('Image URL: ${information.imageUrl ?? 'N/A'}');
    print('Link: ${information.link ?? 'N/A'}');
    print('------------------------');
  }
}

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

List<Information> parseRSS(RssFeed feed) {
  List<Information> informationList = [];
  for (var item in feed.items) {
    Information blogInformation = Information(
      date: item.pubDate!,
      title: item.title!,
      text: item.content!.value,
      imageUrl: item.content?.images.first,
      link: feed.items.first.link,
    );
    informationList.add(blogInformation);
  }
  return informationList;
}

class Information {
  String date;
  String title;
  String text;
  String? link;
  String? imageUrl;
  String? uuid;
  Information({
    required this.date,
    required this.title,
    required this.text,
    this.link,
    this.imageUrl,
    this.uuid,
  });
}
