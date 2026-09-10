/// A single page of results returned by a paginated API endpoint.
///
/// The backend shape is:
/// ```json
/// { "items": [...], "page": 1, "page_size": 30, "total": 85, "total_pages": 3 }
/// ```
class PagedResult<T> {
  const PagedResult({
    required this.items,
    required this.page,
    required this.totalPages,
    required this.total,
  });

  final List<T> items;
  final int page;
  final int totalPages;
  final int total;

  /// True when there is at least one more page to fetch.
  bool get hasMore => page < totalPages;

  factory PagedResult.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromItem,
  ) {
    return PagedResult(
      items: (json['items'] as List)
          .map((e) => fromItem(e as Map<String, dynamic>))
          .toList(),
      page: json['page'] as int,
      totalPages: json['total_pages'] as int,
      total: json['total'] as int,
    );
  }
}
