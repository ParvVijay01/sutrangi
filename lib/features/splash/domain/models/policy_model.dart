import 'dart:convert';

PolicyModel policyModelFromJson(String str) =>
    PolicyModel.fromJson(json.decode(str));

String policyModelToJson(PolicyModel data) => json.encode(data.toJson());

class PolicyModel {
  PolicyModel({
    this.returnPage,
    this.refundPage,
    this.cancellationPage,
  });

  Pages? returnPage;
  Pages? refundPage;
  Pages? cancellationPage;

  factory PolicyModel.fromJson(Map<String, dynamic> json) => PolicyModel(
        returnPage: json["return_page"] != null
            ? Pages.fromJson(json["return_page"])
            : null,
        refundPage: json["refund_page"] != null
            ? Pages.fromJson(json["refund_page"])
            : null,
        cancellationPage: json["cancellation_page"] != null
            ? Pages.fromJson(json["cancellation_page"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "return_page": returnPage?.toJson(),
        "refund_page": refundPage?.toJson(),
        "cancellation_page": cancellationPage?.toJson(),
      };
}

class Pages {
  Pages({
    this.status,
    this.content,
  });

  bool? status;
  String? content;

  factory Pages.fromJson(Map<String, dynamic> json) {
    return Pages(
      status:
          json["status"] != null ? (json["status"].toString() == "1") : false,
      content: json["content"],
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status == true ? 1 : 0, // Convert boolean back to int
        "content": content,
      };
}
