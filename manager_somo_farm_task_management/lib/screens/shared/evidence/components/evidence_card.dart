import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_somo_farm_task_management/componets/alert_dialog_confirm.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/componets/wrap_words.dart';
import 'package:manager_somo_farm_task_management/componets/wrap_words_with_ellipsis.dart';
import 'package:manager_somo_farm_task_management/screens/shared/evidence/components/imgList.dart';
import 'package:manager_somo_farm_task_management/screens/shared/evidence_update/components/imange_list_selected.dart';
import 'package:manager_somo_farm_task_management/screens/shared/evidence_update/evidence_update_page.dart';
import 'package:manager_somo_farm_task_management/services/evidence_service.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class EvidenceCard extends StatefulWidget {
  final Map<String, dynamic> evidence;
  final Map<String, dynamic> task;
  final VoidCallback updateEvidence;
  final String role;
  const EvidenceCard({
    required this.evidence,
    required this.task,
    required this.updateEvidence,
    required this.role,
  });

  @override
  State<EvidenceCard> createState() => _EvidenceCardState();
}

class _EvidenceCardState extends State<EvidenceCard> {
  List<dynamic> urlImages = [];
  bool isExpanded = false;
  int currentPage = 0;
  //PageController _pageController = PageController();
  String? supAvatar;
  @override
  void initState() {
    super.initState();
    supAvatar = widget.evidence['avatarManager'].toString().isEmpty
        ? widget.task['avatarSupervisor']
        : widget.evidence['avatarManager'];
    if (widget.evidence['urlImage'] != null)
      urlImages = widget.evidence['urlImage'];
  }

