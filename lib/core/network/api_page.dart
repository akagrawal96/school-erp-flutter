/// One page of a paginated list response.
///
/// The backend sends `pagination: {pageNo, pageSize, totalRecords, totalPages,
/// hasNextPage, hasPreviousPage}` next to `data`.
final class ApiPage {
  const ApiPage({required this.items, required this.pageNo, required this.hasNextPage});

  factory ApiPage.fromEnvelope(Object? data, Object? pagination) {
    final items = data is List ? data : const <Object?>[];
    if (pagination is! Map) {
      return ApiPage(items: items, pageNo: 1, hasNextPage: false);
    }
    return ApiPage(
      items: items,
      pageNo: int.tryParse('${pagination['pageNo']}') ?? 1,
      hasNextPage: pagination['hasNextPage'] == true,
    );
  }

  final List<Object?> items;
  final int pageNo;
  final bool hasNextPage;
}
