import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/alert_dialog_confirm.dart';
import 'package:manager_somo_farm_task_management/componets/snackBar.dart';
import 'package:manager_somo_farm_task_management/componets/wrap_words.dart';
import 'package:manager_somo_farm_task_management/componets/wrap_words_with_ellipsis.dart';
import 'package:manager_somo_farm_task_management/screens/shared/evidence_update/evidence_update_page.dart';
import 'package:manager_somo_farm_task_management/services/evidence_service.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class EvidenceCard extends StatefulWidget {
  final Map<String, dynamic> evidence;
  final Map<String, dynamic> task;
  final VoidCallback updateEvidence;
  const EvidenceCard({
    required this.evidence,
    required this.task,
    required this.updateEvidence,
  });

  @override
  State<EvidenceCard> createState() => _EvidenceCardState();
}

class _EvidenceCardState extends State<EvidenceCard> {
  //List<dynamic> urlImages = [];
  bool isExpanded = false;
  int currentPage = 0;
  PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();
    // if (widget.evidence['urlImage'] != null)
    //   urlImages = widget.evidence['urlImage'];
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
                    Icon(
                      Icons.account_circle_sharp,
                      size: 45,
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          wrapWords(widget.task['supervisorName'], 20),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          widget.evidence['time'],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                                    "Xảy ra lỗi!", true);
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
          if (widget.evidence['urlImage'].isNotEmpty) ...[
            SizedBox(height: 8.0),
            Container(
              constraints: BoxConstraints(maxHeight: 230.0),
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.evidence['urlImage'].length,
                onPageChanged: (int page) {
                  setState(() {
                    currentPage = page;
                  });
                },
                itemBuilder: (BuildContext context, int index) {
                  return buildEvidenceImage(
                      widget.evidence['urlImage'][index], index);
                },
              ),
            ),
            SizedBox(height: 8.0),
            if (widget.evidence['urlImage'].length > 1) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.evidence['urlImage'].length,
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    width: 8.0,
                    height: 8.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentPage == index ? Colors.blue : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
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
