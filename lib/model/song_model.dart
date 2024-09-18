import 'package:flutter/material.dart';

class SongModel {
  int? id;
  String? title;
  String? url;
  List<Artists>? artists;
  String? createdAt;
  String? updatedAt;
  bool isPlaying = false;

  SongModel(
      {this.id,
      this.title,
      this.url,
      this.artists,
      this.createdAt,
      this.updatedAt,
      this.isPlaying = false});

  SongModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    url = json['url'];
    if (json['artists'] != null) {
      artists = <Artists>[];
      json['artists'].forEach((v) {
        artists!.add(Artists.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['url'] = url;
    if (artists != null) {
      data['artists'] = artists!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;

    return data;
  }
}

class Artists {
  int? id;
  String? name;
  List<SongModel>? songs;
  bool isSelected = false;

  Artists({this.id, this.name, this.isSelected = false});

  Artists.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['songs'] != null) {
      songs = <SongModel>[];
      json['songs'].forEach((v) {
        songs!.add(SongModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (songs != null) {
      data['songs'] = songs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
