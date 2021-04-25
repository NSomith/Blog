import 'package:blog/Models/addBlogModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ListModel.g.dart';

@JsonSerializable()
class ListModel {
  List<AddBlogModel> data;
   ListModel({this.data});
  factory ListModel.fromJson(Map<String, dynamic> json) =>
      _$ListModelFromJson(json);
  Map<String, dynamic> toJson() => _$ListModelToJson(this);
}