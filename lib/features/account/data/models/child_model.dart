import 'package:school_cafteria/features/account/data/models/school_model.dart';
import 'package:school_cafteria/features/account/domain/entities/child.dart';

class ChildModel extends Child{

  ChildModel({
  super.id,
  super.name,
  super.userName,
  super.email,
  super.image,
  super.mobile,
  super.isActive,
  super.schoolId,
  super.supervisorId,
  super.createdAt,
  super.updatedAt,
  super.parentId,
  super.uuid,
  super.balance,
    super.school,
    super.accessTokenParent,
    super.weeklyBalance
});
 ChildModel.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  name = json['name'];
  userName = json['user_name'];
  email = json['email'];
  image = json['image'];
  mobile = json['mobile'];
  isActive = json['is_active'];
  schoolId = json['school_id'];
  supervisorId = json['supervisor_id'];
  createdAt = json['created_at'];
  updatedAt = json['updated_at'];
  parentId = json['parent_id'];
  uuid = json['uuid'];
  accessTokenParent=json["accessTokenParent"];
  balance = json['balance'];
  weeklyBalance =json['weekly_balance'];
  school =
  json['school'] != null ?  SchoolModel.fromJson(json['school']) : null; }

 Map<String, dynamic> toJson() {
  final Map<String, dynamic> data =  <String, dynamic>{};
  data['id'] = id;
  data['name'] = name;
  data['user_name'] = userName;
  data['email'] = email;
  data['image'] = image;
  data['mobile'] = mobile;
  data['is_active'] = isActive;
  data['school_id'] = schoolId;
  data['supervisor_id'] = supervisorId;
  data['created_at'] = createdAt;
  data['updated_at'] = updatedAt;
  data['parent_id'] = parentId;
  data['uuid'] = uuid;
  data['balance'] = balance;
  data['weekly_balance']=weeklyBalance;
  data['school']=school;
  data["accessTokenParent"]=accessTokenParent;
  return data;
 }

}