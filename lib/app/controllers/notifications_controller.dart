import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p; // ➊ nuevo

class NotificationsController extends GetxController {
  // ---------------- observables -----------------
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxString reason = ''.obs;
  final RxBool isLoading = false.obs;

  // Para comunicado
  final Rx<TextEditingController> titleController = TextEditingController().obs;
  final Rx<TextEditingController> contentController =
      TextEditingController().obs;
  final RxBool isSendingAnnouncement = false.obs;

  final ImagePicker _picker = ImagePicker();

  // ---------------- helpers ---------------------

  /// Selecciona una imagen de galería y la asigna a [selectedImage].
  Future<void> pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) selectedImage.value = File(picked.path);
  }

  void setReason(String value) => reason.value = value.trim();

  // ---------------- carga principal --------------

  Future<void> sendAnnouncement(BuildContext context) async {
    final title = titleController.value.text.trim();
    final content = contentController.value.text.trim();
    if (title.isEmpty || content.isEmpty) {
      _snack(context, 'Please complete both fields.');
      return;
    }
    isSendingAnnouncement.value = true;
    try {
      await FirebaseFirestore.instance.collection('announcements').add({
        'title': title,
        'content': content,
        'createdAt': FieldValue.serverTimestamp(),
      });
      _snack(context, 'Announcement sent successfully ✅', isError: false);
      titleController.value.clear();
      contentController.value.clear();
    } on FirebaseException catch (e) {
      _snack(context, 'Firebase error: ${e.code} – ${e.message}');
    } catch (e) {
      _snack(context, 'Unexpected error: $e');
    } finally {
      isSendingAnnouncement.value = false;
    }
  }

  Future<void> uploadCarouselImage(BuildContext context) async {
    if (selectedImage.value == null || reason.value.isEmpty) {
      _snack(context, 'Select an image and write a reason.');
      return;
    }

    isLoading.value = true;
    try {
      // ---------- 1. Construir nombre seguro ----------
      final ext = p.extension(selectedImage.value!.path); // .jpg / .png
      final fileName = 'notif_${DateTime.now().millisecondsSinceEpoch}${ext}';
      // ➋ evita espacios y acentos
      final safeName = Uri.encodeComponent(fileName);

      // ---------- 2. Subir la imagen ----------
      final ref = FirebaseStorage.instance
          .ref()
          .child('carousel_image') // carpeta SINGULAR + sin “/” inicial
          .child(safeName);

      // content-type ayuda a Storage a servir la imagen correctamente
      final metadata = SettableMetadata(contentType: _contentType(ext));

      await ref.putFile(selectedImage.value!, metadata);
      final url = await ref.getDownloadURL();
      print('url: $url');

      // ---------- 3. Guardar documento en Firestore ----------
      await FirebaseFirestore.instance.collection('carousel_image').add({
        'tipo': reason.value,
        'url': url,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _snack(context, 'Imagen subida correctamente ✅', isError: false);

      // ---------- 4. Reset ----------
      selectedImage.value = null;
      reason.value = '';
    } on FirebaseException catch (e) {
      _snack(context, 'Error Firebase: ${e.code} – ${e.message}');
    } catch (e) {
      _snack(context, 'Error inesperado: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------- utilidades -------------------

  String _contentType(String ext) =>
      ext.toLowerCase() == '.png' ? 'image/png' : 'image/jpeg';

  void _snack(BuildContext ctx, String msg, {bool isError = true}) =>
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
            content: Text(msg), backgroundColor: isError ? Colors.red : null),
      );
}
