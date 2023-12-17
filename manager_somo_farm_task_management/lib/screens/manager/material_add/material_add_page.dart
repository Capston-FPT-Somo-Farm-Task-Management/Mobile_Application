import 'dart:io';

import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/shared/evidence_add/components/imange_list_selected.dart';
import 'package:manager_somo_farm_task_management/screens/shared/evidence_add/components/media_picker.dart';
import 'package:manager_somo_farm_task_management/services/material_service.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../componets/input_field.dart';

class CreateMaterial extends StatefulWidget {
  final int farmId;
  const CreateMaterial({super.key, required this.farmId});

  @override
  CreateMaterialState createState() => CreateMaterialState();
}

class CreateMaterialState extends State<CreateMaterial> {
  final TextEditingController _nameController = TextEditingController();
  File? selectedFiles;
  List<AssetEntity> selectedAssetList = [];
  bool isLoading = false;
  Future<bool> createMaterial(String name, File? image) {
    return MaterialService().createMaterial(widget.farmId, name, image);
  }

  Future pickAssets({
    required int maxCount,
    required RequestType requestType,
  }) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MediaPicker(maxCount, requestType, selectedAssetList);
        },
      ),
    );
    setState(() {
      if (result != null) selectedAssetList = result;
    });
  }

  Future convertAssetsToFiles(List<AssetEntity> assetEntities) async {
    for (var i = 0; i < assetEntities.length; i++) {
      final File? file = await assetEntities[i].originFile;
      setState(() {
        selectedFiles = file!;
      });
    }
  }

  Widget buildAssetWidget(AssetEntity assetEntity) {
    int indexInSelectedList = selectedAssetList.indexOf(assetEntity);
    return GestureDetector(
      onTap: () async {
        //_showFullSizeImage(assetEntity);
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ImageListSelectedPage(
                selectedAssetList: selectedAssetList,
                indexFocus: indexInSelectedList),
          ),
        );
        setState(() {
          if (result != null) selectedAssetList = result;
        });
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: AssetEntityImage(
              assetEntity,
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
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kBackgroundColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: kSecondColor,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Thêm công cụ",
                      style: headingStyle,
                    ),
                    MyInputField(
                      maxLength: 100,
                      title: "Tên công cụ",
                      hint: "Nhập tên công cụ",
                      controller: _nameController,
                    ),
                    GestureDetector(
                      onTap: () {
                        pickAssets(
                          maxCount: 1,
                          requestType: RequestType.image,
                        );
                        setState(() {});
                      },
                      child: MyInputField(
                        title: "Chọn ảnh",
                        hint: "Tải ảnh lên",
                        widget: Icon(Icons.add_photo_alternate, size: 30),
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (selectedAssetList.length == 1)
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: buildAssetWidget(selectedAssetList[0]),
                      ),
                    const SizedBox(height: 30),
                    Align(
                      child: ElevatedButton(
                        onPressed: () {
                          _validateDate();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          minimumSize: Size(100, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Tạo công cụ",
                            style: TextStyle(fontSize: 19),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  _validateDate() {
    setState(() {
      isLoading = true;
    });
    if (_nameController.text.isNotEmpty) {
      if (selectedAssetList.isNotEmpty)
        convertAssetsToFiles(selectedAssetList).then((value) {
          createMaterial(_nameController.text.trim(), selectedFiles!)
              .then((value) {
            if (value) {
              setState(() {
                isLoading = false;
              });
              Navigator.pop(context, "ok");
            }
          }).catchError((e) {
            setState(() {
              isLoading = false;
            });
            SnackbarShowNoti.showSnackbar(e.toString(), true);
          });
        });
      else
        createMaterial(_nameController.text.trim(), selectedFiles)
            .then((value) {
          if (value) {
            setState(() {
              isLoading = false;
            });
            Navigator.pop(context, "ok");
          }
        }).catchError((e) {
          setState(() {
            isLoading = false;
          });
          SnackbarShowNoti.showSnackbar(e.toString(), true);
        });
    } else {
      setState(() {
        isLoading = false;
      });
      SnackbarShowNoti.showSnackbar('Vui lòng điền đầy đủ thông tin!', true);
    }
  }
}
