class ChatModel {
   String name;
   String message;
   String time;

  ChatModel({this.name, this.message, this.time});

    ChatModel.fromJson (Map<String, dynamic> json){
      name = json['mail_mittente'];
      message = json['oggetto'];
      time = json['data'];
    }

}    