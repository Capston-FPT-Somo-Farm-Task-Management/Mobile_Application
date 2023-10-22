import 'dart:io';

import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/screens/shared/evidence_add/components/media_picker.dart';
import 'package:manager_somo_farm_task_management/screens/shared/evidence_add/components/imange_list_selected.dart';
import 'package:manager_somo_farm_task_management/services/evidence_service.dart';
import 'package:photo_manager/photo_manager.dart';

class CreateEvidencePage extends StatefulWidget {
  final int taskId;

  const CreateEvidencePage({super.key, required this.taskId});
  @override
  _CreateEvidencePageState createState() => _CreateEvidencePageState();
}

class _CreateEvidencePageState extends State<CreateEvidencePage> {
  TextEditingController _descriptionController = TextEditingController();
  List<AssetEntity> selectedAssetList = [];
  bool isCreateButtonEnabled = false;
  List<File> selectedFiles = [];
  bool isLoading = false;
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
      if (selectedAssetList.isNotEmpty &&
          _descriptionController.text.trim().isNotEmpty)
        isCreateButtonEnabled = true;
      if (selectedAssetList.isEmpty ||
          _descriptionController.text.trim().isEmpty)
        isCreateButtonEnabled = false;
    });
  }

  Future convertAssetsToFiles(List<AssetEntity> assetEntities) async {
    for (var i = 0; i < assetEntities.length; i++) {
      final File? file = await assetEntities[i].originFile;
      setState(() {
        selectedFiles.add(file!);
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
          if (selectedAssetList.isNotEmpty &&
              _descriptionController.text.isNotEmpty)
            isCreateButtonEnabled = true;
          if (selectedAssetList.isEmpty ||
              _descriptionController.text.trim().isEmpty)
            isCreateButtonEnabled = false;
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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.close_sharp, color: kSecondColor)),
        title: Text('Tạo báo cáo', style: TextStyle(color: kPrimaryColor)),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: isCreateButtonEnabled
                ? () {
                    setState(() {
                      isLoading = true;
                    });
                    convertAssetsToFiles(selectedAssetList).then((_) {
                      EvidenceService()
                          .createEvidence(widget.taskId,
                              _descriptionController.text, selectedFiles)
                          .then((value) {
                        if (value) {
                          SnackbarShowNoti.showSnackbar(
                              'Tạo báo cáo thành công!', false);
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pop(context, "newEvidence");
                        }
                      }).catchError((e) {
                        setState(() {
                          isLoading = true;
                        });
                        SnackbarShowNoti.showSnackbar(e.toString(), false);
                      });
                    });
                  }
                : null,
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isCreateButtonEnabled ? kPrimaryColor : Colors.black26,
                borderRadius: BorderRadius.all(
                  Radius.circular(7),
                ),
              ),
              child: Center(child: Text("Tạo")),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            )
          : Container(
              color: Colors.black12,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1,
                          color:
                              Colors.white, // Thay đổi màu sắc thành màu trắng
                        ),
                      ),
                    ),
                    alignment: Alignment.center,
                    height: 40,
                    padding: const EdgeInsets.only(top: 4),
                    child: Container(
                      margin: EdgeInsets.only(right: 15),
                      child: GestureDetector(
                        onTap: () {
                          pickAssets(
                            maxCount: 20,
                            requestType: RequestType.image,
                          );
                          setState(() {});
                        },
                        child: Icon(Icons.add_a_photo, size: 30),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: TextFormField(
                      maxLines: null,
                      autofocus: false,
                      controller: _descriptionController,
                      style: subTitileStyle.copyWith(fontSize: 17),
                      onChanged: (value) {
                        if (value.trim().isNotEmpty &&
                            selectedAssetList.isNotEmpty)
                          setState(() {
                            isCreateButtonEnabled = true;
                          });
                        if (value.trim().isEmpty || selectedAssetList.isEmpty)
                          setState(() {
                            isCreateButtonEnabled = false;
                          });
                      },
                      decoration: InputDecoration(
                        hintText: "Nhập mô tả về báo cáo...",
                        hintStyle: subTitileStyle.copyWith(
                            color: kTextGreyColor, fontSize: 17),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  if (selectedAssetList.length == 1)
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: buildAssetWidget(selectedAssetList[0]),
                    ),
                  if (selectedAssetList.length == 2)
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Row(
                        children: [
                          // Cột 1 của Hàng đầu chiếm 50%
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 1, bottom: 1),
                              child: buildAssetWidget(selectedAssetList[0]),
                            ),
                          ),
                          // Cột 2 của Hàng đầu chiếm 50%
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 1, bottom: 1),
                              child: buildAssetWidget(selectedAssetList[1]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (selectedAssetList.length == 3)
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Row(
                        children: [
                          // Cột 1 chiếm 70%
                          Expanded(
                            flex: 7,
                            child: Container(
                                padding: EdgeInsets.only(right: 1),
                                child: buildAssetWidget(selectedAssetList[0])),
                          ),
                          // Cột 2 chiếm 30%
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.only(left: 1),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 1),
                                      child: buildAssetWidget(
                                          selectedAssetList[1]),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 1),
                                      child: buildAssetWidget(
                                          selectedAssetList[2]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (selectedAssetList.length == 4)
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Row(
                        children: [
                          // Cột 1 chiếm 70%
                          Expanded(
                            flex: 7,
                            child: Container(
                                padding: EdgeInsets.only(right: 1),
                                child: buildAssetWidget(selectedAssetList[0])),
                          ),
                          // Cột 2 chiếm 30%
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.only(left: 1),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 1, left: 1),
                                      child: buildAssetWidget(
                                          selectedAssetList[1]),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 1, left: 1),
                                      child: buildAssetWidget(
                                          selectedAssetList[2]),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 1, left: 1),
                                      child: buildAssetWidget(
                                          selectedAssetList[3]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (selectedAssetList.length == 5)
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Column(
                        children: [
                          // Hàng đầu chiếm 70%
                          Expanded(
                            flex: 6,
                            child: Row(
                              children: [
                                // Cột 1 của Hàng đầu chiếm 50%
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 1, bottom: 1),
                                    child:
                                        buildAssetWidget(selectedAssetList[0]),
                                  ),
                                ),
                                // Cột 2 của Hàng đầu chiếm 50%
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 1, bottom: 1),
                                    child:
                                        buildAssetWidget(selectedAssetList[1]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Hàng thứ hai chiếm 30%
                          Expanded(
                            flex: 4,
                            child: Row(
                              children: [
                                // Cột 1 của Hàng thứ hai chiếm 33.33%
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(right: 1, top: 1),
                                    child:
                                        buildAssetWidget(selectedAssetList[2]),
                                  ),
                                ),
                                // Cột 2 của Hàng thứ hai chiếm 33.33%
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 1, right: 1, top: 1),
                                    child:
                                        buildAssetWidget(selectedAssetList[3]),
                                  ),
                                ),
                                // Cột 3 của Hàng thứ hai chiếm 33.33%
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(left: 1, top: 1),
                                    child:
                                        buildAssetWidget(selectedAssetList[4]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (selectedAssetList.length > 5)
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Column(
                        children: [
                          // Hàng đầu chiếm 70%
                          Expanded(
                            flex: 6,
                            child: Row(
                              children: [
                                // Cột 1 của Hàng đầu chiếm 50%
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 1, bottom: 1),
                                    child:
                                        buildAssetWidget(selectedAssetList[0]),
                                  ),
                                ),
                                // Cột 2 của Hàng đầu chiếm 50%
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 1, bottom: 1),
                                    child:
                                        buildAssetWidget(selectedAssetList[1]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Hàng thứ hai chiếm 30%
                          Expanded(
                            flex: 4,
                            child: Row(
                              children: [
                                // Cột 1 của Hàng thứ hai chiếm 33.33%
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(right: 1, top: 1),
                                    child:
                                        buildAssetWidget(selectedAssetList[2]),
                                  ),
                                ),
                                // Cột 2 của Hàng thứ hai chiếm 33.33%
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 1, right: 1, top: 1),
                                    child:
                                        buildAssetWidget(selectedAssetList[3]),
                                  ),
                                ),
                                // Cột 3 của Hàng thứ hai chiếm 33.33%
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(left: 1, top: 1),
                                    child: GestureDetector(
                                      onTap: () async {
                                        final result =
                                            await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ImageListSelectedPage(
                                                    selectedAssetList:
                                                        selectedAssetList,
                                                    indexFocus: 4),
                                          ),
                                        );
                                        setState(() {
                                          selectedAssetList = result;
                                        });
                                      },
                                      child: Stack(
                                        children: [
                                          buildAssetWidget(
                                              selectedAssetList[4]),
                                          Container(
                                            color: Colors.black.withOpacity(
                                                0.4), // Điều chỉnh độ mờ tại đây
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "+ ${selectedAssetList.length - 5}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
