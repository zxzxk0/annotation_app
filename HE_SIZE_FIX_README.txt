H&E original-size fix

Root cause confirmed from debug logs:
- DZI height was ~41,486
- Polygon coordinates extend to ~80,813
- True original H&E height is 82,972
- The browser treated the downsampled DZI dimensions as original level-0 size,
  causing polygons with Y > ~41,486 to be drawn outside the canvas.

Fix:
- loadHeDziMeta() now prefers slides.json -> cosmx.original_sizes.he
- DZI XML is used to derive downsample ratio
- Expected PreSCCT1 values:
    DZI:      ~18,741 x 41,486
    Original: 37,482 x 82,972
    downsample: ~2

Expected console after deploy:
  originalW: 37482
  originalH: 82972
  downsampleX: 2
  downsampleY: 2

Then Y-band debug should continue through 80,000-82,972.
