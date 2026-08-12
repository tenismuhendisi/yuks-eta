const fs = require('fs');
const path = require('path');
const sharp = require('sharp');

const SRC = path.join(
  process.env.USERPROFILE,
  '.cursor/projects/c-Users-yuks2-OneDrive-Masa-st-development-yuks-eta/assets'
);
const OUT = path.join(__dirname, '..', 'assets', 'balls');

const inputs = {
  orange:
    'c__Users_yuks2_AppData_Roaming_Cursor_User_workspaceStorage_6159e908fd804823fcba415c8b940d19_images_image-0f67918c-8ec6-4155-af0c-572d4a0de0cd.png',
  green:
    'c__Users_yuks2_AppData_Roaming_Cursor_User_workspaceStorage_6159e908fd804823fcba415c8b940d19_images_image-c77fdc99-3a55-420d-871f-432de88e5f05.png',
  yellow:
    'c__Users_yuks2_AppData_Roaming_Cursor_User_workspaceStorage_6159e908fd804823fcba415c8b940d19_images_image-79034112-2c70-4724-8840-c3a734e0323c.png',
};

function isBg(r, g, b) {
  const max = Math.max(r, g, b);
  const min = Math.min(r, g, b);
  const sat = max === 0 ? 0 : (max - min) / max;
  if (max >= 232 && sat < 0.1) return true;
  if (r > 215 && g > 215 && b > 215 && sat < 0.08) return true;
  // soft floor shadow (gray)
  if (max < 200 && max > 140 && sat < 0.06) return true;
  return false;
}

function applyCircularMask(data, w, h, cx, cy, radius) {
  const soft = 2.5;
  for (let y = 0; y < h; y++) {
    for (let x = 0; x < w; x++) {
      const i = (y * w + x) * 4;
      const d = Math.hypot(x - cx, y - cy);
      if (d > radius + soft) {
        data[i + 3] = 0;
      } else if (d > radius) {
        const t = 1 - (d - radius) / soft;
        data[i + 3] = Math.round(data[i + 3] * t);
      }
    }
  }
}

function recolorToRed(data) {
  for (let i = 0; i < data.length; i += 4) {
    if (data[i + 3] < 16) continue;
    let r = data[i],
      g = data[i + 1],
      b = data[i + 2];
    const max = Math.max(r, g, b);
    const min = Math.min(r, g, b);
    const sat = max === 0 ? 0 : (max - min) / max;
    // keep seam / white-ish
    if (max > 200 && sat < 0.22) continue;
    // luminance of original felt
    const lum = 0.3 * r + 0.59 * g + 0.11 * b;
    const nr = Math.min(255, Math.round(lum * 0.55 + 150));
    const ng = Math.min(255, Math.round(lum * 0.18 + 18));
    const nb = Math.min(255, Math.round(lum * 0.12 + 12));
    data[i] = nr;
    data[i + 1] = ng;
    data[i + 2] = nb;
  }
}

async function processOne(srcPath, outName, { toRed = false } = {}) {
  const { data, info } = await sharp(srcPath).ensureAlpha().raw().toBuffer({
    resolveWithObject: true,
  });
  const w = info.width;
  const h = info.height;
  const rgba = Buffer.from(data);

  // chroma key
  for (let i = 0; i < rgba.length; i += 4) {
    if (isBg(rgba[i], rgba[i + 1], rgba[i + 2])) rgba[i + 3] = 0;
  }

  if (toRed) recolorToRed(rgba);

  // bbox of opaque pixels
  let minX = w,
    minY = h,
    maxX = 0,
    maxY = 0,
    sumX = 0,
    sumY = 0,
    n = 0;
  for (let y = 0; y < h; y++) {
    for (let x = 0; x < w; x++) {
      const a = rgba[(y * w + x) * 4 + 3];
      if (a > 40) {
        if (x < minX) minX = x;
        if (y < minY) minY = y;
        if (x > maxX) maxX = x;
        if (y > maxY) maxY = y;
        sumX += x;
        sumY += y;
        n++;
      }
    }
  }
  if (n === 0) throw new Error('empty after bg remove: ' + outName);

  const cx = sumX / n;
  const cy = sumY / n;
  // radius from bbox, slightly inward to kill residual shadow
  const bw = maxX - minX;
  const bh = maxY - minY;
  const radius = Math.min(bw, bh) * 0.48;

  applyCircularMask(rgba, w, h, cx, cy, radius);

  // recompute tight crop
  minX = w;
  minY = h;
  maxX = 0;
  maxY = 0;
  for (let y = 0; y < h; y++) {
    for (let x = 0; x < w; x++) {
      const a = rgba[(y * w + x) * 4 + 3];
      if (a > 20) {
        if (x < minX) minX = x;
        if (y < minY) minY = y;
        if (x > maxX) maxX = x;
        if (y > maxY) maxY = y;
      }
    }
  }
  const pad = 2;
  minX = Math.max(0, minX - pad);
  minY = Math.max(0, minY - pad);
  maxX = Math.min(w - 1, maxX + pad);
  maxY = Math.min(h - 1, maxY + pad);

  const size = 256;
  await sharp(rgba, { raw: { width: w, height: h, channels: 4 } })
    .extract({
      left: minX,
      top: minY,
      width: maxX - minX + 1,
      height: maxY - minY + 1,
    })
    .resize(size, size, {
      fit: 'contain',
      background: { r: 0, g: 0, b: 0, alpha: 0 },
    })
    .png()
    .toFile(path.join(OUT, outName));

  console.log('wrote', outName);
}

(async () => {
  fs.mkdirSync(OUT, { recursive: true });
  await processOne(path.join(SRC, inputs.orange), 'ball_orange.png');
  await processOne(path.join(SRC, inputs.green), 'ball_green.png');
  await processOne(path.join(SRC, inputs.yellow), 'ball_yellow.png');
  await processOne(path.join(SRC, inputs.yellow), 'ball_red.png', { toRed: true });
  console.log('done');
})().catch((e) => {
  console.error(e);
  process.exit(1);
});
