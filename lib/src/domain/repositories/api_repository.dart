import '../../utils/resources/data_state.dart';
import '../models/requests/mock_request.dart';
import '../models/responses/mock_response.dart';

abstract class ApiRepository {
  Future<DataState<BreakingNewsResponse>> getBreakingNewsArticles({
    required BreakingNewsRequest request,
  });
}
