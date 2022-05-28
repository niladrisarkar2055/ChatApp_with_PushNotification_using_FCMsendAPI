//FCM message model class
class FcmMessage {
  final String token;
  final String title;
  final String body;

  const FcmMessage({required this.token, required this.title, required this.body});//COnstructor 


  //fromJson method 
  factory FcmMessage.fromJson(Map<String, dynamic> json) {
    return FcmMessage(
      token: json['token'],
      title: json['title'],
      body: json['body']

    );
  }
}