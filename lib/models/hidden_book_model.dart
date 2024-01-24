class HiddenBookModel {
  int? id;
  String? encryptedData;
  dynamic key;

  HiddenBookModel({this.id, this.encryptedData});

  HiddenBookModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    encryptedData = json['encryptedData'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['encryptedData'] = this.encryptedData;
    data['key'] = this.key;
    return data;
  }
}
