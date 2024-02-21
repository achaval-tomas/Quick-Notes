import 'package:intl/intl.dart' show DateFormat;

String getContent(String? note){
  if (note != null) {
    if (note.length >= 38){
      final text = note.substring(38, note.length);
      return text;
    }
  }
  return '';
}

String updateDate(){
  return DateFormat('yyyy/MM/dd kk:mm:ss').format(DateTime.now());
}

String getLastAccessDate(String? note){
  if (note != null) {
    if (note.length >= 38){
      final text = note.substring(19, 38);
      return text;
    }
  }
  return DateFormat('yyyy/MM/dd kk:mm:ss').format(DateTime.now());
}

String getCreationDate(String? note){
   if (note != null) {
    if (note.length >= 19){
      final text = note.substring(0, 19);
      return text;
    }
  }
  return DateFormat('yyyy/MM/dd kk:mm:ss').format(DateTime.now());
}