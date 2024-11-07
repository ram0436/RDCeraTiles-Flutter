// To parse this JSON data, do
//
//     final getAllGadgetResponseModel = getAllGadgetResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

List<GetAllProductResponseModel> getAllGadgetResponseModelFromJson(
        String str) =>
    List<GetAllProductResponseModel>.from(
        json.decode(str).map((x) => GetAllProductResponseModel.fromJson(x)));

String getAllGadgetResponseModelToJson(List<GetAllProductResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetAllProductResponseModel {
  int? id;
  List<ProductImageList>? productImageList;
  int? subCategoryId;
  int? locationId;
  int? categoryId;
  int? parentCategoryId;
  int? boxCount;
  int? brandId;
  int? punchId;
  String? name;
  String? productCode;
  int? price;
  String? series;
  String? size;
  String? weight;
  String? coverageArea;
  String? piecesPerBox;
  String? thickness;
  int? createdBy;
  int? modifiedBy;
  String? modifiedOn;
  String? createdOn;
  List<ProductModel>? productModel;

  GetAllProductResponseModel(
      {this.id,
      this.productImageList,
      this.subCategoryId,
      this.locationId,
      this.categoryId,
      this.parentCategoryId,
      this.name,
      this.productCode,
      this.price,
      this.series,
      this.size,
      this.weight,
      this.piecesPerBox,
      this.coverageArea,
      this.thickness,
      this.brandId,
      this.punchId,
      this.createdBy,
      this.createdOn,
      this.modifiedBy,
      this.modifiedOn,
      this.boxCount,
      this.productModel});

  factory GetAllProductResponseModel.fromJson(Map<String, dynamic> json) =>
      GetAllProductResponseModel(
        id: json["id"],
        productImageList: json["productImageList"] == null
            ? []
            : List<ProductImageList>.from(json["productImageList"]!
                .map((x) => ProductImageList.fromJson(x))),
        subCategoryId: json["subCategoryId"],
        locationId: json["locationId"],
        categoryId: json["categoryId"],
        parentCategoryId: json["parentCategoryId"],
        brandId: json["brandId"],
        punchId: json["punchId"],
        name: json["name"],
        productCode: json["productCode"],
        price: json["price"],
        series: json["series"],
        weight: json["weight"],
        size: json["size"],
        piecesPerBox: json["piecesPerBox"],
        coverageArea: json["coverageArea"],
        thickness: json["thickness"],
        boxCount: json["boxCount"],
        createdBy: json["createdBy"],
        createdOn: json["createdOn"],
        modifiedBy: json["modifiedBy"],
        modifiedOn: json["modifiedOn"],
        productModel: json["productModel"] == null
            ? []
            : List<ProductModel>.from(
                json["productModel"]!.map((x) => ProductModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productImageList": productImageList == null
            ? []
            : List<dynamic>.from(productImageList!.map((x) => x.toJson())),
        "subCategoryId": subCategoryId,
        "locationId": locationId,
        "categoryId": categoryId,
        "parentCategoryId": parentCategoryId,
        "name": name,
        "productCode": productCode,
        "weight": weight,
        "series": series,
        "size": size,
        "coverageArea": coverageArea,
        "piecesPerBox": piecesPerBox,
        "thickness": thickness,
        "boxCount": boxCount,
        "price": price,
        "brandId": brandId,
        "punchId": punchId,
        "createdBy": createdBy,
        "createdOn": createdOn,
        "modifiedBy": modifiedBy,
        "modifiedOn": modifiedOn,
      };
}

class ProductImageList {
  int? productId;
  int? id;
  String? imageUrl;

  ProductImageList({
    this.productId,
    this.id,
    this.imageUrl,
  });

  factory ProductImageList.fromJson(Map<String, dynamic> json) =>
      ProductImageList(
        productId: json["productId"],
        id: json["id"],
        imageUrl: json["imageURL"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "id": id,
        "imageURL": imageUrl,
      };
}

class ProductModel {
  int id;
  String model;
  int boxCount;
  int productId;
  TextEditingController modelController;
  TextEditingController boxCountController;

  ProductModel({
    required this.id,
    required this.model,
    required this.boxCount,
    required this.productId,
  })  : modelController = TextEditingController(text: model),
        boxCountController = TextEditingController(text: boxCount.toString());

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        productId: json["productId"],
        id: json["id"],
        boxCount: json["boxCount"],
        model: json["model"],
      );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "model": model,
      "boxCount": int.tryParse(boxCountController.text) ?? 0,
      "productId": productId,
    };
  }

  // Override toString for better debug output
  @override
  String toString() {
    return 'ProductModel{id: $id, model: $model, boxCount: $boxCount, productId: $productId}';
  }
}
