class BookModel {
  int? id;
  String? name;
  String? cover;

  BookModel({this.id, this.name, this.cover});

  BookModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cover = json['cover'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['cover'] = this.cover;
    return data;
  }
}