  Widget buildUrlImagetWidget(String imageUrl, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ImageListPage(
                viewOnly: true, urlImages: urlImages, indexFocus: index),
          ),
        );
      },
      child: Stack(
        children: [
          Positioned.fill(
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: Image.network(
                        supAvatar ?? "string",
                        height: 40,
                        width: 40,
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
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          wrapWords(
                              widget.evidence['managerName']
                                      .toString()
                                      .isNotEmpty
                                  ? widget.evidence['managerName']
                                  : widget.task['supervisorName'],
                              22),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Tooltip(
                              message: DateFormat('dd/MM/yyyy HH:mm aa').format(
                                  DateTime.parse(
                                      widget.evidence['submitDate'])),
                              child: Text(
                                widget.evidence['time'],
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            if (widget.evidence['evidenceType'] == 2)
                              Text(
                                "Hủy bỏ",
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            if (widget.evidence['evidenceType'] == 3)
                              Text(
                                "Tạm hoãn",
                                style: TextStyle(
                                  color: Colors.amber[700],
                                  fontSize: 14,
                                ),
                              ),
                            if (widget.evidence['evidenceType'] == 4)
                              Text(
                                "Làm lại",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                if (widget.role == "Supervisor" &&
                    (widget.evidence['managerName'] == null ||
                        widget.evidence['managerName'] == ""))
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_horiz_outlined),
                    onSelected: (value) {
                      if (value == 'Delete') {
                        showDialog(
                          context: context,
                          builder: (BuildContext context1) {
                            return ConfirmDeleteDialog(
                              title: "Xóa báo cáo",
                              content: "Bạn có chắc muốn xóa báo cáo này?",
                              onConfirm: () {
                                EvidenceService()
                                    .deleteEvidence(widget.evidence['id'])
                                    .then((value) {
                                  if (value) {
                                    widget.updateEvidence();
                                    SnackbarShowNoti.showSnackbar(
                                        "Xóa thành công!", false);
                                  }
                                }).catchError((e) {
                                  SnackbarShowNoti.showSnackbar(
                                      e.toString(), true);
                                });
                              },
                              buttonConfirmText: "Xóa",
                            );
                          },
                        );
                      }
                      if (value == 'Edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return UpdateEvidencePage(
                                evidenceId: widget.evidence['id'],
                              );
                            },
                          ),
                        ).then((value) {
                          if (value != null) widget.updateEvidence();
                        });
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'Delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 5),
                              Text(
                                'Xóa',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'Edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_note_rounded),
                              SizedBox(width: 5),
                              Text(
                                'Chỉnh sửa',
                              ),
                            ],
                          ),
                        ),
                      ];
                    },
                  ),
              ],
            ),
          ),
          SizedBox(height: 8.0),
          Container(
            width: double.infinity,
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isExpanded
                        ? widget.evidence['description']
                        : wrapWordsWithEllipsis(
                            widget.evidence['description'], 100),
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8.0),
                  if (widget.evidence['description'].length > 100)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Text(
                        isExpanded ? "Ẩn bớt" : 'Xem thêm',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (widget.evidence['urlImage'] != null) ...[
            if (widget.evidence['urlImage'].length == 1)
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: buildUrlImagetWidget(widget.evidence['urlImage'][0], 0),
              ),
            if (widget.evidence['urlImage'].length == 2)
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Row(
                  children: [
                    // Cột 1 của Hàng đầu chiếm 50%
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 1, bottom: 1),
                        child: buildUrlImagetWidget(
                            widget.evidence['urlImage'][0], 0),
                      ),
                    ),
                    // Cột 2 của Hàng đầu chiếm 50%
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 1, bottom: 1),
                        child: buildUrlImagetWidget(
                            widget.evidence['urlImage'][1], 1),
                      ),
                    ),
                  ],
                ),
              ),
            if (widget.evidence['urlImage'].length == 3)
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Row(
                  children: [
                    // Cột 1 chiếm 70%
                    Expanded(
                      flex: 7,
                      child: Container(
                          padding: EdgeInsets.only(right: 1),
                          child: buildUrlImagetWidget(
                              widget.evidence['urlImage'][0], 0)),
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
                                child: buildUrlImagetWidget(
                                    widget.evidence['urlImage'][1], 1),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 1),
                                child: buildUrlImagetWidget(
                                    widget.evidence['urlImage'][2], 2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (widget.evidence['urlImage'].length == 4)
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Row(
                  children: [
                    // Cột 1 chiếm 70%
                    Expanded(
                      flex: 7,
                      child: Container(
                          padding: EdgeInsets.only(right: 1),
                          child: buildUrlImagetWidget(
                              widget.evidence['urlImage'][0], 0)),
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
                                padding:
                                    const EdgeInsets.only(bottom: 1, left: 1),
                                child: buildUrlImagetWidget(
                                    widget.evidence['urlImage'][1], 1),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 1, left: 1),
                                child: buildUrlImagetWidget(
                                    widget.evidence['urlImage'][2], 2),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 1, left: 1),
                                child: buildUrlImagetWidget(
                                    widget.evidence['urlImage'][3], 3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (widget.evidence['urlImage'].length == 5)
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
                              padding:
                                  const EdgeInsets.only(right: 1, bottom: 1),
                              child: buildUrlImagetWidget(
                                  widget.evidence['urlImage'][0], 0),
                            ),
                          ),
                          // Cột 2 của Hàng đầu chiếm 50%
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 1, bottom: 1),
                              child: buildUrlImagetWidget(
                                  widget.evidence['urlImage'][1], 1),
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
                              padding: const EdgeInsets.only(right: 1, top: 1),
                              child: buildUrlImagetWidget(
                                  widget.evidence['urlImage'][2], 2),
                            ),
                          ),
                          // Cột 2 của Hàng thứ hai chiếm 33.33%
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 1, right: 1, top: 1),
                              child: buildUrlImagetWidget(
                                  widget.evidence['urlImage'][3], 3),
                            ),
                          ),
                          // Cột 3 của Hàng thứ hai chiếm 33.33%
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 1, top: 1),
                              child: buildUrlImagetWidget(
                                  widget.evidence['urlImage'][4], 4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            if (widget.evidence['urlImage'].length > 5)
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
                              padding:
                                  const EdgeInsets.only(right: 1, bottom: 1),
                              child: buildUrlImagetWidget(
                                  widget.evidence['urlImage'][0], 0),
                            ),
                          ),
                          // Cột 2 của Hàng đầu chiếm 50%
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 1, bottom: 1),
                              child: buildUrlImagetWidget(
                                  widget.evidence['urlImage'][1], 1),
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
                              padding: const EdgeInsets.only(right: 1, top: 1),
                              child: buildUrlImagetWidget(
                                  widget.evidence['urlImage'][2], 2),
                            ),
                          ),
                          // Cột 2 của Hàng thứ hai chiếm 33.33%
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 1, right: 1, top: 1),
                              child: buildUrlImagetWidget(
                                  widget.evidence['urlImage'][3], 3),
                            ),
                          ),
                          // Cột 3 của Hàng thứ hai chiếm 33.33%
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 1, top: 1),
                              child: GestureDetector(
                                onTap: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ImageListSelectedPage(
                                              viewOnly: true,
                                              urlImages:
                                                  widget.evidence['urlImage'],
                                              selectedAssetList: [],
                                              indexFocus: 4),
                                    ),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    buildUrlImagetWidget(
                                        widget.evidence['urlImage'][4], 4),
                                    Container(
                                      color: Colors.black.withOpacity(
                                          0.4), // Điều chỉnh độ mờ tại đây
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "+ ${widget.evidence['urlImage'].length - 5}",
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
          SizedBox(height: 8.0),
        ],
      ),
    );
  }

  Widget buildEvidenceImage(String imageUrl, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                buildPhotoViewGallery(widget.evidence['urlImage'], index),
          ),
        );
      },
      child: Hero(
        tag: imageUrl,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildPhotoViewGallery(List<dynamic> imageUrls, int initialIndex) {
    PageController _photoPageController =
        PageController(initialPage: initialIndex);

    return Scaffold(
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          Navigator.pop(context);
        },
        child: PhotoViewGallery.builder(
          itemCount: imageUrls.length,
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(imageUrls[index]),
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
}
