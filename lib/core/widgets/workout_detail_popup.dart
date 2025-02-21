import 'package:flutter/material.dart';
import 'package:jim/core/constants/app_colors.dart';
import 'package:jim/core/constants/app_styles.dart';
import 'package:jim/core/constants/app_sizes.dart';

/// Widget yang menampilkan detail latihan dalam bentuk popup dialog.
///
/// Widget ini menerima data latihan dalam bentuk Map dan menampilkannya
/// dengan format yang terstruktur termasuk gambar (jika ada), nama latihan,
/// otot target, deskripsi, dan instruksi.
class WorkoutDetailPopup extends StatelessWidget {
  /// Data latihan yang akan ditampilkan.
  ///
  /// Map harus berisi setidaknya beberapa dari keys berikut:
  /// - 'image': URL gambar latihan (opsional)
  /// - 'name': Nama latihan
  /// - 'target_muscles': Otot yang ditarget
  /// - 'movements': Deskripsi gerakan
  /// - 'instructions': List instruksi detail (opsional)
  final Map<String, dynamic> workoutData;

  const WorkoutDetailPopup({super.key, required this.workoutData});

  /// Menampilkan gambar dalam ukuran penuh dengan kemampuan zoom.
  ///
  /// Method ini dipanggil ketika pengguna mengetuk gambar latihan.
  /// Menampilkan gambar dalam dialog yang dapat di-zoom dan di-pan.
  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            fit: StackFit.loose,
            children: [
              InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColors.secondaryDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bagian Gambar Latihan (jika tersedia)
          if (workoutData['image'] != null)
            GestureDetector(
              onTap: () => _showFullImage(context, workoutData['image']),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      workoutData['image'],
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.zoom_in,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Bagian Konten Detail Latihan
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.spaceMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama Latihan
                    Text(
                      workoutData['name'] ?? 'Unknown workout',
                      style: AppStyles.heading2,
                    ),

                    // Otot Target
                    const SizedBox(height: AppSizes.spaceSmall),
                    Text(
                      'Target Muscles: ${workoutData['target_muscles'] ?? 'Not specified'}',
                      style: AppStyles.body1,
                    ),

                    // Deskripsi Gerakan
                    const SizedBox(height: AppSizes.spaceSmall),
                    Text(
                      'Description:',
                      style:
                          AppStyles.body1.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      workoutData['movements'] ?? 'No description available',
                      style: AppStyles.body2,
                    ),

                    // Instruksi Detail (jika tersedia)
                    if (workoutData['instructions'] != null) ...[
                      const SizedBox(height: AppSizes.spaceSmall),
                      Text(
                        'Instructions:',
                        style: AppStyles.body1
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      ...List<String>.from(workoutData['instructions']).map(
                        (instruction) => Padding(
                          padding:
                              const EdgeInsets.only(left: AppSizes.spaceSmall),
                          child: Text(
                            '• $instruction',
                            style: AppStyles.body2,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // Tombol Tutup
          Padding(
            padding: const EdgeInsets.all(AppSizes.spaceMedium),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
