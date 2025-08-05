import 'package:json_annotation/json_annotation.dart';
import '../../../../../utils/app_strings.dart';

part 'faq_model.g.dart';

@JsonSerializable()
class FaqModel {
  String question;
  String answer;

  FaqModel({
    this.question = AppStrings.emptyString,
    this.answer = AppStrings.emptyString,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) =>
      _$FaqModelFromJson(json);

  Map<String, dynamic> toJson() => _$FaqModelToJson(this);
}
