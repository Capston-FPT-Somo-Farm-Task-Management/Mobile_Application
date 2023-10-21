import 'package:flutter/material.dart';
import 'package:manager_somo_farm_task_management/componets/constants.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class TaskEvidenceDetails extends StatefulWidget {
  final Map<String, dynamic> task;

  const TaskEvidenceDetails({super.key, required this.task});
  @override
  _TaskEvidenceDetailsState createState() => _TaskEvidenceDetailsState();
}

class _TaskEvidenceDetailsState extends State<TaskEvidenceDetails> {
  Map<String, dynamic>? evidence;

  List<String> images = [
    "https://file.hstatic.net/200000348921/file/huy_anh_9075c4480af44edba330a1964e597bfd_grande.jpg",
    "https://ben.com.vn/tin-tuc/wp-content/uploads/2021/10/hinh-nen-dep-dien-thoai.jpg",
    "https://i.pinimg.com/474x/48/9a/4f/489a4f03f4ba0bfcba6aa0ce64349727.jpg",
    "https://instagram.fsgn2-4.fna.fbcdn.net/v/t51.2885-15/331662687_1026488075422441_5401476994812502998_n.jpg?stp=dst-jpg_e35_p480x480&efg=eyJ2ZW5jb2RlX3RhZyI6ImltYWdlX3VybGdlbi4xMjAxeDE1MDEuc2RyIn0&_nc_ht=instagram.fsgn2-4.fna.fbcdn.net&_nc_cat=101&_nc_ohc=kcVSom_SSSoAX92uF5o&edm=ACWDqb8BAAAA&ccb=7-5&ig_cache_key=MzA1NTM0Mzc4MTkyMTcyMDc5Nw%3D%3D.2-ccb7-5&oh=00_AfDc3pCUwO4GNFYtndVRksLKrRgy63l9nEP_vf8yTK2shA&oe=6525A590&_nc_sid=ee9879"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
          color: kSecondColor, // Change to your preferred color
        ),
        centerTitle: true,
        title: Container(
          margin: EdgeInsets.only(top: 10),
          child: Text(
            'Báo cáo công việc',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTaskDetails(),
            const SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: const Divider(
                color: Colors.grey, // Đặt màu xám
                height: 1, // Độ dày của dòng gạch
                thickness: 1, // Độ dày của dòng gạch (có thể thay đổi)
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.border_all_rounded),
                const SizedBox(width: 5),
                Text(
                  "HÌNH ẢNH",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 10),
            buildImageGrid(),
          ],
        ),
      ),
    );
  }

  Widget buildTaskDetails() {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Tam con bo",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person_pin_circle),
                  SizedBox(width: 5),
                  Text(
                    "Người giám sát: Nguyen Van Bo",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Icon(Icons.date_range),
                  SizedBox(width: 5),
                  Text(
                    "Ngày nộp: 22/11/2001",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 30.0),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
            constraints: BoxConstraints(
              minHeight: 100.0,
            ),
            width: double.infinity,
            child: Container(
              padding: EdgeInsets.all(10), // Adjust padding as needed
              child: Text(
                "Mô tả về bằng chứng công việc",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImageGrid() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // You can adjust the number of columns
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: images.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return buildEvidenceImage(images[index], index);
        },
      ),
    );
  }

  Widget buildEvidenceImage(String imageUrl, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => buildPhotoViewGallery(images, index),
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

  Widget buildPhotoViewGallery(List<String> imageUrls, int initialIndex) {
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
