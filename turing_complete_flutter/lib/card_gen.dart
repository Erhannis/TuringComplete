import 'dart:io';

import 'package:image/image.dart';
import 'package:image/image.dart' as im;

const BLACK = 0xFF000000;
const WHITE = 0xFFFFFFFF;

BitmapFont FONT_1 = BitmapFont.fromZip(File('font_1.zip').readAsBytesSync());
BitmapFont FONT_05 = BitmapFont.fromZip(File('font_05.zip').readAsBytesSync());
BitmapFont FONT_025 = BitmapFont.fromZip(File('font_025.zip').readAsBytesSync());


const CARD_S = 4;
const CARD_W = 50*CARD_S;
const CARD_H = 72*CARD_S;


enum TextPos {
  TOP_LEFT, TOP_CENTER, TOP_RIGHT,
  MID_LEFT, MID_CENTER, MID_RIGHT,
  BOT_LEFT, BOT_CENTER, BOT_RIGHT,
}

class Text {
  TextPos pos;
  List<String> lines;
  int color;
  BitmapFont? font;
  num angle;

  Text(this.lines, {this.pos = TextPos.MID_CENTER, this.color = BLACK, this.font, this.angle = 0}) {
    if (this.font == null) {
      this.font = FONT_1;
    }
  }
}

class Card {
  List<Text> text;
  int bg;

  Card(this.text, {this.bg = WHITE});
}

Image genCard(Card card) {
  Image ci = Image(CARD_W, CARD_H);
  fill(ci, card.bg);
  for (Text text in card.text) {
    Image textimage = Image(CARD_W, CARD_H);
    for (int j = 0; j < text.lines.length; j++) {
      String line = text.lines[j];
      double o = j - ((text.lines.length - 1) / 2.0);
      Image lineimage = Image(CARD_W, CARD_H);
      drawStringCentered(lineimage, text.font ?? FONT_1, line, color: text.color);
      drawImage(textimage, lineimage, dstX: 0, dstY: (60*o).round());
    }
    int xo = 0;
    int yo = 0;
    switch (text.pos) {
      case TextPos.TOP_LEFT:
      // TODO: Handle this case.
        break;
      case TextPos.TOP_CENTER:
      // TODO: Handle this case.
        break;
      case TextPos.TOP_RIGHT:
      // TODO: Handle this case.
        break;
      case TextPos.MID_LEFT:
      // TODO: Handle this case.
        break;
      case TextPos.MID_CENTER:
        xo = 0;
        yo = 0;
        break;
      case TextPos.MID_RIGHT:
      // TODO: Handle this case.
        break;
      case TextPos.BOT_LEFT:
      // TODO: Handle this case.
        break;
      case TextPos.BOT_CENTER:
      // TODO: Handle this case.
        break;
      case TextPos.BOT_RIGHT:
      // TODO: Handle this case.
        break;
    }
    if (text.angle != 0) {
      textimage = im.copyRotate(textimage, text.angle);
    }
    drawImage(ci, textimage, dstX: xo, dstY: yo);
  }
  return ci;
}

void genRoll20Cards(List<Card> cards, {String filenameBase = "cards.png"}) {
  for (int i = 0; i < cards.length; i++) {
    final image = genCard(cards[i]);
    File("${i}_$filenameBase").writeAsBytesSync(encodePng(image));
  }
}

Image genTtsCards(List<Card> cards, {String filename = "cards.png"}) {
  /*
  final str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ`1234567890-=~!@#\$%^&*()_+[]\\{}|;':\",./<>?";
  for (int i = 0; i < str.codeUnits.length; i++) {
    int c = str.codeUnits[i];
    print("${str[i]} - $c : ${font.characters.containsKey(c)}");
  }
  */
  const NX = 10;
  const NY = 7;
  Image image = Image(CARD_W*NX, CARD_H*NY);
  //fill(image, getColor(255, 255, 255));
  // Draw some text using 24pt arial font
  int i = 0;
  for (int y = 0; y < NY; y++) {
    for (int x = 0; x < NX; x++) {
      if (i >= cards.length) {
        break;
      }
      Image ci = genCard(cards[i]);
      drawImage(image, ci, dstX: CARD_W*x, dstY: CARD_H*y);
      i++;
    }
  }
  //drawLine(image, 0, 0, 320, 240, getColor(255, 0, 0), thickness: 3);
  File(filename).writeAsBytesSync(encodePng(image));
  return image;
}

extension ExtColor on Color {
  static int invertXor(int color) {
    return color ^ 0x00FFFFFF;
  }

  static int invertLinear(int color) {
    int a = color & 0xFF000000;
    int b = color & 0x00FF0000;
    int g = color & 0x0000FF00;
    int r = color & 0x000000FF;
    return Color.fromRgba(255-r, 255-g, 255-b, a);
  }
}