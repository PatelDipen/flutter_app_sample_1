// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'starship_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StarshipModelImpl _$$StarshipModelImplFromJson(Map<String, dynamic> json) =>
    _$StarshipModelImpl(
      name: json['name'] as String,
      model: json['model'] as String,
      manufacturer: json['manufacturer'] as String,
      costInCredits: json['cost_in_credits'] as String,
      length: json['length'] as String,
      maxAtmospheringSpeed: json['max_atmosphering_speed'] as String,
      crew: json['crew'] as String,
      passengers: json['passengers'] as String,
      cargoCapacity: json['cargo_capacity'] as String,
      starshipClass: json['starship_class'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$$StarshipModelImplToJson(_$StarshipModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'model': instance.model,
      'manufacturer': instance.manufacturer,
      'cost_in_credits': instance.costInCredits,
      'length': instance.length,
      'max_atmosphering_speed': instance.maxAtmospheringSpeed,
      'crew': instance.crew,
      'passengers': instance.passengers,
      'cargo_capacity': instance.cargoCapacity,
      'starship_class': instance.starshipClass,
      'url': instance.url,
    };

_$StarshipsResponseImpl _$$StarshipsResponseImplFromJson(
  Map<String, dynamic> json,
) => _$StarshipsResponseImpl(
  count: (json['count'] as num).toInt(),
  next: json['next'] as String?,
  previous: json['previous'] as String?,
  results: (json['results'] as List<dynamic>)
      .map((e) => StarshipModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$StarshipsResponseImplToJson(
  _$StarshipsResponseImpl instance,
) => <String, dynamic>{
  'count': instance.count,
  'next': instance.next,
  'previous': instance.previous,
  'results': instance.results,
};
