import 'package:dartz/dartz.dart';
import 'package:flutter_news_app/config/localization/string_constants.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_news_app/core/network/network_info.dart';
import 'package:flutter_news_app/data/data_source/sources_service.dart';
import 'package:flutter_news_app/data/model/source_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sourcesRepositoryProvider = Provider<SourcesRepository>((ref) {
  return SourcesRepositoryImpl(
    sourcesService: ref.read(sourcesServiceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

abstract class SourcesRepository {
  Future<Either<Failure, List<SourceModel>>> fetchSources();
  Future<Either<Failure, List<SourceModel>>> searchSources(String query);
  Future<Either<Failure, List<SourceModel>>> fetchFollowedSources();
  Future<Either<Failure, void>> followSource(String sourceId);
  Future<Either<Failure, void>> unfollowSource(String sourceId);
  Future<Either<Failure, void>> bulkFollow(List<Map<String, dynamic>> updates);
}

class SourcesRepositoryImpl implements SourcesRepository {
  final SourcesService _sourcesService;
  final INetworkInfo _networkInfo;

  SourcesRepositoryImpl({
    required SourcesService sourcesService,
    required INetworkInfo networkInfo,
  }) : _sourcesService = sourcesService,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<SourceModel>>> fetchSources() async {
    if (!await _networkInfo.currentConnectivityResult) {
      return Left(
        ConnectionFailure(errorMessage: StringConstants.noInternetConnection),
      );
    }
    return _sourcesService.fetchSources();
  }

  @override
  Future<Either<Failure, List<SourceModel>>> searchSources(String query) async {
    if (!await _networkInfo.currentConnectivityResult) {
      return Left(
        ConnectionFailure(errorMessage: StringConstants.noInternetConnection),
      );
    }
    return _sourcesService.searchSources(query);
  }

  @override
  Future<Either<Failure, List<SourceModel>>> fetchFollowedSources() async {
    if (!await _networkInfo.currentConnectivityResult) {
      return Left(
        ConnectionFailure(errorMessage: StringConstants.noInternetConnection),
      );
    }
    return _sourcesService.fetchFollowedSources();
  }

  @override
  Future<Either<Failure, void>> followSource(String sourceId) async {
    if (!await _networkInfo.currentConnectivityResult) {
      return Left(
        ConnectionFailure(errorMessage: StringConstants.noInternetConnection),
      );
    }
    return _sourcesService.followSource(sourceId);
  }

  @override
  Future<Either<Failure, void>> unfollowSource(String sourceId) async {
    if (!await _networkInfo.currentConnectivityResult) {
      return Left(
        ConnectionFailure(errorMessage: StringConstants.noInternetConnection),
      );
    }
    return _sourcesService.unfollowSource(sourceId);
  }

  @override
  Future<Either<Failure, void>> bulkFollow(
    List<Map<String, dynamic>> updates,
  ) async {
    if (!await _networkInfo.currentConnectivityResult) {
      return Left(
        ConnectionFailure(errorMessage: StringConstants.noInternetConnection),
      );
    }
    return _sourcesService.bulkFollow(updates);
  }
}
