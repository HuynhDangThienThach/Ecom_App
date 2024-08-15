import 'package:get/get.dart';
import 'package:t_store/data/repositories/banners/banner_resporitory.dart';
import 'package:t_store/features/shop/models/banner_model.dart';

import '../../../utils/popups/loaders.dart';

class BannerController extends GetxController {
  static BannerController get instance => Get.find();


  @override
  void onInit() {
    fetchBanner();
    super.onInit();
  } //--- Variables
  final isLoading = false.obs;
  final carousalCurrentIndex = 0.obs;
  // Là một RxList<BannerModel>, dùng để lưu trữ và quản lý danh sách các banner một cách phản ứng.
  // Khi RxList này thay đổi, mọi UI đang quan sát nó sẽ tự động được cập nhật.
  final RxList<BannerModel> banners = <BannerModel>[].obs;
  //--- Functions
  void  updatePageIndicator(index){
    carousalCurrentIndex.value  = index;
  }
  //--- Fetch Banners
  Future<void> fetchBanner() async {
    try{
      // Hiển thị loader khi cập nhật
      isLoading.value = true;

      // Lấy banner từ Fb
      final bannerRepo = Get.put(BannerRepository());
      final banners = await bannerRepo.fetchBanners();

      // Gán vào BannerModel
      this.banners.assignAll(banners);
    }catch (e){
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      // Remove Loader
      isLoading.value = false;
    }
  }
}
