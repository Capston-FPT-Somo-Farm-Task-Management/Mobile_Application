import 'dart:io';

import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ImageListSelectedPage extends StatefulWidget {
  final List<dynamic> urlImages;
  final List<AssetEntity> selectedAssetList;
  final int indexFocus;
  final bool viewOnly;
  const ImageListSelectedPage(
      {super.key,
      required this.selectedAssetList,
      required this.indexFocus,
      required this.urlImages,
      required this.viewOnly});
  @override
  _ImageListPageState createState() => _ImageListPageState();
}

class _ImageListPageState extends State<ImageListSelectedPage> {
  List<AssetEntity> list = [];
  List<dynamic> listUrl = [];
  ItemScrollController _scrollController = ItemScrollController();
  @override
  void initState() {
    super.initState();
    list = widget.selectedAssetList;
    listUrl = widget.urlImages;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.isAttached) {
        _scrollController.jumpTo(index: widget.indexFocus);
      }
    });
  }

  void _showFullSizeImageUrl(String imageUrl) {
    List<dynamic> imageUrls = [];

    // Sử dụng danh sách các URL truyền vào
    imageUrls.addAll(listUrl);

    // Xác định vị trí của ảnh hiện tại trong danh sách
    int initialIndex = imageUrls.indexOf(imageUrl);

    // Mở trang xem kích thước đầy đủ với khả năng lướt qua các ảnh
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => buildPhotoViewGalleryUrl(imageUrls, initialIndex),
      ),
    );
  }

  Widget buildPhotoViewGalleryUrl(List<dynamic> imagePaths, int initialIndex) {
    PageController _photoPageController =
        PageController(initialPage: initialIndex);

    return Scaffold(
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          Navigator.pop(context);
        },
        child: PhotoViewGallery.builder(
          itemCount: imagePaths.length,
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(
                  imagePaths[index]), // Sử dụng NetworkImage cho URL
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 2,
            );
          },
          scrollPhysics: ClampingScrollPhysics(),
          backgroundDecoration: BoxDecoration(
            color: Colors.black,
          ),
          pageController: _photoPageController,
        ),
      ),
    );
  }

  void _showFullSizeImage(AssetEntity assetEntity) async {
    List<File> files = [];

    // Lấy danh sách các file từ danh sách asset
    for (AssetEntity asset in widget.selectedAssetList) {
      File? file = await asset.file;
      if (file != null) {
        files.add(file);
      }
    }

    // Xác định vị trí của ảnh hiện tại trong danh sách
    int initialIndex = widget.selectedAssetList.indexOf(assetEntity);

    // Mở trang xem kích thước đầy đủ với khả năng lướt qua các ảnh
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => buildPhotoViewGallery(
            files.map((file) => file.path).toList(), initialIndex),
      ),
    );
  }

  Widget buildPhotoViewGallery(List<String> imagePaths, int initialIndex) {
    PageController _photoPageController =
        PageController(initialPage: initialIndex);

    return Scaffold(
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          Navigator.pop(context);
        },
        child: PhotoViewGallery.builder(
          itemCount: imagePaths.length,
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: FileImage(File(imagePaths[index])),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 2,
            );
          },
          scrollPhysics: ClampingScrollPhysics(),
          backgroundDecoration: BoxDecoration(
            color: Colors.black,
          ),
          pageController: _photoPageController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            onTap: () {
              var data = {"assets": list, "urls": listUrl};
              Navigator.pop(context, data);
            },
            child: const Center(
              child: Padding(
                padding: EdgeInsets.only(
                  right: 15,
                ),
                child: Text(
                  "Xong",
                  style: TextStyle(
                    color: kPrimaryColor, // Thay thế bằng màu chính của bạn
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ScrollablePositionedList.builder(
        itemScrollController: _scrollController,
        itemCount: list.length + listUrl.length,
        itemBuilder: (context, index) {
          if (index < listUrl.length) {
            // Xây dựng item từ danh sách thứ nhất
            return buildImageUrlItem(listUrl[index], index);
          } else {
            // Xây dựng item từ danh sách thứ hai
            int adjustedIndex = index - listUrl.length;
            return buildImageItem(list[adjustedIndex], adjustedIndex);
          }
        },
      ),
    );
  }

  Widget buildImageItem(AssetEntity asset, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Stack(
        children: [
          // Hiển thị hình ảnh
          GestureDetector(
            onTap: () {
              _showFullSizeImage(asset);
            },
            child: AssetEntityImage(
              asset,
              isOriginal: false,
              thumbnailSize: const ThumbnailSize.square(1000),
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
          // Biểu tượng gỡ bỏ
          widget.viewOnly
              ? Container()
              : Positioned(
                  top: 10,
                  right: 10,
                  child: Tooltip(
                    message: "Xóa ảnh khỏi danh sách chọn",
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Colors.black38,
                      child: GestureDetector(
                        onTap: () {
                          deleteImageAndUpdateUI(index);
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget buildImageUrlItem(String imageUrl, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Stack(
        children: [
          // Hiển thị hình ảnh
          GestureDetector(
            onTap: () {
              _showFullSizeImageUrl(imageUrl);
            },
            child: Image.network(
              imageUrl,
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
          // Biểu tượng gỡ bỏ
          widget.viewOnly
              ? Container()
              : Positioned(
                  top: 10,
                  right: 10,
                  child: Tooltip(
                    message: "Xóa ảnh khỏi danh sách chọn",
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Colors.black38,
                      child: GestureDetector(
                        onTap: () {
                          deleteImageUrlAndUpdateUI(index);
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void deleteImageAndUpdateUI(int index) {
    setState(() {
      list.removeAt(index);
    });
  }

  void deleteImageUrlAndUpdateUI(int index) {
    setState(() {
      listUrl.removeAt(index);
    });
  }
}
