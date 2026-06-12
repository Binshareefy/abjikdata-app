class BannerItem {
  final int id;
  final String imageUrl;
  final String? title;
  final String? link;
  final int sortOrder;
  final bool isActive;

  BannerItem({
    required this.id,
    required this.imageUrl,
    this.title,
    this.link,
    this.sortOrder = 0,
    this.isActive = true,
  });

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(
      id: json['id'] ?? 0,
      imageUrl: json['image_url'] ?? json['image'] ?? '',
      title: json['title'],
      link: json['link'] ?? json['url'],
      sortOrder: json['sort_order'] ?? json['position'] ?? 0,
      isActive: json['is_active'] ?? json['active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'title': title,
      'link': link,
      'sort_order': sortOrder,
      'is_active': isActive,
    };
  }
}
