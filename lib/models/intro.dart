class Intro {
  String title;
  List<String> paragraph;

  Intro({required this.title, required this.paragraph});

  @override
  String toString() {
    return 'Intro{title: $title, paragraph: $paragraph}';
  }

  factory Intro.fromJson(Map<String, dynamic> json) {
    return Intro(title: json["title"], paragraph: List.from(json["paragraph"]));
  }
}