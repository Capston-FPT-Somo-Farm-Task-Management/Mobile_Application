String wrapWords(String input, int maxChars) {
  List<String> words = input.split(' ');
  List<String> lines = [];
  String currentLine = '';

  for (String word in words) {
    if (word.length > 11) {
      // Nếu từ có độ dài lớn hơn 10, cắt thành các phần nhỏ
      List<String> subWords = [];
      while (word.length > 10) {
        subWords.add(word.substring(0, 10));
        word = word.substring(10);
      }
      subWords.add(word);

      for (String subWord in subWords) {
        if ((currentLine + subWord).length <= maxChars) {
          currentLine += (currentLine.isNotEmpty ? ' ' : '') + subWord;
        } else {
          lines.add(currentLine);
          currentLine = subWord;
        }
      }
    } else {
      if ((currentLine + word).length <= maxChars) {
        currentLine += (currentLine.isNotEmpty ? ' ' : '') + word;
      } else {
        lines.add(currentLine);
        currentLine = word;
      }
    }
  }

  // Thêm dòng cuối cùng nếu cần
  if (currentLine.isNotEmpty) {
    lines.add(currentLine);
  }

  return lines.join('\n');
}
