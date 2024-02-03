import 'package:intl/intl.dart' show DateFormat;

const dateRegEx = '!!!!!';

String getContent(String? note){
  if (note != null) {
    if (note.length >= 32){
      final text = note.substring(32, note.length);
      return text;
    }
  }
  return '';
}

String updateDate(){
  return DateFormat('yyyy/MM/dd kk:mm').format(DateTime.now());
}

String getLastAccessDate(String? note){
  if (note != null) {
    if (note.length >= 32){
      final text = note.substring(16, 32);
      return text;
    }
  }
  return DateFormat('yyyy/MM/dd kk:mm').format(DateTime.now());
}

String getCreationDate(String? note){
   if (note != null) {
    if (note.length >= 16){
      final text = note.substring(0, 16);
      return text;
    }
  }
  return DateFormat('yyyy/MM/dd kk:mm').format(DateTime.now());
}