class Course {
  String name;
  double completedPercentage;
  String author;
  String thumbnail;

  Course({
    required this.author,
    required this.completedPercentage,
    required this.name,
    required this.thumbnail,
  });
}

List<Course> courses = [
  Course(
    author: "DevWheels",
    completedPercentage: .75,
    name: "Flutter Novice to Ninja",
    thumbnail: 'assets/images/logo.png',
  ),
  Course(
    author: "DevWheels",
    completedPercentage: .60,
    name: "React Novice to Ninja",
    thumbnail: 'assets/images/logo.png',
  ),
  Course(
    author: "DevWheels",
    completedPercentage: .75,
    name: "Node - The complete guide",
    thumbnail: 'assets/images/logo.png',
  ),
  Course(
    author: "DevWheels",
    completedPercentage: .75,
    name: "Flutter Novice to Ninja",
    thumbnail: 'assets/images/logo.png',
  ),
  Course(
    author: "DevWheels",
    completedPercentage: .60,
    name: "React Novice to Ninja",
    thumbnail: 'assets/images/logo.png',
  ),
  Course(
    author: "DevWheels",
    completedPercentage: .75,
    name: "Node - The complete guide",
    thumbnail: 'assets/images/logo.png',
  ),
];