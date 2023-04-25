class Todo {
  String? title;
  String? date;
  String? image;
  String? content;

  Todo({
    this.title,
    this.date,
    this.image,
    this.content,
  });

  @override
  String toString() {
    return "{title: $title, date: $date, image: $image, content: $content}";
  }

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        title: json["title"],
        date: json["date"],
        image: json["image"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["title"] = title;
    data["date"] = date;
    data["image"] = image;
    data["content"] = content;

    return data;
  }
}
