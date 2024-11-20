import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:myapp/app/modules/home/controllers/home_controller.dart';
import 'package:myapp/app/modules/home/views/video_player_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Kuis Multimedia"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bagian Video
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Video Kuis",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Obx(() {
              if (controller.videoUrls.isEmpty) {
                return Text("Tidak ada video yang tersedia");
              }
              return Column(
                children: controller.videoUrls.map((video) {
                  return Card(
                    child: ListTile(
                      title: Text(video['title']!),
                      subtitle: Text(video['description']!),
                      onTap: () {
                        Get.to(() => VideoPlayerScreen(
                          videoUrl: video['url']!,
                          videoPath: '', // Placeholder, jika ingin video dari perangkat
                        ));
                      },
                    ),
                  );
                }).toList(),
              );
            }),

            SizedBox(height: 20),

            // Bagian Foto
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Foto Kuis",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Obx(() {
              if (controller.photoUrls.isEmpty) {
                return Text("Tidak ada foto yang tersedia");
              }
              return Column(
                children: controller.photoUrls.map((photo) {
                  return Card(
                    child: ListTile(
                      title: Text(photo['title']!),
                      subtitle: Text(photo['description']!),
                      onTap: () {
                        Get.to(() => Image.network(photo['url']!));
                      },
                    ),
                  );
                }).toList(),
              );
            }),

            SizedBox(height: 20),

            // Ambil Foto Button
            ElevatedButton(
              onPressed: () async {
                // Memastikan izin diberikan sebelum mengambil foto
                await _requestPermissions();
                controller.pickImage();
              },
              child: Text("Ambil Foto"),
            ),

            // Menampilkan foto yang diambil
            Obx(() {
              if (controller.selectedImage.value != null) {
                return Image.file(
                  File(controller.selectedImage.value!),
                  height: 200,
                  width: 200,
                );
              } else {
                return Text("Belum ada foto diambil.");
              }
            }),

            SizedBox(height: 20),

            // Tombol perekaman video
            ElevatedButton(
              onPressed: () async {
                // Memastikan izin diberikan sebelum memulai perekaman video
                await _requestPermissions();
                if (controller.isRecording.value) {
                  controller.stopRecording();
                } else {
                  controller.startRecording();
                }
              },
              child: Text(controller.isRecording.value ? "Hentikan Perekaman" : "Mulai Perekaman"),
            ),

            // Menampilkan status video yang direkam
            Obx(() {
              if (controller.selectedVideo.value != null) {
                return Text("Video disimpan di: ${controller.selectedVideo.value}");
              } else {
                return Text("Belum ada video yang direkam.");
              }
            }),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk meminta izin akses kamera dan mikrofon
  Future<void> _requestPermissions() async {
    // Meminta izin kamera
    PermissionStatus cameraStatus = await Permission.camera.request();
    if (!cameraStatus.isGranted) {
      // Jika izin ditolak
      Get.snackbar('Izin Ditolak', 'Kamera dibutuhkan untuk mengambil foto dan merekam video.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Meminta izin mikrofon
    PermissionStatus micStatus = await Permission.microphone.request();
    if (!micStatus.isGranted) {
      // Jika izin mikrofon ditolak
      Get.snackbar('Izin Ditolak', 'Mikrofon dibutuhkan untuk merekam video.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
  }
}
