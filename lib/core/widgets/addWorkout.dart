// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import 'button.dart';
import 'textFields.dart';

/// Widget untuk menambahkan latihan baru ke dalam aplikasi.
///
/// Screen ini memungkinkan pengguna untuk memasukkan detail latihan baru seperti:
/// - Nama latihan
/// - Target otot yang dilatih
/// - Deskripsi gerakan
/// - URL gambar latihan
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

  /// Daftar otot yang tersedia untuk dipilih.
  /// Setiap otot memiliki id dan nama yang ditampilkan.
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

  /// Method untuk mengirim data latihan baru ke Firestore.
  ///
  /// Method ini akan:
  /// 1. Memvalidasi form
  /// 2. Mengecek autentikasi pengguna
  /// 3. Menyimpan data ke koleksi 'workouts' di Firestore
  /// 4. Kembali ke halaman sebelumnya jika berhasil
  /// 5. Menampilkan pesan error jika gagal
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
          'userId': user.uid,
        });
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } catch (e) {
        // ignore: use_build_context_synchronously
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
              /// TextField untuk nama latihan
              CustomTextField(
                controller: _nameController,
                labelText: 'Workout Name',
                hintText: 'e.g., Bench Press',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a workout name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              /// Dropdown untuk memilih target otot
              CustomDropdownField<String>(
                value: _selectedMuscle,
                items: muscles.map((muscle) {
                  return DropdownMenuItem(
                    value: muscle['id'],
                    child: Text(
                      muscle['name']!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMuscle = value;
                  });
                },
                labelText: 'Target Muscles',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a target muscle';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              /// TextField untuk deskripsi gerakan
              CustomTextField(
                controller: _movementsController,
                labelText: 'Movement Description',
                hintText: 'Describe the movement...',
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the movements';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              /// TextField untuk URL gambar
              CustomTextField(
                controller: _imageUrlController,
                labelText: 'Image URL',
                hintText: 'Enter workout image URL',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              /// Tombol untuk menambahkan latihan
              CustomButton(
                text: 'Add Workout',
                onPressed: _submitWorkout,
                backgroundColor: AppColors.accentGreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
