

bool checkConstainsString(String path,List<String> strs)   {
  return strs.where((element) =>   path.toLowerCase().contains(element.toLowerCase())).isNotEmpty;
}