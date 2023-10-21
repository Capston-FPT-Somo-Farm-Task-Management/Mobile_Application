import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/services/media_service.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaPicker extends StatefulWidget {
  final int maxCount;
  final RequestType requestType;
  final List<AssetEntity> selectedAssetList;
  const MediaPicker(this.maxCount, this.requestType, this.selectedAssetList,
      {super.key});

  @override
  State<MediaPicker> createState() => _MediaPickerState();
}

class _MediaPickerState extends State<MediaPicker> {
  AssetPathEntity? selectedAlbum;
  List<AssetPathEntity> albumList = [];
  List<AssetEntity> assetList = [];
  List<AssetEntity> selectedAssetList = [];
  bool isLoading = true;
  @override
  void initState() {
    setState(() {
      selectedAssetList = widget.selectedAssetList;
    });
    MediaServices().loadAlbums(widget.requestType).then(
      (value) {
        setState(() {
          albumList = value;
          isLoading = false;
          if (value.isNotEmpty) {
            selectedAlbum = value[0];
            setState(() {
              isLoading = true;
            });
          }
        });
        //LOAD RECENT ASSETS
        if (value.isNotEmpty)
          MediaServices().loadAssets(selectedAlbum!).then(
            (value) {
              setState(() {
                assetList = value;
                isLoading = false;
              });
            },
          );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: DropdownButton<AssetPathEntity>(
            value: selectedAlbum,
            onChanged: (AssetPathEntity? value) {
              setState(() {
                selectedAlbum = value;
              });
              MediaServices().loadAssets(selectedAlbum!).then(
                (value) {
                  setState(() {
                    assetList = value;
                  });
                },
              );
            },
            items: albumList.map<DropdownMenuItem<AssetPathEntity>>(
                (AssetPathEntity album) {
              return DropdownMenuItem<AssetPathEntity>(
                value: album,
                // ignore: deprecated_member_use
                child: Text("${album.name} (${album.assetCount})"),
              );
            }).toList(),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context, selectedAssetList);
              },
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 15,
                  ),
                  child: Text(
                    "Xong",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(color: kPrimaryColor),
              )
            : assetList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported_rounded,
                          size: 75, // Kích thước biểu tượng có thể điều chỉnh
                          color: Colors.grey, // Màu của biểu tượng
                        ),
                        SizedBox(
                            height:
                                16), // Khoảng cách giữa biểu tượng và văn bản
                        Text(
                          "Không có ảnh nào",
                          style: TextStyle(
                            fontSize:
                                20, // Kích thước văn bản có thể điều chỉnh
                            color: Colors.grey, // Màu văn bản
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: assetList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (context, index) {
                      AssetEntity assetEntity = assetList[index];
                      return assetWidget(assetEntity);
                    },
                  ),
      ),
    );
  }

  Widget assetWidget(AssetEntity assetEntity) => GestureDetector(
        onTap: () {
          selectAsset(assetEntity: assetEntity);
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.all(
                  selectedAssetList.contains(assetEntity) == true ? 5 : 0,
                ),
                child: AssetEntityImage(
                  assetEntity,
                  isOriginal: false,
                  thumbnailSize: const ThumbnailSize.square(250),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedAssetList.contains(assetEntity) == true
                          ? Colors.blue
                          : Colors.black12,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 1.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "${selectedAssetList.indexOf(assetEntity) + 1}",
                        style: TextStyle(
                          color: selectedAssetList.contains(assetEntity) == true
                              ? Colors.white
                              : Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  void selectAsset({
    required AssetEntity assetEntity,
  }) {
    if (selectedAssetList.contains(assetEntity)) {
      setState(() {
        selectedAssetList.remove(assetEntity);
      });
    } else if (selectedAssetList.length < widget.maxCount) {
      setState(() {
        selectedAssetList.add(assetEntity);
      });
    }
  }
}
