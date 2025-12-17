import 'package:dartz/dartz.dart';
import 'package:flutter_news_app/config/localization/string_constants.dart';
import 'package:flutter_news_app/core/error/failure.dart';
import 'package:flutter_news_app/core/connection/network_info.dart';
import 'package:flutter_news_app/data/data_source/remote/sources_service.dart';
import 'package:flutter_news_app/data/model/source_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sourcesRepositoryProvider = Provider<SourcesRepository>((ref) {
  return SourcesRepositoryImpl(
    sourcesService: ref.read(sourcesServiceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

abstract class SourcesRepository {
  /// FETCH ALL AVAILABLE NEWS SOURCES
  Future<Either<Failure, List<SourceModel>>> fetchSources();
  
  /// FETCH USER'S FOLLOWED NEWS SOURCES
  Future<Either<Failure, List<SourceModel>>> fetchFollowedSources();
  
  /// UPDATE MULTIPLE SOURCE FOLLOW STATUSES AT ONCE
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
  Future<Either<Failure, List<SourceModel>>> fetchFollowedSources() async {
    if (!await _networkInfo.currentConnectivityResult) {
      return Left(
        ConnectionFailure(errorMessage: StringConstants.noInternetConnection),
      );
    }
    return _sourcesService.fetchFollowedSources();
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
