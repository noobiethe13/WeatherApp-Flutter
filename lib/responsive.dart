class Responsive{
  final double height;
  final double width;

  Responsive({required this.height, required this.width});
  //HEIGHTS
  double get height25 => 0.0297 * height;
  double get height50 => 0.0594 * height;
  double get height20 => 0.0237 * height;
  double get height10 => 0.0118 * height;
  double get height80 => 0.0951 * height;
  double get height18 => 0.0214 * height;

  //WIDTHS
  double get width400 => 1.0146 * width;
  double get width80 => 0.2083 * width;
}