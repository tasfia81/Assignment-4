import 'package:get/get.dart';
import '../../data/models/category_model.dart';
import '../../data/models/pass_model.dart';
import '../../data/repositories/pass_repository.dart';

class WalletController extends GetxController {
  final PassRepository _repository = Get.find<PassRepository>();

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxList<PassModel> activePasses = <PassModel>[].obs;
  final RxList<PassModel> allPasses = <PassModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadWalletData();
  }

  void _loadWalletData() {
    categories.value = _repository.getCategories();
    allPasses.value = _repository.passes;
    activePasses.value = _repository.passes
        .where((p) => p.status == PassStatus.active)
        .toList();
  }

  int get activeCount => activePasses.length;
}
