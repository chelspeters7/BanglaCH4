FUNCTION plot_font, img, grid, YRANGE

IF grid EQ 1 THEN BEGIN
  gridlines = TIMEGEN(14, START = JULDAY(1, 1, 2003), UNITS = 'YEARS')
  FOR h = 0, 13 DO BEGIN
    plot2e = plot([gridlines[h], gridlines[h]], [YRANGE], /CURRENT, 'light grey', /overplot)
  ENDFOR
ENDIF
img.font_name = 'Arial'
img.title.font_size = 60
img.title.font_style = "Bold"
img.Background_transparency = 0
img.font_size = 32
END