import 'package:get/get.dart';
import '../../data/models/pass_model.dart';
import '../../data/repositories/pass_repository.dart';

class CategoryController extends GetxController {
  final String categoryId;
  final PassRepository _repository = Get.find<PassRepository>();

  final RxList<PassModel> categoryPasses = <PassModel>[].obs;
  final RxString categoryName = "".obs;

  CategoryController({required this.categoryId});

  @override
  void onInit() {
    super.onInit();
    _loadCategoryData();
  }

  void _loadCategoryData() {
    final cat = _repository.categories
        .firstWhereOrNull((c) => c.categoryId == categoryId);
    if (cat != null) {
      categoryName.value = cat.name;
    }
    categoryPasses.value = _repository.getPassesByCategoryId(categoryId);
  }
}
