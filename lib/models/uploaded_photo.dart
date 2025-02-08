class UploadedPhoto {
  final String urlDownload;
  String id = "";

  UploadedPhoto({required this.urlDownload, this.id = ""});

  factory UploadedPhoto.fromJson(Map<String, dynamic> json, String id) {
    UploadedPhoto photo = UploadedPhoto(urlDownload: json['url'], id: id);
    return photo;
  }

  toJson() {
    return {
      "url": urlDownload,
    };
  }
}
