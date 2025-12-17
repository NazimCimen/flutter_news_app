/// IMAGE ENUMS IS USED TO MANAGE IMAGES FROM ASSETS
enum ImageEnums { flag_turkiye, flag_usa }

extension AssetExtension on ImageEnums {
  String get toPathPng => 'assets/images/$name.png';
}
