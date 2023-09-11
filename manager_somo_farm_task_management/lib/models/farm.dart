class Farm {
  final int id;
  final String title, description, image;

  Farm(
      {required this.id,
      required this.title,
      required this.description,
      required this.image});
}

// list of products
// for our demo
List<Farm> products = [
  Farm(
    id: 1,
    title: "Công Ty TNHH Chăn nuôi Bắc Nam",
    image:
        "https://file.hstatic.net/200000348921/file/bac_nam_cc28d2357034462fa5844ebd64ce6152_grande.jpg",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim",
  ),
  Farm(
    id: 4,
    title: "Công ty TNHH Chăn nuôi Huy Anh",
    image:
        "https://file.hstatic.net/200000348921/file/huy_anh_9075c4480af44edba330a1964e597bfd_grande.jpg",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim",
  ),
  Farm(
    id: 9,
    title: "SomoFarm Tân Biên",
    image:
        "https://file.hstatic.net/200000348921/file/tan_bien_f75d372c14ba43439301413504b195de_grande.jpg",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim",
  ),
  Farm(
    id: 9,
    title: "SomoFarm Tân Biên",
    image:
        "https://file.hstatic.net/200000348921/file/tan_bien_f75d372c14ba43439301413504b195de_grande.jpg",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim",
  ),
];
