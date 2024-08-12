class Category {
  String thumbnail;
  String name;
  int noOfCourses;

  Category({
    required this.name,
    required this.noOfCourses,
    required this.thumbnail,
  });
}

List<Category> categoryList = [
  Category(
    name: 'Development',
    noOfCourses: 55,
    thumbnail: 'assets/images/logo.png',
  ),
  Category(
    name: 'Accounting',
    noOfCourses: 20,
    thumbnail: 'assets/images/logo.png',
  ),
  Category(
    name: 'Photography',
    noOfCourses: 16,
    thumbnail: 'assets/images/logo.png',
  ),
  Category(
    name: 'Product Design',
    noOfCourses: 25,
    thumbnail: 'assets/images/logo.png',
  ),
];