import 'package:get/get.dart';
import '../../data/models/pass_model.dart';
import '../../data/repositories/pass_repository.dart';

class PassDetailController extends GetxController {
  final String passId;
  final PassRepository _repository = Get.find<PassRepository>();

  final Rxn<PassModel> pass = Rxn<PassModel>();
  final RxBool isLoading = true.obs;

  PassDetailController({required this.passId});

  @override
  void onInit() {
    super.onInit();
    _loadPassDetails();
  }

  void _loadPassDetails() {
    isLoading.value = true;
    final data = _repository.getPassById(passId);
    if (data != null) {
      pass.value = data;
    }
    isLoading.value = false;
  }
}
