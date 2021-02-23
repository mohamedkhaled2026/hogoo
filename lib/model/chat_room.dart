class ChatRoom{
  String roomId;
  String roomName;
  String roomCat;
  String roomType;
  String roomOwnerId;
  int onlineUserCount;

  ChatRoom({this.roomId,this.roomName,this.roomCat,this.roomType,this.roomOwnerId,this.onlineUserCount});

  factory ChatRoom.fromDocument(Map m){
    return ChatRoom(
      roomId: m['room_id'],
      roomName: m['room_name'],
      roomCat: m['room_cat'],
      roomType: m['room_type'],
      roomOwnerId: m['room_owner_id'],
    );
  }
  dynamic toMap(){
    return {
      'room_id' : this.roomId,
      'room_name' : this.roomName,
      'room_cat' : this.roomCat,
      'room_type' : this.roomType,
      'room_owner_id' : this.roomOwnerId,
    };
  }


}