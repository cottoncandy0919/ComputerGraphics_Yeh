public void CGLine(float x1, float y1, float x2, float y2) {
  int xStart = round(x1);
  int yStart = round(y1);
  int xEnd = round(x2);
  int yEnd = round(y2);

  int dx = abs(xEnd - xStart);
  int dy = abs(yEnd - yStart);

  int sx = xStart < xEnd ? 1 : -1;
  int sy = yStart < yEnd ? 1 : -1;

  int err = dx - dy;

  int x = xStart;
  int y = yStart;

  while (true) {
    drawPoint(x, y, color(0, 0, 0)); // 畫紅色點

    if (x == xEnd && y == yEnd) {
      break;
    }

    int e2 = 2 * err;
    if (e2 > -dy) {
      err -= dy;
      x += sx;
    }
    if (e2 < dx) {
      err += dx;
      y += sy;
    }
  }
}

//它以整數為基礎，從 (0, r) 點出發，只計算1/8圓的像素點，
//利用圓的對稱性快速畫出剩下的7/8，並根據決策參數 d 來判斷下一步要走的方向。
public void CGCircle(float x, float y, float r) {
  int cx = round(x);
  int cy = round(y);
  int radius = round(r);

  int xc = 0;
  int yc = radius;
  int d = 3 - 2 * radius;

  while (xc <= yc) {
    // 畫出圓上 8 個對稱點
    drawPoint(cx + xc, cy + yc, color(0, 0, 0));
    drawPoint(cx - xc, cy + yc, color(0, 0, 0));
    drawPoint(cx + xc, cy - yc, color(0, 0, 0));
    drawPoint(cx - xc, cy - yc, color(0, 0, 0));
    drawPoint(cx + yc, cy + xc, color(0, 0, 0));
    drawPoint(cx - yc, cy + xc, color(0, 0, 0));
    drawPoint(cx + yc, cy - xc, color(0, 0, 0));
    drawPoint(cx - yc, cy - xc, color(0, 0, 0));

    if (d < 0) {
      d += 4 * xc + 6;
    } else {
      d += 4 * (xc - yc) + 10;
      yc--;
    }
    xc++;
  }
}

public void CGEllipse(float x, float y, float r1, float r2) {
  int xc = round(x);   // center x
  int yc = round(y);   // center y
  int rx = round(r1);  // x radius
  int ry = round(r2);  // y radius

  int rx2 = rx * rx;
  int ry2 = ry * ry;
  int tworx2 = 2 * rx2;
  int twory2 = 2 * ry2;

  int xPos = 0;
  int yPos = ry;
  int px = 0;
  int py = tworx2 * yPos;

  // Region 1
  int p1 = round(ry2 - (rx2 * ry) + (0.25 * rx2));
  while (px < py) {
    drawEllipsePoints(xc, yc, xPos, yPos);
    xPos++;
    px += twory2;
    if (p1 < 0) {
      p1 += ry2 + px;
    } else {
      yPos--;
      py -= tworx2;
      p1 += ry2 + px - py;
    }
  }

  // Region 2
  int p2 = round(ry2 * (xPos + 0.5) * (xPos + 0.5) + rx2 * (yPos - 1) * (yPos - 1) - rx2 * ry2);
  while (yPos >= 0) {
    drawEllipsePoints(xc, yc, xPos, yPos);
    yPos--;
    py -= tworx2;
    if (p2 > 0) {
      p2 += rx2 - py;
    } else {
      xPos++;
      px += twory2;
      p2 += rx2 - py + px;
    }
  }
}

// 輔助函式：根據四對稱性畫四個點
void drawEllipsePoints(int cx, int cy, int x, int y) {
  drawPoint(cx + x, cy + y, color(0, 0, 0));
  drawPoint(cx - x, cy + y, color(0, 0, 0));
  drawPoint(cx + x, cy - y, color(0, 0, 0));
  drawPoint(cx - x, cy - y, color(0, 0, 0));
}


public void CGCurve(Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4) {
  int steps = 1000;  // 計算曲線點的精細程度，可調整
  for (int i = 0; i <= steps; i++) {
    float t = i / (float) steps;

    // 計算貝茲曲線上對應的 x 和 y 座標
    float x = 
      pow(1 - t, 3) * p1.x +
      3 * pow(1 - t, 2) * t * p2.x +
      3 * (1 - t) * pow(t, 2) * p3.x +
      pow(t, 3) * p4.x;

    float y =
      pow(1 - t, 3) * p1.y +
      3 * pow(1 - t, 2) * t * p2.y +
      3 * (1 - t) * pow(t, 2) * p3.y +
      pow(t, 3) * p4.y;

    drawPoint(round(x), round(y), color(0, 0, 0)); 
  }
}


public void CGEraser(Vector3 p1, Vector3 p2) {
    // 計算擦除區域的範圍
    int xStart = min(round(p1.x), round(p2.x));
    int xEnd = max(round(p1.x), round(p2.x));
    int yStart = min(round(p1.y), round(p2.y));
    int yEnd = max(round(p1.y), round(p2.y));

    // 設置背景顏色（擦除顏色）
    color backgroundColor = color(250);

    // 擦除區域內的矩形區域，增加擦除範圍的大小
    for (int x = xStart; x <= xEnd; x++) {
        for (int y = yStart; y <= yEnd; y++) {
            // 擦除範圍內的所有像素
            drawPoint(x, y, backgroundColor);  // 擦除像素
        }
    }
}


public void drawPoint(float x, float y, color c) {
    stroke(c);
    point(x, y);
}

public float distance(Vector3 a, Vector3 b) {
    Vector3 c = a.sub(b);
    return sqrt(Vector3.dot(c, c));
}
