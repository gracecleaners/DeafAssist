import 'package:cloud_firestore/cloud_firestore.dart';

class Courses {
  String? id;
  String? name;
  String? description;
  String? instructor;
  String? instructorBio;
  String? instructorImage;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  String? mode;
  String? location;
  String? imageUrl;
  List<String>? objectives;
  double? price;
  int? duration; // in weeks
  String? difficulty;

  Courses({
    this.id,
    this.name,
    this.description,
    this.instructor,
    this.instructorBio,
    this.instructorImage,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.mode,
    this.location,
    this.imageUrl,
    this.objectives,
    this.price,
    this.duration,
    this.difficulty,
  });

  // Sample courses list with expanded details
  static List<Courses> sampleCourses = [
    Courses(
      id: "1",
      name: "Basic Sign Language",
      description: "An introductory course to American Sign Language (ASL) designed for beginners to communicate effectively with deaf individuals.",
      instructor: "Jane Doe",
      instructorBio: "Jane is a certified ASL instructor with over 10 years of teaching experience.",
      instructorImage: "https://example.com/images/jane_doe.jpg",
      startDate: "2024-01-15",
      endDate: "2024-03-15",
      startTime: "10:00 AM",
      endTime: "12:00 PM",
      mode: "Online",
      location: null,
      imageUrl: "assets/images/1.png",
      objectives: [
        "Learn basic ASL vocabulary.",
        "Understand deaf culture.",
        "Practice common phrases for daily communication."
      ],
      price: 199.99,
      duration: 8,
      difficulty: "Beginner",
    ),
     Courses(
    id: "2",
    name: "Deaf Awareness Workshop",
    description: "A workshop aimed at creating awareness about the challenges and strengths of the deaf community.",
    instructor: "John Smith",
    instructorBio: "John is an advocate for the rights of the deaf and has been conducting workshops globally.",
    instructorImage: "https://example.com/images/john_smith.jpg",
    startDate: "2024-02-01",
    endDate: "2024-02-02",
    startTime: "09:00 AM",
    endTime: "03:00 PM",
    mode: "Physical",
    location: "Community Center, Main Street",
    imageUrl: "assets/images/2.png",
    objectives: [
      "Increase understanding of deaf culture.",
      "Learn about assistive technologies for the deaf.",
      "Encourage inclusivity in workplaces and schools."
    ],
  ),
  Courses(
    id: "3",
    name: "Advanced Sign Language",
    description: "An advanced ASL course for those looking to achieve fluency and communicate at a professional level.",
    instructor: "Mary Johnson",
    instructorBio: "Mary is a deaf ASL instructor with a master's degree in Deaf Education.",
    instructorImage: "https://example.com/images/mary_johnson.jpg",
    startDate: "2024-03-20",
    endDate: "2024-06-20",
    startTime: "04:00 PM",
    endTime: "06:00 PM",
    mode: "Online",
    location: null,
    imageUrl: "assets/images/3.png",
    objectives: [
      "Master complex ASL grammar.",
      "Enhance vocabulary for professional settings.",
      "Participate in real-time conversations with native ASL users."
    ],
  ),
  Courses(
    id: "4",
    name: "Teaching Deaf Students",
    description: "A specialized course for educators who want to improve teaching methods for deaf students.",
    instructor: "Dr. Emily Carter",
    instructorBio: "Dr. Carter is a researcher in inclusive education with a focus on the deaf community.",
    instructorImage: "https://example.com/images/emily_carter.jpg",
    startDate: "2024-04-10",
    endDate: "2024-06-10",
    startTime: "01:00 PM",
    endTime: "03:00 PM",
    mode: "Physical",
    location: "Education Hub, Downtown",
    imageUrl: "assets/images/1.png",
    objectives: [
      "Develop inclusive lesson plans.",
      "Understand the needs of deaf students.",
      "Learn about adaptive teaching tools and technologies."
    ],
  ),
  Courses(
    id: "5",
    name: "Interpreting for the Deaf",
    description: "A professional course to train interpreters in providing accurate and culturally sensitive ASL interpretation.",
    instructor: "Peter Gray",
    instructorBio: "Peter is a certified interpreter with 15 years of field experience.",
    instructorImage: "https://example.com/images/peter_gray.jpg",
    startDate: "2024-05-01",
    endDate: "2024-08-01",
    startTime: "05:00 PM",
    endTime: "07:00 PM",
    mode: "Online",
    location: null,
    imageUrl: "assets/images/2.png",
    objectives: [
      "Understand ethical guidelines for interpreters.",
      "Master ASL for various settings (legal, medical, etc.).",
      "Improve accuracy and speed in interpretation."
    ],
  ),
  Courses(
    id: "6",
    name: "Assistive Technologies for the Deaf",
    description: "Learn about the latest technologies that aid communication and accessibility for the deaf community.",
    instructor: "Dr. Rachel Lee",
    instructorBio: "Dr. Lee is an engineer specializing in accessibility technologies.",
    instructorImage: "https://example.com/images/rachel_lee.jpg",
    startDate: "2024-06-15",
    endDate: "2024-07-15",
    startTime: "02:00 PM",
    endTime: "04:00 PM",
    mode: "Physical",
    location: "Tech Park, City Center",
    imageUrl: "assets/images/3.png",
    objectives: [
      "Explore hearing aids and cochlear implants.",
      "Understand captioning and transcription software.",
      "Learn about real-time translation apps and devices."
    ],
  ),
  ];

  // Method to find a course by ID
  static Courses? getCourseById(String id) {
    return sampleCourses.firstWhere((course) => course.id == id);
  }
}