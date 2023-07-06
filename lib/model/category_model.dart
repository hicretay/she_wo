class CategoryModel {
  String? image;
  String? leading;

  CategoryModel({this.image, this.leading});
}

List<CategoryModel> homeCategoryList = [
  CategoryModel(leading: 'Spa', image: 'assets/images/spa.jpg'),
  CategoryModel(leading: 'Kuaför', image: 'assets/images/hair.jpg'),
  CategoryModel(leading: 'Tırnak Bakım', image: 'assets/images/nail.jpg'),
  CategoryModel(leading: 'Güzellik Salonu', image: 'assets/images/salon.jpg'),
];
