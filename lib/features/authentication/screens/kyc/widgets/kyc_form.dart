import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goodfellow/features/authentication/controllers/kyc/kyc_controller.dart';
import 'package:goodfellow/utils/constants/colors.dart';
import 'package:goodfellow/utils/constants/sizes.dart';
import 'package:goodfellow/utils/helpers/helper_functions.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class KycForm extends StatelessWidget {
  const KycForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(KycController());
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          Obx(() {
            final controller = KycController.instance;

            return Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: controller.profileImagePath.value != null
                      ? FileImage(File(controller.profileImagePath.value!))
                      : null,
                  child: controller.profileImagePath.value == null
                      ? Icon(Icons.person, size: 50)
                      : null,
                ),

                TextButton(
                  onPressed: controller.pickProfileImage,
                  child: Text("Upload Profile Picture"),
                ),
              ],
            );
          }),
          SizedBox(height: APPSizes.spaceBtwInputFields),
          TextFormField(
            controller: controller.dateOfBirth,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Date of Birth",
              suffixIcon: Icon(Icons.calendar_today),
            ),
            validator: (v) => v == null || v.isEmpty ? "Required" : null,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime(2000),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );

              if (pickedDate != null) {
                controller.dateOfBirth.text = DateFormat(
                  'yyyy-MM-dd',
                ).format(pickedDate);
              }
            },
          ),

          SizedBox(height: APPSizes.spaceBtwInputFields),

          TextFormField(
            controller: controller.nationality,
            decoration: InputDecoration(labelText: "Nationality"),
            validator: (v) => v == null || v.isEmpty ? "Required" : null,
          ),

          SizedBox(height: APPSizes.spaceBtwInputFields),

          Obx(
            () => Column(
              children: List.generate(
                controller.documents.length,
                (index) => _documentCard(index),
              ),
            ),
          ),

          SizedBox(height: APPSizes.spaceBtwInputFields),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: controller.addDocument,
              child: Text("Add Another Document"),
            ),
          ),

          const SizedBox(height: APPSizes.spaceBtwInputFields),

          Obx(
            () => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(15),
                  ),
                  backgroundColor: APPColors.primary,
                  disabledBackgroundColor: APPColors.primary,
                ),
                onPressed: controller.isLoading.value
                    ? null
                    : controller.submit,
                child: controller.isLoading.value
                    ? LoadingAnimationWidget.threeArchedCircle(
                        color: APPColors.white,
                        size: 30,
                      )
                    : Text("Submit"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _documentCard(int index) {
    final controller = KycController.instance;
    final doc = controller.documents[index];

    return Card(
      color: APPHelperFunctions.isDarkMode(Get.context!)
          ? APPColors.darkContainer
          : APPColors.lightContainer,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            /// Document Type
            DropdownButtonFormField<String>(
              value: doc.documentType.isEmpty ? null : doc.documentType,
              items: ["nrc", "passport", "drivers_license"]
                  .map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(type.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                doc.documentType = value!;
              },
              decoration: InputDecoration(labelText: "Document Type"),
            ),

            SizedBox(height: APPSizes.spaceBtwInputFields),

            /// Document Number
            TextFormField(
              decoration: InputDecoration(labelText: "Document Number"),
              onChanged: (value) {
                doc.documentNumber = value;
              },
            ),

            SizedBox(height: APPSizes.spaceBtwInputFields),

            /// Document Upload Button
            Row(
              children: [
                Expanded(
                  child: Text(
                    doc.documentFilePath == null
                        ? "No document selected"
                        : "Document Selected",
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                TextButton.icon(
                  onPressed: () => controller.pickDocumentFile(index),
                  icon: Icon(Icons.upload_file),
                  label: Text("Upload"),
                ),
              ],
            ),

            if (controller.documents.length > 1)
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => controller.removeDocument(index),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
