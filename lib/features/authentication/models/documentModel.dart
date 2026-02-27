class DocumentDTO {
  String documentType;
  String documentNumber;
  String? imagePath;
  String? documentFilePath;

  DocumentDTO({
    required this.documentType,
    required this.documentNumber,
    this.imagePath,
  });

  Map<String, dynamic> toJson() {
    return {"document_type": documentType, "document_number": documentNumber};
  }
}
