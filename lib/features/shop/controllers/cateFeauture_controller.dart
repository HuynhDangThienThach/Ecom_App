import 'package:get/get.dart';
import 'package:t_store/data/repositories/categories/category_repository.dart';
import 'package:t_store/data/repositories/product/product_repository.dart';
import 'package:t_store/features/shop/models/category_model.dart';
import 'package:t_store/features/shop/models/product_model.dart';
import 'package:t_store/utils/popups/loaders.dart';

import '../../../data/repositories/categories/cateFeature_repository.dart';
import '../models/cateFeature_model.dart';

class CateFeautureController extends GetxController {
  static CateFeautureController get instance => Get.find();

  //--- Variables
  final isLoading = false.obs;
  final _cateFeatureRepository = Get.put(CatefeatureRepository());
  // RxList sẽ tự đông cập nhật khi có sự thay đổi trong danh sách
  RxList<CatefeatureModel> allCategories = <CatefeatureModel>[].obs;

  @override
  void onInit(){
    fetchCateFeature();
    super.onInit();
  }

  //--- Load category data
  Future<void> fetchCateFeature() async {
    try{
      isLoading.value = true;
      // Lấy loại hàng từ Fb
      final categories = await _cateFeatureRepository.getAllCategories();
      // Cập nhật danh sách loại hàng
      allCategories.assignAll(categories);
    }catch (e){
      TLoaders.errorSnackBar(title: 'Chà, thật đáng tiếc!', message: e.toString());
    } finally {
      // Remove Loader
      isLoading.value = false;
    }
  }
}
