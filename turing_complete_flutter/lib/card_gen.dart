import 'dart:io';

import 'package:image/image.dart';
import 'package:image/image.dart' as im;

Image genTtsCards(List<List<String>> cards, {String filename = "cards.png"}) {
  const CARD_S = 4;
  const CARD_W = 50*CARD_S;
  const CARD_H = 72*CARD_S;
  const NX = 10;
  const NY = 7;
  Image image = Image(CARD_W*NX, CARD_H*NY);
  fill(image, getColor(255, 255, 255));
  // Draw some text using 24pt arial font
  int i = 0;
  for (int y = 0; y < NY; y++) {
    for (int x = 0; x < NX; x++) {
      if (i >= cards.length) {
        break;
      }
      Image ci = Image(CARD_W, CARD_H);
      for (int j = 0; j < cards[i].length; j++) {
        String card = cards[i][j];
        double o = j - ((cards[i].length - 1) / 2.0);
        Image subimage = Image(CARD_W, CARD_H);
        drawStringCentered(subimage, arial_24, card, color: getColor(0, 0, 0));
        drawImage(ci, subimage, dstX: 0, dstY: (30*o).round());
      }
      drawImage(image, ci, dstX: CARD_W*x, dstY: CARD_H*y);
      i++;
    }
  }
  //drawLine(image, 0, 0, 320, 240, getColor(255, 0, 0), thickness: 3);
  File(filename).writeAsBytesSync(encodePng(image));
  return image;
}