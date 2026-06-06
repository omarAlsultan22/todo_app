import 'package:todo_app/constants/app_sizes.dart';
import 'package:todo_app/data/models/task_model.dart';


class CategoryData {
  final List<TaskModel> products;
  final bool hasMore;
  final int offset;

  const CategoryData({
    this.products = const [],
    this.hasMore = true,
    this.offset = AppSizes.none,
  });

  int get length => products.length;

  bool get productsIsEmpty => products.isEmpty;

  CategoryData copyWith({
    List<TaskModel>? products,
    bool? hasMore,
    int? offset
  }) {
    return CategoryData(
        products: products ?? this.products,
        hasMore: hasMore ?? this.hasMore,
        offset: offset ?? this.offset
    );
  }
}