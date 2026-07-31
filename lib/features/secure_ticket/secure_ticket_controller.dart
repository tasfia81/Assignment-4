import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import '../../data/models/pass_model.dart';
import '../../data/repositories/pass_repository.dart';

class SecureTicketController extends GetxController {
  final String passId;
  final PassRepository _repository = Get.find<PassRepository>();

  final Rxn<PassModel> pass = Rxn<PassModel>();
  final RxInt secondsRemaining = 30.obs;
  final RxString dynamicOtp = "".obs;
  final RxBool isLoading = true.obs;

  Timer? _timer;

  SecureTicketController({required this.passId});

  @override
  void onInit() {
    super.onInit();
    _loadPassDetails();
    _startOtpRotation();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _loadPassDetails() {
    isLoading.value = true;
    final data = _repository.getPassById(passId);
    if (data != null) {
      pass.value = data;
      _generateNewOtp();
    }
    isLoading.value = false;
  }

  void _startOtpRotation() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 1) {
        secondsRemaining.value--;
      } else {
        secondsRemaining.value = 30;
        _generateNewOtp();
      }
    });
  }

  void _generateNewOtp() {
    final randomValue = Random().nextInt(900000) + 100000;
    final baseToken = pass.value?.qrCodeValue ?? "OMNIPASS_SECURE_TOKEN";
    dynamicOtp.value = "${baseToken}_otp_$randomValue";
  }

  void forceRefresh() {
    secondsRemaining.value = 30;
    _generateNewOtp();
  }
}
