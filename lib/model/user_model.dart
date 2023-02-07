// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());


User userFromJson(String str) => User.fromJson(json.decode(str));


class UserModel {
    UserModel({
        this.apiToken,
        this.user,
    });

    String? apiToken;
    User? user;

    UserModel copyWith({
        String? apiToken,
        User? user,
    }) => 
        UserModel(
            apiToken: apiToken ?? this.apiToken,
            user: user ?? this.user,
        );

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        apiToken: json["api_token"],
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "api_token": apiToken,
        "user": user!.toJson(),
    };
}

class User {
    User({
        this.id,
        this.fullName,
        this.degree,
        this.identityCard,
        this.pensionEntity,
        this.category,
        this.enrolled,
        this.verified,
    });

    int? id;
    String? fullName;
    String? degree;
    String? identityCard;
    String? pensionEntity;
    String? category;
    bool? enrolled;
    bool? verified;

    User copyWith({
        int? id,
        String? fullName,
        String? degree,
        String? identityCard,
        String? pensionEntity,
        String? category,
        bool? enrolled,
        bool? verified,
    }) => 
        User(
            id: id ?? this.id,
            fullName: fullName ?? this.fullName,
            degree: degree ?? this.degree,
            identityCard: identityCard ?? this.identityCard,
            pensionEntity: pensionEntity ?? this.pensionEntity,
            category: category ?? this.category,
            enrolled: enrolled ?? this.enrolled,
            verified: verified ?? this.verified,
        );

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        fullName: json["full_name"],
        degree: json["degree"],
        identityCard: json["identity_card"],
        pensionEntity: json["pension_entity"],
        category: json["category"],
        enrolled: json["enrolled"],
        verified: json["verified"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "degree": degree,
        "identity_card": identityCard,
        "pension_entity": pensionEntity,
        "category": category,
        "enrolled": enrolled,
        "verified": verified,
    };
}
