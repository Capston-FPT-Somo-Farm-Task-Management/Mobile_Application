import 'dart:io';

import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/shared/evidence_add/components/media_picker.dart';
import 'package:manager_somo_farm_task_management/services/material_service.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../componets/input_field.dart';

class UpdateMaterial extends StatefulWidget {
  final Map<String, dynamic> material;
  const UpdateMaterial({super.key, required this.material});

  @override
  UpdateMaterialState createState() => UpdateMaterialState();
}

class UpdateMaterialState extends State<UpdateMaterial> {
  final TextEditingController _nameController = TextEditingController();
  bool isLoading = false;
  List<AssetEntity> selectedAssetList = [];
  String? urlImage;
  File? selectedFile;
  String hintImg = "Tải ảnh lên";
  Future<bool> updateMaterial(String name, File? image) {
    return MaterialService().updateMaterial(
        widget.material['id'], widget.material['farmId'], name, image);
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
      if (result != null) {
        selectedAssetList = result;
        urlImage = "";
      }
    });
  }

  Future convertAssetsToFiles(List<AssetEntity> assetEntities) async {
    for (var i = 0; i < assetEntities.length; i++) {
      final File? file = await assetEntities[i].originFile;
      setState(() {
        selectedFile = file!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.material['name'];
    urlImage = widget.material['urlImage'];
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
                      "Chỉnh sửa công cụ",
                      style: headingStyle,
                    ),
                    const SizedBox(height: 30),
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
                        hint: hintImg,
                        widget: Icon(Icons.add_photo_alternate, size: 30),
                      ),
                    ),
                    const SizedBox(height: 40),
                    if (selectedAssetList.length == 1)
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.height * 0.2,
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: AssetEntityImage(
                            selectedAssetList[0],
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
                      ),
                    if (urlImage!.isNotEmpty)
                      Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.height * 0.2,
                          child: Image.network(
                            urlImage!,
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
                    const SizedBox(height: 40),
                    const Divider(
                      color: Colors.grey, // Đặt màu xám
                      height: 1, // Độ dày của dòng gạch
                      thickness: 1, // Độ dày của dòng gạch (có thể thay đổi)
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
                            "Lưu chỉnh sửa",
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
          updateMaterial(_nameController.text.trim(), selectedFile!)
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
      else {
        updateMaterial(_nameController.text.trim(), null).then((value) {
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
      }
    } else {
      setState(() {
        isLoading = false;
      });
      SnackbarShowNoti.showSnackbar('Vui lòng điền tên công cụ', true);
    }
  }
}
