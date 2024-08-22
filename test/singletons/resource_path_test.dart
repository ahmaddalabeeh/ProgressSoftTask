import 'package:ahmad_progress_soft_task/singletons/resource_path.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  //Initialize
  setUp(
    () {},
  );

  //Clean Up
  tearDown(
    () {
      //
    },
  );

  test('check source paths', () {
    // Arrange

    // Act

    // Assert
    expect(ResourcePath.asset_images_folder_path, "assets/visual");
    expect(ResourcePath.progress_soft_logo_png,
        "assets/visual/png/progress_soft_logo_png.png");
  });
}
