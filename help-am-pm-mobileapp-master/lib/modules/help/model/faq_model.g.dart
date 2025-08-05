// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faq_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FaqModel _$FaqModelFromJson(Map<String, dynamic> json) => FaqModel(
      question: json['question'] as String? ?? AppStrings.emptyString,
      answer: json['answer'] as String? ?? AppStrings.emptyString,
    );

Map<String, dynamic> _$FaqModelToJson(FaqModel instance) => <String, dynamic>{
      'question': instance.question,
      'answer': instance.answer,
    };
