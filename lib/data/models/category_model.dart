import 'pass_model.dart';

class CategoryModel {
  final String categoryId;
  final String name;
  final PassCategoryType type;
  final String description;

  CategoryModel({
    required this.categoryId,
    required this.name,
    required this.type,
    required this.description,
  });
}
