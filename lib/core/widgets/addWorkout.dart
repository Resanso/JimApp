import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jim/core/constants/app_colors.dart';
import 'package:jim/core/constants/app_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddWorkoutScreen extends StatefulWidget {
  const AddWorkoutScreen({super.key});

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _movementsController = TextEditingController();
  String? _selectedMuscle;

  // List of available muscles from body.svg
  final List<Map<String, String>> muscles = [
    {'id': 'abs', 'name': 'Abs'},
    {'id': 'chest', 'name': 'Chest'},
    {'id': 'back', 'name': 'back'},
    {'id': 'bicep', 'name': 'Biceps'},
    {'id': 'shoulder', 'name': 'shoulder'},
    {'id': 'tricep', 'name': 'Triceps'},
    {'id': 'forearm', 'name': 'forearm'},
    {'id': 'leg', 'name': 'Legs'},
    {'id': 'traps', 'name': 'Traps'},
    {'id': 'calf', 'name': 'Calves'},
  ];

  Future<void> _submitWorkout() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) throw 'User not authenticated';

        await FirebaseFirestore.instance.collection('workouts').add({
          'name': _nameController.text,
          'target_muscles': _selectedMuscle,
          'movements': _movementsController.text,
          'image': _imageUrlController.text,
          'created_at': DateTime.now(),
          'userId': user.uid, // Tambahkan user ID
        });
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: Text('Add New Workout', style: AppStyles.heading2),
        backgroundColor: AppColors.secondaryDark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                style: AppStyles.body1,
                decoration: const InputDecoration(
                  labelText: 'Workout Name',
                  hintText: 'e.g., Bench Press',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a workout name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedMuscle,
                style: AppStyles.body1,
                dropdownColor: AppColors.secondaryDark,
                decoration: const InputDecoration(
                  labelText: 'Target Muscles',
                  fillColor: AppColors.secondaryDark,
                  filled: true,
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.accentGreen),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.accentGreen),
                  ),
                ),
                items: muscles.map((muscle) {
                  return DropdownMenuItem(
                    value: muscle['id'],
                    child: Text(
                      muscle['name']!,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMuscle = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a target muscle';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _movementsController,
                style: AppStyles.body1,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Movement Description',
                  hintText: 'Describe the movement...',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the movements';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                style: AppStyles.body1,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  hintText: 'Enter workout image URL',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitWorkout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentGreen,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: Text('Add Workout', style: AppStyles.button),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
