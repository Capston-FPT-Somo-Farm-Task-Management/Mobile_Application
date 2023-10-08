String wrapWordsWithEllipsis(String text, int maxChars) {
  if (text.length > maxChars) {
    return text.substring(0, maxChars - 3) + "...";
  } else {
    return text;
  }
}
