import 'dart:ui';

import 'package:ahmad_progress_soft_task/singletons/font_weights.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  //Initialize
  setUp(
    () {},
  );

  //Clean Up
  tearDown(
    () {},
  );
  test('Check font weights values', () {
    //Arrange

    //Act

    //Assert
    expect(FontWeights.thin, FontWeight.w100);

    expect(FontWeights.extraThin, FontWeight.w200);

    expect(FontWeights.light, FontWeight.w300);

    expect(FontWeights.regular, FontWeight.w400);

    expect(FontWeights.medium, FontWeight.w500);

    expect(FontWeights.semiBold, FontWeight.w600);

    expect(FontWeights.bold, FontWeight.w700);

    expect(FontWeights.extraBold, FontWeight.w800);

    expect(FontWeights.black, FontWeight.w900);
  });
}
