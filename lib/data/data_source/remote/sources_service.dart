import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_news_app/core/network/api_constants.dart';
import 'package:flutter_news_app/core/network/dio_interceptor.dart';
import 'package:flutter_news_app/core/network/dio_error_extension.dart';
import 'package:flutter_news_app/data/model/source_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sourcesServiceProvider = Provider<SourcesService>((ref) {
  return SourcesServiceImpl(dio: ref.read(dioProvider));
});

abstract class SourcesService {
  /// FETCH ALL AVAILABLE NEWS SOURCES
  Future<Either<Failure, List<SourceModel>>> fetchSources();

  /// FETCH USER'S FOLLOWED NEWS SOURCES
  Future<Either<Failure, List<SourceModel>>> fetchFollowedSources();

  /// UPDATE MULTIPLE SOURCE FOLLOW STATUSES AT ONCE
  Future<Either<Failure, void>> bulkFollow(List<Map<String, dynamic>> updates);
}

class SourcesServiceImpl implements SourcesService {
  final Dio _dio;

  SourcesServiceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<Either<Failure, List<SourceModel>>> fetchSources() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiConstants.currentSources,
      );

      final data = response.data;
      if (data == null ||
          data['result'] == null ||
          data['result']['sources'] == null) {
        return const Right([]);
      }

      final sources = (data['result']['sources'] as List)
          .map((e) => SourceModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return Right(sources);
    } on DioException catch (e) {
      return Left(e.toFailure());
    }
  }


  @override
  Future<Either<Failure, List<SourceModel>>> fetchFollowedSources() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiConstants.followedSources,
      );

      final data = response.data;
      if (data == null ||
          data['result'] == null ||
          data['result']['sources'] == null) {
        return const Right([]);
      }

      final sources = (data['result']['sources'] as List)
          .map((e) => SourceModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return Right(sources);
    } on DioException catch (e) {
      return Left(e.toFailure());
    }
  }
  @override
  Future<Either<Failure, void>> bulkFollow(
    List<Map<String, dynamic>> updates,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.followBulkSources,
        data: updates,
      );

      final data = response.data;
      if (data == null || data['result'] == null) {
        return const Right(null);
      }
      return const Right(null);
    } on DioException catch (e) {
      return Left(e.toFailure());
    }
  }
}
