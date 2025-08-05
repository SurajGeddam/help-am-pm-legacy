// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      residentialService: json['residentialService'] as bool?,
      commercialService: json['commercialService'] as bool?,
      timeslots: (json['timeslots'] as List<dynamic>?)
          ?.map((e) => Timeslots.fromJson(e as Map<String, dynamic>))
          .toList(),
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] as String?,
      lastUpdatedAt: json['lastUpdatedAt'] as String?,
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'residentialService': instance.residentialService,
      'commercialService': instance.commercialService,
      'timeslots': instance.timeslots,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt,
      'lastUpdatedAt': instance.lastUpdatedAt,
    };

Timeslots _$TimeslotsFromJson(Map<String, dynamic> json) => Timeslots(
      id: json['id'] as int?,
      name: json['name'] as String?,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      isActive: json['isActive'] as bool?,
      pricing: json['pricing'] == null
          ? null
          : Pricing.fromJson(json['pricing'] as Map<String, dynamic>),
      categoryId: json['categoryId'] as int?,
      createdAt: json['createdAt'] as String?,
      lastUpdatedAt: json['lastUpdatedAt'] as String?,
      isSelected: json['isSelected'] as bool? ?? false,
    );

Map<String, dynamic> _$TimeslotsToJson(Timeslots instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'isActive': instance.isActive,
      'pricing': instance.pricing,
      'categoryId': instance.categoryId,
      'createdAt': instance.createdAt,
      'lastUpdatedAt': instance.lastUpdatedAt,
      'isSelected': instance.isSelected,
    };

Pricing _$PricingFromJson(Map<String, dynamic> json) => Pricing(
      id: json['id'] as int?,
      type: json['type'] as String?,
      residentialPrice: (json['residentialPrice'] as num?)?.toDouble() ?? 0.0,
      commercialPrice: (json['commercialPrice'] as num?)?.toDouble() ?? 0.0,
      isActive: json['isActive'] as bool?,
      currency: json['currency'] as String? ?? AppConstants.dollor,
      createdAt: json['createdAt'] as String?,
      lastUpdatedAt: json['lastUpdatedAt'] as String?,
    );

Map<String, dynamic> _$PricingToJson(Pricing instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'residentialPrice': instance.residentialPrice,
      'commercialPrice': instance.commercialPrice,
      'isActive': instance.isActive,
      'currency': instance.currency,
      'createdAt': instance.createdAt,
      'lastUpdatedAt': instance.lastUpdatedAt,
    };
