import '../models/user.dart';

class Message {
  final User sender;
  final String time;
  final String text;
  final bool isLiked;
  final bool unread;

  Message({
    this.sender,
    this.time,
    this.text,
    this.isLiked,
    this.unread,
  });
}

// YOU - current user
final User currentUser = User(
  id: 0,
  name: 'G.A.M. Srl',
  imageUrl: 'assets/images/greg.jpg',
);

// USERS
final User greg = User(
  id: 1,
  name: 'Greg',
  imageUrl: 'assets/images/greg.jpg',
);
final User deterchimica = User(
  id: 10,
  name: 'Deterchimica',
  imageUrl: 'assets/images/greg.jpg',
);

// FAVORITE CONTACTS
List<User> favorites = [greg, deterchimica];

// EXAMPLE CHATS ON HOME SCREEN
/*
List<Message> chats = [
  Message(
    sender: greg,
    time: '11:30 AM',
    text: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: false,
  ),
];*/

// EXAMPLE MESSAGES IN CHAT SCREEN
List<Message> messages = [
  Message(
    sender: deterchimica,
    time: '2:30 PM',
    text: ', Scrivi il tuo ticket nella barra in fondo.',
    isLiked: true,
    unread: false,
  ),
  Message(
    sender: deterchimica,
    time: '2:30 PM',
    text: 'Il tuo ticket verrà risolto il prima possibile',
    isLiked: false,
    unread: true,
  ),
];
