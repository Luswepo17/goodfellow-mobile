import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:goodfellow/common/widgets/loaders/loaders.dart';
import 'package:goodfellow/features/authentication/models/documentModel.dart';
import 'package:goodfellow/utils/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class KycController extends GetxController {
  static KycController get instance => Get.find();
  final formKey = GlobalKey<FormState>();

  final dateOfBirth = TextEditingController();
  final nationality = TextEditingController();
  final profileImagePath = RxnString();

  final documents = <DocumentDTO>[].obs;

  final isLoading = false.obs;

  final deviceStorage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    addDocument(); // start with one document
  }

  void addDocument() {
    documents.add(DocumentDTO(documentType: "", documentNumber: ""));
  }

  void removeDocument(int index) {
    documents.removeAt(index);
  }

  Future<void> pickProfileImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      profileImagePath.value = image.path;
    }
  }

  Future<void> pickDocumentFile(int index) async {
    final picker = ImagePicker();

    final file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      documents[index].documentFilePath = file.path;
      documents.refresh();
    }
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    if (profileImagePath.value == null) {
      Get.snackbar("Error", "Please upload profile picture");
      return;
    }

    isLoading.value = true;

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${APIConstants.customerUrl}/${APIConstants.submitKyc}"),
      );
      final body = {
        "user_id": deviceStorage.read("user_id") ?? "",
        "date_of_birth": dateOfBirth.text.trim(),
        "nationality": nationality.text.trim(),
        "documents": documents
            .map(
              (d) => {
                "document_type": d.documentType,
                "document_number": d.documentNumber,
              },
            )
            .toList(),
      };

      final token = deviceStorage.read("token") ?? "";

      request.headers.addAll({"Authorization": "Bearer $token"});

      request.fields['kyc'] = json.encode(body);

      for (int i = 0; i < documents.length; i++) {
        final doc = documents[i];

        if (doc.documentFilePath != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              "documents", // 🔥 VERY IMPORTANT — NO INDEX
              doc.documentFilePath!,
            ),
          );
        }
      }
      // profile picture
      request.files.add(
        await http.MultipartFile.fromPath('image', profileImagePath.value!),
      );

      var streamedResponse = await request.send();

      final response = await http.Response.fromStream(streamedResponse);

      isLoading.value = false;

      final data = jsonDecode(response.body);

      print("REsponse: ${data}");

      if (data["status"] == "success") {
        APPLoaders.successSnackBar(
          title: "Success",
          message: "KYC Submitted successfully",
        );
      } else if (data["status"] == "failure") {
        APPLoaders.errorSnackBar(title: "Failure", message: data["error"]);
      }
    } catch (e) {
      isLoading.value = false;
      APPLoaders.errorSnackBar(title: "Failure", message: e.toString());
    }
  }
}
