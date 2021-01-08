class Category{
  String id;
  String name;
  String createdDate;

  Category.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'] ?? '',
        name = json['name'] ?? '',
        createdDate = json['createdDate'] ?? '';

  Map<dynamic, dynamic> toJson()=>{
    'id':id??'',
    'name':name??'',
    'createdDate':createdDate??'',
  };
}