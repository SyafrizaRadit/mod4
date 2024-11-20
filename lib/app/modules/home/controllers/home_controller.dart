import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class HomeController extends GetxController {
  final ImagePicker picker = ImagePicker();
  late CameraController cameraController;

  var selectedImage = Rxn<String?>(); // Path image yang dipilih
  var selectedVideo = Rxn<String?>(); // Path video yang direkam
  var isRecording = false.obs;
  var cameraInitialized = false.obs; // Flag untuk memeriksa apakah kamera sudah siap

  var videoUrls = [
    {
      "url": "https://www.w3schools.com/html/mov_bbb.mp4",
      "title": "Sample Video 1",
      "description": "Example video file from W3Schools."
    },
    {
      "url": "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
      "title": "Sample Video 2",
      "description": "Example video with animation."
    }
  ].obs;

  var photoUrls = [
    {
      "url": "https://www.w3schools.com/w3images/fjords.jpg",
      "title": "Fjords Image",
      "description": "Example scenic image of fjords from W3Schools."
    },
    {
      "url": "https://www.sample-videos.com/img/Sample-jpg-image-500kb.jpg",
      "title": "Sample Image",
      "description": "Sample 500 KB image from Sample Videos website."
    }
  ].obs;

  @override
  void onInit() {
    super.onInit();
    initializeCamera();
  }

  // Menginisialisasi kamera dengan lebih aman
  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        print("No cameras available");
        return;
      }
      final firstCamera = cameras.first;
      cameraController = CameraController(
        firstCamera,
        ResolutionPreset.high,
      );

      await cameraController.initialize().then((_) {
        cameraInitialized.value = true; // Menandakan kamera siap digunakan
        update();
      }).catchError((e) {
        print("Error initializing camera: $e");
        cameraInitialized.value = false; // Menandakan kamera gagal diinisialisasi
        update();
      });
    } catch (e) {
      print("Error initializing camera: $e");
      cameraInitialized.value = false; // Menangani kesalahan lainnya
    }
  }

  // Fungsi untuk mengambil foto
  Future<void> pickImage() async {
    if (!cameraInitialized.value) {
      print("Camera not initialized");
      return;
    }

    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      selectedImage.value = image.path;
    }
  }

  // Mulai merekam video
  Future<void> startRecording() async {
    if (!cameraInitialized.value) {
      print("Camera not initialized");
      return;
    }

    final directory = await getApplicationDocumentsDirectory();
    final videoFile = File('${directory.path}/video_${DateTime.now().millisecondsSinceEpoch}.mp4');

    try {
      await cameraController.startVideoRecording();
      isRecording.value = true;
      selectedVideo.value = videoFile.path;
    } catch (e) {
      print("Error starting video recording: $e");
      isRecording.value = false;
    }
  }

  // Hentikan perekaman video
  Future<void> stopRecording() async {
    if (!cameraInitialized.value) {
      print("Camera not initialized");
      return;
    }

    try {
      await cameraController.stopVideoRecording();
      isRecording.value = false;
      update();
    } catch (e) {
      print("Error stopping video recording: $e");
    }
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }
}
