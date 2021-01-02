class Note {
  String id;
  String name;
  String category;
  String priority;
  String status;
  String planDate;
  String createdDate;

  Note.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'] ?? '',
        name = json['name'] ?? '',
        category = json['category'] ?? '',
        priority = json['priority'] ?? '',
        status = json['status'] ?? '',
        planDate = json['planDate'] ?? '',
        createdDate = json['createdDate'] ?? '';

  Map<dynamic, dynamic> toJson()=>{
    'id':id??'',
    'name':name??'',
    'category':category??'',
    'priority':priority??'',
    'status':status??'',
    'planDate':planDate??'',
    'createdDate':createdDate??'',
  };
}
