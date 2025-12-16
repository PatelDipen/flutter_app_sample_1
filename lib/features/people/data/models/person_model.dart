import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/person.dart';

part 'person_model.freezed.dart';
part 'person_model.g.dart';

@freezed
class PersonModel with _$PersonModel {
  const PersonModel._();

  const factory PersonModel({
    required String name,
    required String height,
    required String mass,
    @JsonKey(name: 'hair_color') required String hairColor,
    @JsonKey(name: 'skin_color') required String skinColor,
    @JsonKey(name: 'eye_color') required String eyeColor,
    @JsonKey(name: 'birth_year') required String birthYear,
    required String gender,
    required String url,
  }) = _PersonModel;

  factory PersonModel.fromJson(Map<String, dynamic> json) =>
      _$PersonModelFromJson(json);

  Person toEntity() {
    return Person(
      name: name,
      height: height,
      mass: mass,
      hairColor: hairColor,
      skinColor: skinColor,
      eyeColor: eyeColor,
      birthYear: birthYear,
      gender: gender,
      url: url,
    );
  }
}

@freezed
class PeopleResponse with _$PeopleResponse {
  const factory PeopleResponse({
    required int count,
    String? next,
    String? previous,
    required List<PersonModel> results,
  }) = _PeopleResponse;

  factory PeopleResponse.fromJson(Map<String, dynamic> json) =>
      _$PeopleResponseFromJson(json);
}
