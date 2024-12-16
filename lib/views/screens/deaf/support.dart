import 'package:flutter/material.dart';

class SupportScreen extends StatefulWidget {
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final List<Map<String, dynamic>> _supportOptions = [
    {
      'icon': Icons.help_outline,
      'title': 'FAQ',
      'subtitle': 'Frequently Asked Questions'
    },
    {
      'icon': Icons.contact_support,
      'title': 'Contact Support',
      'subtitle': 'Get help from our team'
    },
    {
      'icon': Icons.report_problem,
      'title': 'Report an Issue',
      'subtitle': 'Submit a new inquiry'
    },
    {
      'icon': Icons.chat_bubble_outline,
      'title': 'Community Forum',
      'subtitle': 'Discuss with other users'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.black,)),
        title: Text('Support Center', style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search support topics',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          // Support Options List
          Expanded(
            child: ListView.builder(
              itemCount: _supportOptions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(_supportOptions[index]['icon'],
                      color: Theme.of(context).primaryColor),
                  title: Text(_supportOptions[index]['title']),
                  subtitle: Text(_supportOptions[index]['subtitle']),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to respective support sections
                    _navigateToSupportOption(index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToSupportOption(int index) {
    switch (index) {
      case 0:
        // Navigate to FAQ
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FAQScreen()));
        break;
      case 1:
        // Navigate to Contact Support
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ContactSupportScreen()));
        break;
      case 2:
        // Navigate to Inquiry Submission
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => InquirySubmissionScreen()));
        break;
      case 3:
        // Navigate to Community Forum
        // Placeholder for community forum navigation
        break;
    }
  }
}

class InquirySubmissionScreen extends StatefulWidget {
  @override
  _InquirySubmissionScreenState createState() =>
      _InquirySubmissionScreenState();
}

class _InquirySubmissionScreenState extends State<InquirySubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedCategory = 'General Inquiry';
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> _inquiryCategories = [
    'General Inquiry',
    'Technical Support',
    'Billing',
    'Feature Request',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Inquiry'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Inquiry Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Inquiry Category',
                  border: OutlineInputBorder(),
                ),
                items: _inquiryCategories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Subject Input
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  labelText: 'Subject',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Description Input
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Attachment Option (Optional)
              ElevatedButton.icon(
                icon: Icon(Icons.attach_file),
                label: Text('Add Attachment'),
                onPressed: () {
                  // Implement file attachment logic
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              SizedBox(height: 16),

              // Submit Button
              ElevatedButton(
                child: Text('Submit Inquiry'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _submitInquiry,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitInquiry() {
    if (_formKey.currentState!.validate()) {
      // Perform submission logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Inquiry submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Reset form after submission
      _subjectController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedCategory = 'General Inquiry';
      });
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

// Placeholder screens for navigation
class FAQScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Frequently Asked Questions')),
      body: Center(child: Text('FAQ Content Here')),
    );
  }
}

class ContactSupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contact Support')),
      body: Center(child: Text('Contact Support Details Here')),
    );
  }
}
