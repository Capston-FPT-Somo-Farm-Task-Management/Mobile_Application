import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:manager_somo_farm_task_management/screens/shared/evidence/components/media_picker.dart';
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
      selectedAssetList = result;
    });
  }

  Widget buildAssetGridView() {
    return Expanded(
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: selectedAssetList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          AssetEntity assetEntity = selectedAssetList[index];
          return buildAssetWidget(assetEntity);
        },
      ),
    );
  }

  Widget buildAssetWidget(AssetEntity assetEntity) {
    return Stack(
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
            child: Icon(Icons.close_sharp, color: kPrimaryColor)),
        title: Text('Tạo báo cáo', style: TextStyle(color: kPrimaryColor)),
        centerTitle: true,
        actions: [
          GestureDetector(
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.all(
                  Radius.circular(7),
                ),
              ),
              child: Center(child: Text("Tạo")),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.black12,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Colors.white, // Thay đổi màu sắc thành màu trắng
                  ),
                ),
              ),
              alignment: Alignment.centerRight,
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
                decoration: InputDecoration(
                  hintText: "Nhập mô tả về báo cáo...",
                  hintStyle: subTitileStyle.copyWith(
                      color: kTextGreyColor, fontSize: 17),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              ),
            ),
            //if (selectedAssetList.isNotEmpty) buildAssetGridView(),
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
                                child: buildAssetWidget(selectedAssetList[1]),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 1),
                                child: buildAssetWidget(selectedAssetList[2]),
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
                                padding: const EdgeInsets.only(bottom: 1),
                                child: buildAssetWidget(selectedAssetList[1]),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 1),
                                child: buildAssetWidget(selectedAssetList[2]),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 1),
                                child: buildAssetWidget(selectedAssetList[3]),
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
                            child: buildAssetWidget(selectedAssetList[0]),
                          ),
                          // Cột 2 của Hàng đầu chiếm 50%
                          Expanded(
                            child: buildAssetWidget(selectedAssetList[1]),
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
                            child: buildAssetWidget(selectedAssetList[2]),
                          ),
                          // Cột 2 của Hàng thứ hai chiếm 33.33%
                          Expanded(
                            child: buildAssetWidget(selectedAssetList[3]),
                          ),
                          // Cột 3 của Hàng thứ hai chiếm 33.33%
                          Expanded(
                            child: buildAssetWidget(selectedAssetList[4]),
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
