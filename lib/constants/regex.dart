import 'package:intl/intl.dart' show DateFormat;

const dateRegEx = '!!!!!';

String getContent(String? note){
  if (note != null){
    final text = note.split(dateRegEx);
    if (text.length < 2) return text[0];
    return text[1];
  }
  return '';
}

String getDate(String? note){
   if (note != null){
    final text = note.split(dateRegEx);
    if (text.length > 1) return text[0];
  }
  return DateFormat('yyyy/MM/dd kk:mm$dateRegEx').format(DateTime.now());
}