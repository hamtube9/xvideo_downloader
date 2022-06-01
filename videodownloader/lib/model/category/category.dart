class Category {
   String? name;
   bool isSelected;

  Category({this.name, this.isSelected = false});
}

final categories = [
  Category(name: 'Social Media'),
  Category(name: 'Entertainment'),
  Category(name: 'Short Videos'),
  Category(name: 'News'),
  Category(name: 'Sports'),
  Category(name: 'Adult'),
  Category(name: 'Funny'),
  Category(name: 'Movies'),
  Category(name: 'Knowledge'),
  Category(name: 'History'),
  Category(name: 'Study'),
  Category(name: 'Politicians'),
];


final categoriesLanguage = [
  Category(name: 'English'),
  Category(name: 'हिन्दी'),
  Category(name: '日本'),
  Category(name: 'Vietnamese'),
];
