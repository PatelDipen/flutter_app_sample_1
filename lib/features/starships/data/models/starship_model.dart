import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/starship.dart';

part 'starship_model.freezed.dart';
part 'starship_model.g.dart';

@freezed
class StarshipModel with _$StarshipModel {
  const StarshipModel._();

  const factory StarshipModel({
    required String name,
    required String model,
    required String manufacturer,
    @JsonKey(name: 'cost_in_credits') required String costInCredits,
    required String length,
    @JsonKey(name: 'max_atmosphering_speed') required String maxAtmospheringSpeed,
    required String crew,
    required String passengers,
    @JsonKey(name: 'cargo_capacity') required String cargoCapacity,
    @JsonKey(name: 'starship_class') required String starshipClass,
    required String url,
  }) = _StarshipModel;

  factory StarshipModel.fromJson(Map<String, dynamic> json) =>
      _$StarshipModelFromJson(json);

  Starship toEntity() {
    return Starship(
      name: name,
      model: model,
      manufacturer: manufacturer,
      costInCredits: costInCredits,
      length: length,
      maxAtmospheringSpeed: maxAtmospheringSpeed,
      crew: crew,
      passengers: passengers,
      cargoCapacity: cargoCapacity,
      starshipClass: starshipClass,
      url: url,
    );
  }
}

@freezed
class StarshipsResponse with _$StarshipsResponse {
  const factory StarshipsResponse({
    required int count,
    String? next,
    String? previous,
    required List<StarshipModel> results,
  }) = _StarshipsResponse;

  factory StarshipsResponse.fromJson(Map<String, dynamic> json) =>
      _$StarshipsResponseFromJson(json);
}
