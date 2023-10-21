import 'package:photo_manager/photo_manager.dart';

class MediaServices {
  Future loadAlbums(RequestType requestType) async {
    try {
      var permission = await PhotoManager.requestPermissionExtend();
      List<AssetPathEntity> albumList = [];

      if (permission.isAuth == true) {
        albumList = await PhotoManager.getAssetPathList(
          type: requestType,
        );
      } else {
        PhotoManager.openSetting();
      }

      return albumList;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future loadAssets(AssetPathEntity selectedAlbum) async {
    try {
      List<AssetEntity> assetList = await selectedAlbum.getAssetListRange(
        start: 0,
        // ignore: deprecated_member_use
        end: selectedAlbum.assetCount,
      );
      return assetList;
    } catch (e) {
      throw Exception(e);
    }
  }
}
