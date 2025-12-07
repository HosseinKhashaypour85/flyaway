String formatNumber(int number){
  String numStr = number.toString();
  String result = '';
  int count = 0;

  for(int i = numStr.length -1; i>=0; i--){
    result = numStr[i] + result;
    count++;
    if (count % 3 == 0 && i != 0) {
      result = ',' + result;
    }
  }
  return result + 'تومان';
}