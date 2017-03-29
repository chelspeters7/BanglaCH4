PRO JGR_code
; Creates all plots for the JGR 2016 paper
; Uses the following functions: plot_font, crop, annual, annual2
  ; Set directory
  CD, '/Users/peterscn/IDL_Library/Code'
  ;==========================================================================================
  ; Set colors for plots
  clr = [[136,204, 238] ,[221,2014,119], [170,68,153], [17,119,51], [51,34,136], [204,102,119], [153,153, 51], [68,170,153], [136,34,85]]
  ;==========================================================================================
  ;==========================================================================================
  ; Land Water Fraction and Surface Water Gauges
  ; import .sav data files
  RESTORE, FILE = 'TRMM.sav' ; TRMM-TMI dataset
  RESTORE,FILE = 'Bangla_surface_water.sav' ; Bangladesh surface water gauge dataset
  ;===========================================
  water.LWF_delay[*,WHERE(water.LWF_delay[0,*] GT 0.8)] = !VALUES.F_NAN ;remove pixels that are ocean water
  water_date = water.jul[12:-1] ;create date dataset that matches XCH4 datasets
  water_LWF_delay = water.LWF_delay[*,12:-1]
  ;===========================================
  ; plot land water fraction and gauge timeseries
  plot_margin = [0.15, 0.25, 0.15, 0.15]
  YRANGE=[0,40]
  TICKV = julday(1,1,[2003:2015])
  XRANGE = [julday(1,1,2003), julday(1,1,2015)]
  img = plot(water.jul, water.LWF_delay[0,*]*100.0,  '-k2', XTICKUNITS = 'Month', margin=plot_margin, XTICKINTERVAL = 6, axis_style = 1, XRANGE = XRANGE, YRANGE=[0,40], XMinor = 5, name = 'TRMM', Title = 'Surface Water',  YTITLE = "Area Inundated (%)")
  img2 = plot([tickv[0]-30, Tickv[-1]+30], [40, 40], '-2k', /current, /overplot)
  xaxis = AXIS('X', TARGET = img,Location = -3, TICKV = TICKV, TICKUNITS = 'YEARS', Minor = 11,  TICKLEN = 0.01, SUBTICKLEN = 0.008)
  !null = plot_font(img, 1, YRANGE) ;format plot using function "plot_font"

  img1= plot(timegen(1826, UNITS = 'DAYS', START = Julday(1,1,2003)), sw_mean, '-2',color = clr[*,4], /current, axis_style=0, margin=plot_margin, xrange=XRANGE)
  a_wdir = axis('y', color = clr[*,4], target=img1, major=5, minor=9, location='right', textpos=1, tickdir=1, title='Gauge Water Height Anomaly (m)', tickfont_size = 32, tickfont_name = 'Arial');, tickfont_style = "Bold")
  img3= plot(timegen(1826, UNITS = 'DAYS', START = Julday(1,1,2003)), upper, '-', COLOR = clr[*,0], /current, axis_style=0, margin=plot_margin, xrange=XRANGE)
  img4= plot(timegen(1826, UNITS = 'DAYS', START = Julday(1,1,2003)), lower, '-', COLOR = clr[*,0], /current, axis_style=0, margin=plot_margin, xrange=XRANGE)
  img5= plot(timegen(1826, UNITS = 'DAYS', START = Julday(1,1,2003)), sw_mean, '-2',color = clr[*,4], /OVERPLOT, /current, axis_style=0, margin=plot_margin, xrange=XRANGE)

  ;===========================================
  ; plot annual land water fraction and gauge timeseries
  TICKV =  TIMEGEN(12, START = Julday(1, 15, 2003), DAYS = [15])
  XTICKV =  TIMEGEN(12, START = Julday(1, 1, 2003), DAYS = [1], UNITS='Months', STEP_SIZE=1)
  XRANGE = [julday(1,1,2003), julday(12,31,2003)]
  img = plot([TICKV[0]-30,TICKV[-1]+30], [0,0], '-2', COLOR = 'light grey', XTICKV = XTICKV, XMinor = 1, XTICKUNITS = 'Month', XTICKINTERVAL = 1, XRANGE = XRANGE, YRANGE = YRANGE, name = 'Bangladesh')
  img1 = plot(TICKV, annual(water.LWF_delay[0,*]*100.0), /CURRENT, '-2',color = clr[*,4], /overplot, name = 'TRMM', YTITLE = "Area Inundated, %", TITLE = "TRMM")
  img2 = plot([tickv[0]-30, Tickv[-1]+30], [40, 40], '-2k', /current, /overplot)
  img.font_name = 'Arial'
  img.Background_transparency = 0
  img.font_size = 18
  !null = plot_font(img, 1, YRANGE)

  ;==========================================================================================
  ;==========================================================================================
  ; Satellite data
  RESTORE,'/data2/ralf/FOR_CHELSEA/all_ch4.sav' ; AIRS, SCIAMACHY, and GOSAT structure
  ; crop datasets to remove unnessary pixels
  aa= mean(mean(crop(airs.dat), /NAN, dimension = 1),dimension = 1, /NAN)
  gg= mean(mean(crop(gosa.dat), /NAN, dimension = 1),dimension = 1, /NAN)
  ss= mean(mean(crop(scia.dat), /NAN, dimension = 1),dimension = 1, /NAN)
  t = TIMEGEN(N_elements(aa), START=JULDAY(1,15,2003), Units = 'Months') ;create dates that correspond to timeseries

  ;===========================================
  ; Plot mixing ratios (XCH4) as observed from AIRS, SCIAMACHY, and GOSAT over Bangladesh
  TICKV = julday(1,1,[2003:2015])
  XRANGE = [julday(1,1,2003), julday(1,1,2015)]
  YRANGE=[1700,2000]
  img = plot(airs.jul, aa, LAYOUT = [1,1,1],  '2', color= clr[*,8], XTICKUNITS = 'Month', XTICKINTERVAL = 6, XRANGE = XRANGE, YRANGE=YRANGE, XMinor = 5, name = 'AIRS', Title = 'Bangladesh XCH$_4$ Observations',  YTITLE = "CH$_4$, ppb",Position = [0.1,0.25,0.75,0.7])
  img1 = plot(scia.jul, ss,  '2', color= clr[*,3],/overplot, /CURRENT, name = 'SCIAMACHY')
  img2 = plot(gosa.jul, gg, '2', color= clr[*,6], /overplot, /CURRENT, name = 'GOSAT')
  xaxis = AXIS('X', TARGET = img,Location = 1668, TICKV = TICKV, TICKUNITS = 'YEARS', Minor = 11,  TICKLEN = 0.01, SUBTICKLEN = 0.008)
  !null = plot_font(img, 1, YRANGE)
  !null = legend(target=[img, img1, img2], font_size = 18, font_name = 'Arial',/AUTO_TEXT_COLOR, shadow = 0, POSITION=[julday(6,1,2017),1800], /DATA)

  ;===========================================
  ; Plot Annual XCH4 over Bangladesh
  TICKV =  TIMEGEN(12, START = Julday(1, 15, 2003), DAYS = [15])
  XTICKV =  TIMEGEN(3, START = Julday(1, 1, 2003), DAYS = [1], UNITS='Months', STEP_SIZE=6)
  XRANGE = [julday(1,1,2003), julday(12,31,2003)]
  img = plot([TICKV[0]-30,TICKV[-1]+30], [0,0], '-2', COLOR = 'light grey', YTICKFORMAT="(A1)", XTICKV = XTICKV, XMinor = 1, XTICKUNITS = 'Month', XTICKINTERVAL = 1, YTICKV = YTICKV, XRANGE = XRANGE, YRANGE = YRANGE, name = 'Bangladesh', /CURRENT, Position = [0.79,0.25,0.9,0.7])

  ;AIRS
  aa_an = annual(aa) ;function that reformats dataset into annual average
  img1 = plot(tickv, aa_an, /overplot, /CURRENT,  '2', color= clr[*,8],  name = 'AIRS', Title = ' ')

  ;SCIA
  ss_an = annual(ss)
  img3 = plot(tickv, ss_an,  '2', color= clr[*,3], /overplot, /CURRENT, name = 'SCIAMACHY')

  ;GOSAT
  gg_an = annual(gg)
  img2 = plot(tickv, gg_an, '2', color= clr[*,6], /overplot, /CURRENT, name = 'GOSAT')
  img.font_name = 'Arial'
  img.Background_transparency = 0
  img.font_size = 18
  !null = plot_font(img, 1, YRANGE)
  STOP
  ;===========================================
  ;Plot XCH4 with error (included in supplementary information)
  ;Percent error
  a_er = 1.6/100*aa ;percent error as stated in methods (1.6% for AIRS)
  s_er = 2.0/100*ss
  g_er = 0.8/100*gg

  TICKV = julday(1,1,[2003:2015])
  XRANGE = [julday(1,1,2003), julday(1,1,2015)]
  YRANGE=[1700,2000]
  img = plot(airs.jul, aa, LAYOUT = [1,1,1],  '2--', color= clr[*,8], XTICKUNITS = 'Month', XTICKINTERVAL = 6, XRANGE = XRANGE, YRANGE=YRANGE, XMinor = 5, name = 'AIRS', Title = 'Bangladesh XCH$_4$ Observations',  YTITLE = "CH$_4$, ppb",Position = [0.1,0.25,0.75,0.7])
  imgg = plot(airs.jul, aa+a_er, LAYOUT = [1,1,1],  '2', color= clr[*,8], /overplot, /current)
  imggg = plot(airs.jul, aa-a_er, LAYOUT = [1,1,1],  '2', color= clr[*,8], /overplot, /current)
  img1 = plot(scia.jul, ss,  '2--', color= clr[*,3],/overplot, /CURRENT, name = 'SCIAMACHY')
  imgg1 = plot(scia.jul, ss+s_er, LAYOUT = [1,1,1],  '2', color= clr[*,3], /overplot, /current)
  imggg1 = plot(scia.jul, ss-s_er, LAYOUT = [1,1,1],  '2', color= clr[*,3], /overplot, /current)
  img2 = plot(gosa.jul, gg, '2--', color= clr[*,6], /overplot, /CURRENT, name = 'GOSAT')
  imgg2 = plot(gosa.jul, gg+g_er, LAYOUT = [1,1,1],  '2', color= clr[*,6], /overplot, /current)
  imggg2 = plot(gosa.jul, gg-g_er, LAYOUT = [1,1,1],  '2', color= clr[*,6], /overplot, /current)
  xaxis = AXIS('X', TARGET = img,Location = 1668, TICKV = TICKV, TICKUNITS = 'YEARS', Minor = 11,  TICKLEN = 0.01, SUBTICKLEN = 0.008)
  !null = plot_font(img, 1, YRANGE)
  !null = legend(target=[img, img1, img2], font_size = 18, font_name = 'Arial',/AUTO_TEXT_COLOR, shadow = 0, POSITION=[julday(6,1,2017),1800], /DATA)

  ;==========================================================================================
  ;==========================================================================================
  ; Load in HYSPLIT forward and backtrajectory data
  RESTORE, FILE = '/data2/ralf/FOR_CHELSEA/hysp_border.sav' ; HYSPLIT forward and back trajectory plume densities

  ;===========================================
  ; HYSPLIT Back Trajectory Density Plot
      B24 = HYSP.B24 ; can subsitute this for b48, b72, b96, f24, f48 to get the other forward and backward trajectory density plots
      B24[WHERE(B24[*,*,*] EQ 0)] = !VALUES.F_NAN ; remove invalid data
      ANB24 = ANNUAL2(B24) ; find the annual average
  
      ;24 HOURS
      MYWINDOW = WINDOW(WINDOW_TITLE='24 HOURS')
      MONTHS = ['JAN','FEB','MAR','APR','MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC']
      FOR II = 0, 11 DO BEGIN
        LAYOUTT = [4,3,[II+1]]
        TTT = MONTHS[II]
        IMG = IMAGE(ANB24[*,*,II], /CURRENT, LAYOUT = LAYOUTT,$
          LIMIT=[0,50,50,120],  RGB_TABLE=62, GRID_UNITS=2, XRANGE=[50,120], YRANGE=[0,50],$
          IMAGE_LOCATION=[-180,-90], IMAGE_DIMENSIONS=[360,180], AXIS_STYLE = 2, TITLE = TTT, FONT_NAME = 'ARIAL', MARGIN = 0.1)
        M = MAPCONTINENTS(/COUNTRIES, /HIRES, THICK = 1)
        IMG.FONT_NAME = 'ARIAL'
        IMG.TITLE.FONT_SIZE = 24
        IMG.TITLE.FONT_STYLE = "BOLD"
        IMG.BACKGROUND_TRANSPARENCY = 0
        IMG.FONT_SIZE = 18
      ENDFOR

  ;===========================================
  ; HYSPLIT Residence Time Plot
  TICKV = julday(1,1,[2003:2015])
  XRANGE = [julday(1,1,2003), julday(1,1,2015)]
  YRANGE=[10,40]
  img = plot(julday(hysp.month, 15, hysp.year), hysp.t_res, LAYOUT = [1,1,1],  '2', color= clr[*,2], XTICKUNITS = 'Month', XTICKINTERVAL = 6, XRANGE = XRANGE, YRANGE=YRANGE, XMinor = 5, name = 'AIRS', Title = 'CH$_4$ Residence Time',  YTITLE = "Time, h",Position = [0.06,0.25,0.75,0.7])
  img2 = plot([TICKV[0]-30,TICKV[-1]+30], [mean(hysp.t_res),mean(hysp.t_res)], '-2', COLOR = 'light grey', /overplot)
  xaxis = AXIS('X', TARGET = img,Location = 6.5, TICKV = TICKV, TICKUNITS = 'YEARS', Minor = 11,  TICKLEN = 0.01, SUBTICKLEN = 0.008)
  !null = plot_font(img, 1, YRANGE)

  ;===========================================
  ; AIRS Regions (AIRS XCH4 x HYSPLIT density), find the XCH4 increase over Bangladesh by weighting by the plume density. See equation 1 in text. 
  asd = FLTARR(7,144)
  asd[0,*] = TOTAL(TOTAL((airs.dat*hysp.b96),1),1)
  asd[1,*] = TOTAL(TOTAL((airs.dat*hysp.b72),1),1)
  asd[2,*] = TOTAL(TOTAL((airs.dat*hysp.b48),1),1)
  asd[3,*] = TOTAL(TOTAL((airs.dat*hysp.b24),1),1)
  asd[4,*] = TOTAL(TOTAL((airs.dat*hysp.b00),1),1)
  asd[5,*] = TOTAL(TOTAL((airs.dat*hysp.f24),1),1)
  asd[6,*] = TOTAL(TOTAL((airs.dat*hysp.f48),1),1)

  reg_airs=FLTARR(144)
  reg_airs2=FLTARR(144)
  FOR i=0,143 DO BEGIN
    ;reg_airs[i]=REGRESS(FINDGEN(5)*24-48,REFORM(asd[2:*,i])) ; dppb/dhr ; regression slope over +/- 48 hrs...
    reg_airs[i]=REFORM(asd[5,i]-asd[3,i])/48                 ; or maybe (b24-f24) / 48
  ENDFOR

  ; monthly mean concentration increase over Bangladesh
  rm_airs=MEAN(dim=2,REFORM(reg_airs,12,12))

  ;===========================================
  ; SCIAMACHY Regions (SCIAMACHY XCH4 x HYSPLIT density)
  ; need to watch out for missing data and rescale the weights accordingly
  asd   = FLTARR(7,144)
  iok   = (scia.dat GT 0)*1000.
  asd[0,*] = TOTAL(TOTAL((iok*scia.dat*hysp.b96),1),1) / (TOTAL(TOTAL((iok*hysp.b96),1),1)>1)
  asd[1,*] = TOTAL(TOTAL((iok*scia.dat*hysp.b72),1),1) / (TOTAL(TOTAL((iok*hysp.b72),1),1)>1)
  asd[2,*] = TOTAL(TOTAL((iok*scia.dat*hysp.b48),1),1) / (TOTAL(TOTAL((iok*hysp.b48),1),1)>1)
  asd[3,*] = TOTAL(TOTAL((iok*scia.dat*hysp.b24),1),1) / (TOTAL(TOTAL((iok*hysp.b24),1),1)>1)
  asd[4,*] = TOTAL(TOTAL((iok*scia.dat*hysp.b00),1),1) / (TOTAL(TOTAL((iok*hysp.b00),1),1)>1)
  asd[5,*] = TOTAL(TOTAL((iok*scia.dat*hysp.f24),1),1) / (TOTAL(TOTAL((iok*hysp.f24),1),1)>1)
  asd[6,*] = TOTAL(TOTAL((iok*scia.dat*hysp.f48),1),1) / (TOTAL(TOTAL((iok*hysp.f48),1),1)>1)

  reg_scia=FLTARR(144)
  FOR i=0,143 DO BEGIN
    IF MIN(asd[2:*,i]) EQ 0 THEN CONTINUE
    ;reg_scia[i]=REGRESS(FINDGEN(5)*24-48,REFORM(asd[2:*,i])) ; dppb/dhr  ; regression slope over +/- 48 hrs...
    reg_scia[i]=REFORM(asd[5,i]-asd[3,i])/48                             ; or maybe (b24-f24) / 48
  ENDFOR

  ;only 9 full years of SCIA, monthly mean concentration increase over Bangladesh
  rm_scia=MEAN(dim=2,REFORM(reg_scia[0:107],12,9))

  ;===========================================
  ; GOSAT Regions (GOSAT XCH4 x HYSPLIT density)
  ; need to watch out for missing data and rescale the weights accordingly
  asd   = FLTARR(7,144)
  iok   = (gosa.dat GT 0)*1000.
  asd[0,*] = TOTAL(TOTAL((iok*gosa.dat*hysp.b96),1),1) / (TOTAL(TOTAL((iok*hysp.b96),1),1)>1)
  asd[1,*] = TOTAL(TOTAL((iok*gosa.dat*hysp.b72),1),1) / (TOTAL(TOTAL((iok*hysp.b72),1),1)>1)
  asd[2,*] = TOTAL(TOTAL((iok*gosa.dat*hysp.b48),1),1) / (TOTAL(TOTAL((iok*hysp.b48),1),1)>1)
  asd[3,*] = TOTAL(TOTAL((iok*gosa.dat*hysp.b24),1),1) / (TOTAL(TOTAL((iok*hysp.b24),1),1)>1)
  asd[4,*] = TOTAL(TOTAL((iok*gosa.dat*hysp.b00),1),1) / (TOTAL(TOTAL((iok*hysp.b00),1),1)>1)
  asd[5,*] = TOTAL(TOTAL((iok*gosa.dat*hysp.f24),1),1) / (TOTAL(TOTAL((iok*hysp.f24),1),1)>1)
  asd[6,*] = TOTAL(TOTAL((iok*gosa.dat*hysp.f48),1),1) / (TOTAL(TOTAL((iok*hysp.f48),1),1)>1)

  reg_gosa=FLTARR(144)
  FOR i=0,143 DO BEGIN
    IF MIN(asd[2:*,i]) EQ 0 THEN CONTINUE
    ;reg_gosa[i]=REGRESS(FINDGEN(5)*24-48,REFORM(asd[2:*,i])) ; dppb/dhr  ; regression slope over +/- 48 hrs...
    reg_gosa[i]=REFORM(asd[5,i]-asd[3,i])/48                             ; or maybe (b24-f24) / 48?
  ENDFOR

  ;only 2 full years of GOSAT, monthly mean concentration increase over Bangladesh
  rm_gosa=MEAN(dim=2,REFORM(reg_gosa[84:84+23],12,2));77 to 131

  ;===========================================
  ;CarbonTracker CH4 MoleFractions
  RESTORE, FILE = "CarbonTracker_Mole_Fraction_data.sav" ;Monthly averaged CarbonTracker Mole Fractions

  ;===========================================
  ; CarbonTracker Regions (CarbonTracker XCH4 x HYSPLIT density)
  ; need to watch out for missing data and rescale the weights accordingly
  asd   = FLTARR(7,96)
  iok   = (CT GT 0)*1000.
  asd[0,*] = TOTAL(TOTAL((iok*CT*hysp.b96),1),1) / (TOTAL(TOTAL((iok*hysp.b96),1),1)>1)
  asd[1,*] = TOTAL(TOTAL((iok*CT*hysp.b72),1),1) / (TOTAL(TOTAL((iok*hysp.b72),1),1)>1)
  asd[2,*] = TOTAL(TOTAL((iok*CT*hysp.b48),1),1) / (TOTAL(TOTAL((iok*hysp.b48),1),1)>1)
  asd[3,*] = TOTAL(TOTAL((iok*CT*hysp.b24),1),1) / (TOTAL(TOTAL((iok*hysp.b24),1),1)>1)
  asd[4,*] = TOTAL(TOTAL((iok*CT*hysp.b00),1),1) / (TOTAL(TOTAL((iok*hysp.b00),1),1)>1)
  asd[5,*] = TOTAL(TOTAL((iok*CT*hysp.f24),1),1) / (TOTAL(TOTAL((iok*hysp.f24),1),1)>1)
  asd[6,*] = TOTAL(TOTAL((iok*CT*hysp.f48),1),1) / (TOTAL(TOTAL((iok*hysp.f48),1),1)>1)

  reg_CT=FLTARR(96)
  FOR i=0,95 DO BEGIN
    IF MIN(asd[2:*,i]) EQ 0 THEN CONTINUE
    ; reg_CT[i]=REGRESS(FINDGEN(5)*24-48,REFORM(asd[2:*,i])) ; dppb/dhr  ; regression slope over +/- 48 hrs...
    reg_CT[i]=REFORM(asd[5,i]-asd[3,i])/48                             ; or maybe (b24-f24) / 48?
  ENDFOR

  ;only 8 full years of CarbonTracker, monthly mean concentration increase over Bangladesh
  rm_CT=MEAN(dim=2,REFORM(reg_CT,12,8))

  ;===========================================
  ; plot mean annual concentration increase over Bangladesh
  reg_scia[where(reg_scia EQ 0.0)] =  !values.F_NAN
  reg_airs[where(reg_airs EQ 0.0)] =  !values.F_NAN
  reg_gosa[where(reg_gosa EQ 0.0)] =  !values.F_NAN
  reg_CT[where(reg_CT EQ 0.0)]     =  !values.F_NAN

  TICKV =  TIMEGEN(12, START = Julday(1, 15, 2003), DAYS = [15])
  XTICKV =  TIMEGEN(3, START = Julday(1, 1, 2003), DAYS = [1], UNITS='Months', STEP_SIZE=6)
  XRANGE = [julday(1,1,2003), julday(12,31,2003)]
  YRANGE=[-10,35]
  img4 = plot([tickv[0]-15, tickv[-1]+15], [0,0], '2', color = 'gray', Position = [0.79,0.25,0.9,0.7])
  img = plot(tickv, rm_scia*hysp.t_res, '2', color= clr[*,8], /overplot, XTICKV = XTICKV, YTICKFORMAT="(A1)", XMinor = 1, XTICKUNITS = 'Month', XTICKINTERVAL = 1, XRANGE = XRANGE, YRANGE = YRANGE, name = 'SCIAMACHY', Ytitle = " ", TITLE = ' ') ; concentration increase over Bangladesh ppb
  img2 = plot(tickv, rm_airs*hysp.t_res,'2', color= clr[*,3],  /overplot , name = 'AIRS' ); concentration increase over Bangladesh ppb
  img3 = plot(tickv, rm_gosa*hysp.t_res,'2', color= clr[*,6], /overplot , name = 'GOSAT' ); concentration increase over Bangladesh ppb
  ;img5 = plot(tickv, rm_CT*hysp.t_res, '2', color= clr[*,4], /overplot, XTICKV = XTICKV, XMinor = 1, XTICKUNITS = 'Month', XTICKINTERVAL = 1, XRANGE = XRANGE, YRANGE = YRANGE, name = 'CarbonTracker', Ytitle = " ", TITLE = ' ') ; concentration increase over Bangladesh ppb
  !null = plot_font(img, 1, YRANGE)
  ;!null = legend(target=[img2,img, img3, img5], font_size = 18, font_name = 'Arial',/AUTO_TEXT_COLOR, shadow = 0, POSITION=[tickv[10],-1], /DATA)

  ; ===========================================
  ;plot mean concentration increase over Bangladesh
  TICKV = julday(1,1,[2003:2015])
  XRANGE = [julday(1,1,2003), julday(1,1,2015)]
  YRANGE=[-10,35]
  abcd = -15
  img4 = plot([t[0]-15, t[-1]+15], [0.0,0.0], '2', color = 'gray', /CURRENT, Position = [0.1,0.25,0.75,0.7])
  img = plot(scia.jul, reg_scia*hysp.t_res, /overplot, '2', color= clr[*,8],  XTICKUNITS = 'Month', Ytitle = "CH$_4$, ppb", XTICKINTERVAL = 6, XRANGE = XRANGE, YRANGE=YRANGE, XMinor = 5, name = 'SCIAMACHY', TITLE = 'Bangladesh XCH$_4$ Increase')  ; concentration increase over Bangladesh ppb
  img2 = plot(airs.jul, reg_airs*hysp.t_res, '2', color= clr[*,3],  /overplot, name = 'AIRS'); uptake over bangla in ppb
  ;img2s = plot(t, reg_airs2*hysp.t_res, '3b',co=240,THICK=2, /overplot, name = 'AIRS'); concentration increase over Bangladesh ppb
  img3 = plot(gosa.jul, reg_gosa*hysp.t_res, '2', color= clr[*,6],/overplot, name = 'GOSAT'); concentration increase over Bangladesh ppb
  ;img5 = plot(CT_time, reg_CT*hysp.t_res, /overplot, '2', color= clr[*,4], XTICKUNITS = 'Month', Ytitle = "CH$_4$, ppb", XTICKINTERVAL = 6, XRANGE = XRANGE, YRANGE=YRANGE, XMinor = 5, name = 'CarbonTracker', TITLE = 'Bangladesh XCH$_4$ Increase')  ; concentration increase over Bangladesh ppb
  xaxis = AXIS('X', TARGET = img, Location = abcd, TICKV = TICKV, TICKUNITS = 'YEARS', Minor = 11,  TICKLEN = 0.01, SUBTICKLEN = 0.008)
  !null = plot_font(img, 1, YRANGE)
  !null = legend(target=[img2,img,img3], font_size = 18, font_name = 'Arial',/AUTO_TEXT_COLOR, shadow = 0, POSITION=[tickv[12],-5], /DATA)


  ;===========================================
  ; plot smoothed versions of above using a 3 month moving average
  airs_smooth = smooth(reg_airs*hysp.t_res, 3, /nan)
  rm_airs_smooth =MEAN(dim=2,REFORM(airs_smooth,12,12))
  scia_smooth = smooth(reg_scia*hysp.t_res, 3, /nan)
  rm_scia_smooth =MEAN(dim=2,REFORM(scia_smooth[0:107],12,9))
  gosa_smooth = smooth(reg_gosa*hysp.t_res, 3, /nan)
  rm_gosa_smooth =MEAN(dim=2,REFORM(gosa_smooth[84:84+23],12,2));77 to 131
  CT_smooth = smooth(reg_CT*hysp.t_res, 3, /nan)
  rm_CT_smooth =MEAN(dim=2,REFORM(CT_smooth,12,8))

  TICKV =  TIMEGEN(12, START = Julday(1, 15, 2003), DAYS = [15])
  XTICKV =  TIMEGEN(3, START = Julday(1, 1, 2003), DAYS = [1], UNITS='Months', STEP_SIZE=6)
  XRANGE = [julday(1,1,2003), julday(12,31,2003)]
  img4 = plot([tickv[0]-15, tickv[-1]+15], [0,0], '2', color = 'gray', YTICKFORMAT="(A1)", Position = [0.79,0.25,0.9,0.7])
  img = plot(tickv, rm_scia_smooth, '2', color= clr[*,8], /overplot, XTICKV = XTICKV, XMinor = 1, XTICKUNITS = 'Month', XTICKINTERVAL = 1, XRANGE = XRANGE, YRANGE = YRANGE, name = 'SCIAMACHY', Ytitle = " ", TITLE = ' ') ; concentration increase over Bangladesh ppb
  img2 = plot(tickv, rm_airs_smooth,'2', color= clr[*,3],  /overplot , name = 'AIRS' ); concentration increase over Bangladesh ppb
  img3 = plot(tickv, rm_gosa_smooth,'2', color= clr[*,6], /overplot , name = 'GOSAT' ); concentration increase over Bangladesh ppb
  ; img5 = plot(tickv, rm_CT_smooth, '2', color= clr[*,4], /overplot, XTICKV = XTICKV, XMinor = 1, XTICKUNITS = 'Month', XTICKINTERVAL = 1, XRANGE = XRANGE, YRANGE = YRANGE, name = 'CarbonTracker', Ytitle = " ", TITLE = ' ') ; concentration increase over Bangladesh ppb
  !null = plot_font(img, 1, YRANGE)

  TICKV = julday(1,1,[2003:2015])
  XRANGE = [julday(1,1,2003), julday(1,1,2015)]
  img4 = plot([t[0]-15, t[-1]+15], [0.0,0.0], '2', color = 'gray', /CURRENT, Position = [0.1,0.25,0.75,0.7])
  img = plot(scia.jul, scia_smooth, /overplot, '2', color= clr[*,8],  XTICKUNITS = 'Month', Ytitle = "CH$_4$, ppb", XTICKINTERVAL = 6, XRANGE = XRANGE, YRANGE=YRANGE, XMinor = 5, name = 'SCIAMACHY', TITLE = 'Bangladesh XCH$_4$ Increase')  ; concentration increase over Bangladesh ppb
  img2 = plot(airs.jul, airs_smooth, '2', color= clr[*,3],  /overplot, name = 'AIRS'); uptake over bangla in ppb
  img3 = plot(gosa.jul, gosa_smooth, '2', color= clr[*,6],/overplot, name = 'GOSAT'); concentration increase over Bangladesh ppb
  ; img5 = plot(CT_time, CT_smooth, /overplot, '2', color= clr[*,4], XTICKUNITS = 'Month', Ytitle = "CH$_4$, ppb", XTICKINTERVAL = 6, XRANGE = XRANGE, YRANGE=YRANGE, XMinor = 5, name = 'CarbonTracker', TITLE = 'Bangladesh XCH$_4$ Increase')  ; concentration increase over Bangladesh ppb
  xaxis = AXIS('X', TARGET = img, Location = abcd, TICKV = TICKV, TICKUNITS = 'YEARS', Minor = 11,  TICKLEN = 0.01, SUBTICKLEN = 0.008)
  !null = plot_font(img, 1, YRANGE)
  !null = legend(target=[img2,img,img3], font_size = 18, font_name = 'Arial',/AUTO_TEXT_COLOR, shadow = 0, POSITION=[tickv[12],-5], /DATA)

  ;===========================================
  ;Plot Difference
  ;See ralf_all_data
  RESTORE, 'ralf_all_data.sav'

  a_dif_an = rm_airs_smooth;rm_airs*hysp.t_res
  s_dif_an = rm_scia_smooth;rm_scia*hysp.t_res
  g_dif_an = rm_gosa_smooth;rm_gosa*hysp.t_res
  c_dif_an = rm_CT_smooth;rm_CT*hysp.t_res
  ;===========================================
  ;Correlation between TRMM and emissions
  Ca = fltarr(30)
  Cs = fltarr(30)
  Cg = fltarr(30)
  Cc = fltarr(30)
  s_diff = scia_smooth; reg_scia*hysp.t_res
  a_diff = airs_smooth; reg_airs*hysp.t_res
  g_diff = gosa_smooth; reg_gosa*hysp.t_res
  c_diff = CT_smooth; reg_CT*hysp.t_res
  FOR i = 0, 29 DO BEGIN
    ioka = WHERE(FINITE(a_diff[*]) EQ 1)
    ioks = WHERE(FINITE(s_diff[*]) EQ 1)
    iokg = WHERE(FINITE(g_diff[*]) EQ 1)
    iokc = WHERE(FINITE(c_diff[*]) EQ 1)
    iok2a = WHERE(water_date GE t[ioka[0]] AND water_date LE t[ioka[-1]]+1)
    iok2s = WHERE(water_date GE t[ioks[0]] AND water_date LE t[ioks[-1]]+1)
    ;iok2g = WHERE(water_date GE t[iokg[0]] AND water_date LE t[iokg[-1]]+1)
    iok2c = WHERE(water_date GE t[iokc[0]] AND water_date LE t[iokc[-1]]+1)
    Ca[i] = correlate(water.LWF_delay[i,iok2a],a_diff[ioka])
    Cs[i] = correlate(water.LWF_delay[i,iok2s],s_diff[ioks])
    Cg[i] = correlate(water.LWF_delay[i,[[93:98],99,[103:111],[116:123],[128:130]]],g_diff[iokg])
    Cc[i] = correlate(water.LWF_delay[i,iok2c],c_diff[iokc])
  ENDFOR
  ;============================================================================================================================================================
  ;Plot Correlation Coefficients
  YRANGE = [-0.20, 0.50]
  XRANGE = [0, 120]
  print, 'Ca', max(Ca), 'Cs', max(Cs), 'Cg', max(Cg), 'Cc', max(Cc)
  img = plot(water.delay, Ca[*], '2', color= clr[*,3], LAYOUT = [1,2,1], YRANGE=YRANGE, TITLE = 'Correlation between LWF and XCH$4$',XRANGE = XRANGE, YTITLE = 'Correlation Coefficient', XTITLE = 'TRMM Delay, Days', NAME = 'AIRS')
  img1 = plot(water.delay, Cs[*], '2', color= clr[*,8], /overplot, /CURRENT,LAYOUT = [1,3,1], NAME = 'SCIAMACHY')
  img2 = plot(water.delay, Cg[*], '2', color= clr[*,6], /overplot, /CURRENT,LAYOUT = [1,3,1], NAME = 'GOSAT')
  ;img3 = plot(water.delay, Cc[*], '-2', /overplot, COLOR = 'black', /CURRENT,LAYOUT = [1,3,1], NAME = 'CarbonTracker')
  !null = legend(target=[img, img1, img2], font_size = 18, font_name = 'Arial',/AUTO_TEXT_COLOR, shadow = 0)
  !null = plot_font(img, 0,YRANGE)

  ;Amplitudes
  airs_amp = max(a_dif_an,  /NAN) - min(a_dif_an,  /NAN)
  scia_amp = max(s_dif_an,  /NAN) - min(s_dif_an,  /NAN)
  gosat_amp = max(g_dif_an, /NAN) - min(g_dif_an, /NAN)
  CT_amp = max(c_dif_an, /NAN) - min(c_dif_an, /NAN)

  ;Determine flux from Difference (Unsmoothed)
  ;  Flux_A = [5.22]     ; Groundbased flux, mg CH4 m-2 h-1...To convert to g/m^2/d multiply by 0.024
  ;  Flux_S = [7.7477]     ;123 if difference is positive, need to make flux larger
  ;  Flux_G = [12.7288]
  ;  Flux_C = [13.196]
  ;
  ;  OFlux_A = [0.348]     ; Groundbased flux, mg CH4 m-2 h-1...To convert to g/m^2/d multiply by 0.024
  ;  OFlux_S = [0.845]        ;123 if difference is positive, need to make flux larger
  ;  OFlux_G = [1.357]
  ;  OFlux_C = [1.562]

  ;Smoothed
  Flux_A = [4.1]     ; Groundbased flux, mg CH4 m-2 h-1...To convert to g/m^2/d multiply by 0.024
  Flux_S = [9.2]     ;123 if difference is positive, need to make flux larger
  Flux_G = [19.52]
  Flux_C = [13.05]

  OFlux_A = [-0.2]     ; Groundbased flux, mg CH4 m-2 h-1...To convert to g/m^2/d multiply by 0.024
  OFlux_S = [0.32]        ;123 if difference is positive, need to make flux larger
  OFlux_G = [1.8]
  OFlux_C = [1.058]
  ;=============================================================================================================
  ; Upscale ground-based fluxes using LWF
  RT = hysp.t_res/24.0 ; residence time, days
  ; Conversion constants
  mgkg = 0.000001     ; kg
  weight = 10000      ; atmospheric column, pressure, kg/m^2
  molair = 0.02897    ; molecular weight of air, kg/mol
  molCH4 = 0.01604    ; molecular weight of CH4, kg/mol

  error = sqrt((10/39)^2+(6/RT*24)^2+(100/1000)^2+(Water.LWF_DELAY *0.05/Water.LWF_DELAY)^2)
  i=0
  fullerror = mean(error[Where(CA[*] EQ max(CA[*])),*], /NAN)*mean(39 * mgkg * (RT*24) /weight * molair / molCH4 * 1000000000 * Water.LWF_DELAY[Where(CA[*] EQ max(CA[*])),*],/NAN)

  ;=============================================================================================================
  ; Step by step upscaling

  match_amp = fltarr(4)

  x_A = water_LWF_delay[Where(CA[*] EQ max(CA[*])),0:143]
  x_S = water_LWF_DELAY[Where(CS[*] EQ max(CS[*])),0:143]
  x_G = water_LWF_DELAY[Where(CG[*] EQ max(CG[*])),0:143]
  x_C = water_LWF_DELAY[Where(CC[*] EQ max(CC[*])),0:143]

  Output_A = Flux_A * mgkg * (RT*24) /weight * molair / molCH4 * 1000000000   ; ppb RT-1 m-2
  Output_S = Flux_S * mgkg * (RT*24) /weight * molair / molCH4 * 1000000000   ; ppb RT-1 m-2
  Output_G = Flux_G * mgkg * (RT*24) /weight * molair / molCH4 * 1000000000   ; ppb RT-1 m-2
  Output_C = Flux_C * mgkg * (RT*24) /weight * molair / molCH4 * 1000000000   ; ppb RT-1 m-2

  RESULT_A = Output_A # x_A[*]
  RESULT_S = Output_S # x_S[*]
  RESULT_G = Output_G # x_G[*]
  RESULT_C = Output_C # x_C[*]

  match_amp[0] = amplitude(Result_A[*])
  match_amp[ 1] = amplitude(Result_S[*])
  match_amp[ 2] = amplitude(Result_G[*])
  match_amp[ 3] = amplitude(Result_C[*])

  ;Other constant sources
  Other_A = OFlux_A * mgkg * (RT*24) /weight * molair / molCH4 * 1000000000   ; ppb RT-1 m-2
  Other_S = OFlux_S* mgkg * (RT*24) /weight * molair / molCH4 * 1000000000   ; ppb RT-1 m-2
  Other_G = OFlux_G * mgkg * (RT*24) /weight * molair / molCH4 * 1000000000   ; ppb RT-1 m-2
  Other_C = OFlux_C * mgkg * (RT*24) /weight * molair / molCH4 * 1000000000   ; ppb RT-1 m-2
  ORESULT_A = Other_A
  ORESULT_S = Other_S
  ORESULT_G = Other_G
  ORESULT_C = Other_C

  diff_a2 = airs_amp - match_amp[0]
  diff_s2 = scia_amp - match_amp[1]
  diff_g2 = gosat_amp - match_amp[2]
  diff_c2 = CT_amp - match_amp[3]
  print, '  Difference AIRS', diff_a2, '  Difference SCIA', diff_s2, '  Difference Gosat', diff_g2, '  Difference CarbonTracker', diff_c2

  ;============================================================================================================================================================
  ; Vertical shift
  airs_mean= mean(a_diff, /nAN)
  scia_mean= mean(s_diff,  /nAN)
  gosat_mean= mean(g_diff,  /nAN)
  CT_mean= mean(c_diff,  /nAN)

  airs_gb_mean = [mean(result_A[0, *], /nAN)]
  scia_gb_mean = [mean(result_S[0, *], /nAN)]
  gosat_gb_mean = [mean(result_G[0, *], /nAN)]
  CT_gb_mean = [mean(result_C[0, *], /nAN)]

  a = airs_gb_mean - airs_mean
  s = scia_gb_mean - scia_mean
  g = gosat_gb_mean - gosat_mean
  c = CT_gb_mean - CT_mean

  print, 'Negative means make smaller', a-mean(ORESULT_A)
  print, 'Negative means make smaller', s-mean(ORESULT_S)
  print, 'Negative means make smaller', g-mean(ORESULT_G)
  print, 'Negative means make smaller', c-mean(ORESULT_C)
  STOP
  ;============================================================================================================================================================
  ;plot ALL
  TICKV = julday(1,1,[2003:2015])
  XRANGE = [julday(1,1,2003), julday(1,1,2015)]
  YRANGE=[-10,20]
  xy = -17
  xcv = -5
  t = TIMEGEN(N_elements(s_diff), START=JULDAY(1,15,2003), Units = 'Months')

  img = plot([t[0],t[-1]], [0,0] ,LAYOUT = [1,3,1],  '-2', COLOR = 'light grey', XTICKUNITS = 'Month', XTICKINTERVAL = 6, XRANGE = XRANGE, YRANGE=YRANGE, XMinor = 5, name = 'AIRS Observation', Title = 'AIRS XCH$_4$ Increase',  YTITLE = "CH$_4$, ppb")
  img1q = plot(t, a_diff[*], /CURRENT, '-k2', /overplot, name = 'Derived Concentrations')
  img1aq = plot(water_date, result_A[0, *]-make_array(144, Value = a), /CURRENT, '-.k2', /overplot, name = 'AIME Concentrations') ; min(result[0,0, WHERE(finite(result[0,0, *]) EQ 1.0)])
  img1 = plot(t, a_diff[*], /CURRENT, '2', color= clr[*,3],  /overplot, name = 'AIRS Observation')
  img1a = plot(water_date, result_A[0, *]-make_array(144, Value = a), /CURRENT, '-.2', color= clr[*,3],  /overplot, name = 'Upscaled Flux via TRMM') ; min(result[0,0, WHERE(finite(result[0,0, *]) EQ 1.0)])
  xaxis = AXIS('X', TARGET = img,Location = xy, TICKV = TICKV, TICKUNITS = 'YEARS', Minor = 11,  TICKLEN = 0.01, SUBTICKLEN = 0.008)
  !null = plot_font(img, 1, YRANGE)
  str = string([flux_a, water.delay[Where(CA EQ max(CA))], a], FORMAT='(I2)')
  t1 = TEXT(julday(1,1,2011), xcv, 'Upscaled from '+ str[0] + ' mg CH$_4$ m$^{-2}$ h$^{-1}$, shifted '+ str[1]+' days and ' + str[2]+ ' ppb', Target = img, /DATA, FONT_SIZE = 18, FONT_NAME='Arial', FONT_COLOR = clr[*,3])

  img = plot([t[0],t[-1]], [0,0], /CURRENT, LAYOUT = [1,3,2],  '-2', COLOR = 'light grey', XTICKUNITS = 'Month', XTICKINTERVAL = 6, XRANGE = XRANGE, YRANGE=YRANGE, XMinor = 5, name = 'Bangladesh', Title = 'SCIAMACHY XCH$_4$ Increase',  YTITLE = "CH$_4$, ppb")
  img2 = plot(t, s_diff[*], '2', color= clr[*,8], /overplot ,/CURRENT, name = 'SCIAMACHY Derived Concentrations')
  img2a = plot(water_date, result_S[0, *]-make_array(144, Value = s), '-.2', color= clr[*,8],  /CURRENT,/overplot, name = 'AIME Concentrations')
  xaxis = AXIS('X', TARGET = img2a,Location = xy, TICKV = TICKV, TICKUNITS = 'YEARS', Minor = 11,  TICKLEN = 0.01, SUBTICKLEN = 0.008)
  !null = plot_font(img, 1, YRANGE)
  str = string([flux_s, water.delay[Where(CS EQ max(CS))], s], FORMAT='(I2)')
  t1 = TEXT(julday(1,1,2011), xcv, 'Upscaled from '+ str[0] + ' mg CH$_4$ m$^{-2}$ h$^{-1}$, shifted '+ str[1]+' days and -' + str[2]+ ' ppb', Target = img, /DATA, FONT_SIZE = 18, FONT_NAME='Arial', FONT_COLOR = clr[*,8])

  img = plot([t[0],t[-1]], [0,0], /CURRENT, LAYOUT = [1,3,3],  '-2', COLOR = 'light grey', XTICKUNITS = 'Month', XTICKINTERVAL = 6, XRANGE = XRANGE, YRANGE=YRANGE, XMinor = 5, name = 'Bangladesh', Title = 'GOSAT XCH$_4$ Increase',  YTITLE = "CH$_4$, ppb")
  img3 = plot(t, g_diff[*], /overplot ,/CURRENT, '2', color= clr[*,6],   name = 'GOSAT Derived Concentrations')
  img3a = plot(water_date, result_G[0, *]-make_array(144, Value = g), /CURRENT, '-.2', color= clr[*,6],  /overplot, name = 'AIME Concentrations')
  xaxis = AXIS('X', TARGET = img,Location = xy, TICKV = TICKV, TICKUNITS = 'YEARS', Minor = 11,  TICKLEN = 0.01, SUBTICKLEN = 0.008)
  !null = plot_font(img, 1, YRANGE)
  str = string([flux_g, water.delay[Where(CG EQ max(CG))], g], FORMAT='(I2)')
  t1 = TEXT(julday(1,1,2011), xcv, 'Upscaled from '+ str[0] + ' mg CH$_4$ m$^{-2}$ h$^{-1}$, shifted '+ str[1]+' days and -' + str[2]+ ' ppb', Target = img, /DATA, FONT_SIZE = 18, FONT_NAME='Arial', FONT_COLOR = clr[*,6])

  ;  img = plot([t[0],t[-1]], [0,0], /CURRENT, LAYOUT = [1,4,4],  '-2', COLOR = 'light grey', XTICKUNITS = 'Month', XTICKINTERVAL = 6, XRANGE = XRANGE, YRANGE=YRANGE, XMinor = 5, name = 'Bangladesh', Title = 'CarbonTracker $,  YTITLE = "CH$_4$, ppb")
  ;  img4 = plot(CT_time, c_diff[*], /overplot ,/CURRENT, '-2', COLOR = 'black',  name = 'CarbonTracker Derived Concentrations')
  ;  img4a = plot(water_date, result_C[0, *]-make_array(144, Value = c), /CURRENT, '-.2', COLOR = 'black', /overplot, name = 'AIME Concentrations')
  ;  xaxis = AXIS('X', TARGET = img,Location = xy, TICKV = TICKV, TICKUNITS = 'YEARS', Minor = 11,  TICKLEN = 0.01, SUBTICKLEN = 0.008)
  ;  !null = plot_font(img, 1, YRANGE)
  ;  str = string([flux_C, water.delay[Where(CC EQ max(CC))], C], FORMAT='(I3)')
  ;  t1 = TEXT(julday(1,1,2009), xcv, 'Upscaled from '+ str[0] + ' mg CH$_4$ m$^{-2}$ h$^{-1}$, shifted '+ str[1]+' days and -' + str[2]+ ' ppb', Target = img, /DATA, FONT_SIZE = 18, FONT_NAME='Arial', FONT_COLOR = 'black')
  !null = legend(target=[img1q, img1aq], font_size = 18, font_name = 'Arial', COLOR = 'black', shadow = 0)

  Mean_AIME = fltarr(4)
  Mean_AIME = [mean(result_A[0, *]-make_array(144, Value = a), /NAN),mean(result_S[0, *]-make_array(144, Value = s), /NAN), mean(result_G[0, *]-make_array(144, Value = g), /NAN), mean(result_C[0, *]-make_array(144, Value = c), /NAN)]
  print, Mean_AIME

  ;============================================================================================================================================================
  ;AIME error, delta f(t)
  f_A = result_A[0, *]-make_array(144, Value = a)
  f_S = result_S[0, *]-make_array(144, Value = s)
  f_G = result_G[0, *]-make_array(144, Value = g)
  d_F = 10
  d_chi_A = 0.05*x_A
  d_chi_S = 0.05*x_S
  d_chi_G = 0.05*x_G
  d_R = stddev(hysp.t_res)
  d_m = 100
  d_alpha = 10

  airs_aime_error = sqrt(f_A*sqrt((d_f/F_A)^2+(d_chi_A/X_A)^2+(d_r/hysp.T_res)^2+(d_m/10000)^2)^2) + sqrt(d_alpha^2)
  scia_aime_error = sqrt(f_S*sqrt((d_f/F_S)^2+(d_chi_S/X_S)^2+(d_r/hysp.T_res)^2+(d_m/10000)^2)^2) + sqrt(d_alpha^2)
  gosat_aime_error = sqrt(f_G*sqrt((d_f/F_G)^2+(d_chi_G/X_G)^2+(d_r/hysp.T_res)^2+(d_m/10000)^2)^2) + sqrt(d_alpha^2)

  TICKV = julday(1,1,[2003:2015])
  XRANGE = [julday(1,1,2003), julday(1,1,2015)]
  YRANGE=[-30,40]
  xy = -45
  xcv = -5
  t = TIMEGEN(N_elements(s_diff), START=JULDAY(1,15,2003), Units = 'Months')

  img = plot([t[0],t[-1]], [0,0] ,LAYOUT = [1,3,1],  '-2', COLOR = 'light grey', XTICKUNITS = 'Month', XTICKINTERVAL = 6, XRANGE = XRANGE, YRANGE=YRANGE, XMinor = 5, name = 'AIRS Observation', Title = 'AIRS XCH$_4$ Increase',  YTITLE = "CH$_4$, ppb")
  img1q = plot(water_date, f_A+AIrs_aime_error, /CURRENT, '-k2', /overplot, name = 'Error')
  img1aq = plot(water_date, f_A, /CURRENT, '-.k2', /overplot, name = 'AIME Concentrations') ; min(result[0,0, WHERE(finite(result[0,0, *]) EQ 1.0)])
  img1 = plot(water_date, f_A+airs_aime_error, /CURRENT, '2', color= clr[*,3],  /overplot, name = 'AIRS Observation')
  img11 = plot(water_date, f_A-airs_aime_error, /CURRENT, '2', color= clr[*,3],  /overplot, name = 'AIRS Observation')
  img1a = plot(water_date, f_A, /CURRENT, '-.2', color= clr[*,3],  /overplot, name = 'Upscaled Flux via TRMM') ; min(result[0,0, WHERE(finite(result[0,0, *]) EQ 1.0)])
  xaxis = AXIS('X', TARGET = img,Location = xy, TICKV = TICKV, TICKUNITS = 'YEARS', Minor = 11,  TICKLEN = 0.01, SUBTICKLEN = 0.008)
  !null = plot_font(img, 1, YRANGE)
  ; str = string([flux_a, water.delay[Where(CA EQ max(CA))], a], FORMAT='(I2)')
  ;t1 = TEXT(julday(1,1,2011), xcv, 'Upscaled from '+ str[0] + ' mg CH$_4$ m$^{-2}$ h$^{-1}$, shifted '+ str[1]+' days and ' + str[2]+ ' ppb', Target = img, /DATA, FONT_SIZE = 18, FONT_NAME='Arial', FONT_COLOR = clr[*,3])

  img = plot([t[0],t[-1]], [0,0], /CURRENT, LAYOUT = [1,3,2],  '-2', COLOR = 'light grey', XTICKUNITS = 'Month', XTICKINTERVAL = 6, XRANGE = XRANGE, YRANGE=YRANGE, XMinor = 5, name = 'Bangladesh', Title = 'SCIAMACHY XCH$_4$ Increase',  YTITLE = "CH$_4$, ppb")
  img2 = plot(water_date, f_s+scia_aime_error, '2', color= clr[*,8], /overplot ,/CURRENT, name = 'SCIAMACHY Derived Concentrations')
  img22 = plot(water_date, f_s-scia_aime_error, '2', color= clr[*,8], /overplot ,/CURRENT, name = 'SCIAMACHY Derived Concentrations')
  img2a = plot(water_date, f_S, '-.2', color= clr[*,8],  /CURRENT,/overplot, name = 'AIME Concentrations')
  xaxis = AXIS('X', TARGET = img2a,Location = xy, TICKV = TICKV, TICKUNITS = 'YEARS', Minor = 11,  TICKLEN = 0.01, SUBTICKLEN = 0.008)
  !null = plot_font(img, 1, YRANGE)
  ;str = string([flux_s, water.delay[Where(CS EQ max(CS))], s], FORMAT='(I2)')
  ;t1 = TEXT(julday(1,1,2011), xcv, 'Upscaled from '+ str[0] + ' mg CH$_4$ m$^{-2}$ h$^{-1}$, shifted '+ str[1]+' days and -' + str[2]+ ' ppb', Target = img, /DATA, FONT_SIZE = 18, FONT_NAME='Arial', FONT_COLOR = clr[*,8])

  img = plot([t[0],t[-1]], [0,0], /CURRENT, LAYOUT = [1,3,3],  '-2', COLOR = 'light grey', XTICKUNITS = 'Month', XTICKINTERVAL = 6, XRANGE = XRANGE, YRANGE=YRANGE, XMinor = 5, name = 'Bangladesh', Title = 'GOSAT XCH$_4$ Increase',  YTITLE = "CH$_4$, ppb")
  img3 = plot(water_date, f_G+gosat_aime_error, /overplot ,/CURRENT, '2', color= clr[*,6],   name = 'GOSAT Derived Concentrations')
  img33 = plot(water_date, f_G-gosat_aime_error, /overplot ,/CURRENT, '2', color= clr[*,6],   name = 'GOSAT Derived Concentrations')
  img3a = plot(water_date, f_G, /CURRENT, '-.2', color= clr[*,6],  /overplot, name = 'AIME Concentrations')
  xaxis = AXIS('X', TARGET = img,Location = xy, TICKV = TICKV, TICKUNITS = 'YEARS', Minor = 11,  TICKLEN = 0.01, SUBTICKLEN = 0.008)
  !null = plot_font(img, 1, YRANGE)
  ;str = string([flux_g, water.delay[Where(CG EQ max(CG))], g], FORMAT='(I2)')
  ;t1 = TEXT(julday(1,1,2011), xcv, 'Upscaled from '+ str[0] + ' mg CH$_4$ m$^{-2}$ h$^{-1}$, shifted '+ str[1]+' days and -' + str[2]+ ' ppb', Target = img, /DATA, FONT_SIZE = 18, FONT_NAME='Arial', FONT_COLOR = clr[*,6])
  STOP
  ;============================================================================================================================================================
  ;plot carbontracker flux vs our calculated flux
  RESTORE, file = 'CarbonTrackerFlux.sav'
  TICKV = julday(1,1,[2003:2015])
  XRANGE = [julday(1,1,2003), julday(1,1,2015)]
  YRANGE=[0,8]
  xy = -0.6
  xcv = 7
  t = TIMEGEN(N_elements(aa), START=JULDAY(1,15,2003), Units = 'Months')

  img = plot([t[0],t[-1]], [0,0] ,LAYOUT = [1,1,1],  '-2', COLOR = 'light grey', XTICKUNITS = 'Month', XTICKINTERVAL = 6, XRANGE = XRANGE, YRANGE=YRANGE, XMinor = 5, name = 'Total Bangladesh Surface Flux', Title = 'Total Bangladesh Surface Flux',  YTITLE = "CH$_4$ Flux, mg CH$_4$ m$^{-2}$ h$^{-1}$")
  img1q = plot(juldayct, com, /CURRENT, '-k2', /overplot, name = 'CarbonTracker')
  img1a = plot(water_date,  flux_a ## x_A[*],  /CURRENT, '2', color= clr[*,3],  /overplot, name = 'AIRS Derived') ; min(result[0,0, WHERE(finite(result[0,0, *]) EQ 1.0)])
  img1s = plot(water_date,  flux_s ## x_S[*],  /CURRENT, '2', color= clr[*,8],  /overplot, name = 'SCIAMACHY Derived') ; min(result[0,0, WHERE(finite(result[0,0, *]) EQ 1.0)])
  img1g = plot(water_date,  flux_g ## x_G[*],  /CURRENT, '2', color= clr[*,6],  /overplot, name = 'GOSAT Derived') ; min(result[0,0, WHERE(finite(result[0,0, *]) EQ 1.0)])

  xaxis = AXIS('X', TARGET = img1a,Location = xy, TICKV = TICKV, TICKUNITS = 'YEARS', Minor = 11,  TICKLEN = 0.01, SUBTICKLEN = 0.008)
  !null = plot_font(img, 1, YRANGE)
  ;str = string([flux_a, flux_s, flux_g], FORMAT='(I2)')
  ;t1 = TEXT(julday(1,1,2010), xcv, 'Upscaled by inundation and fluxes of '+ str[0] + ', '+ str[1]+', and ' + str[2]+ ' mg CH$_4$ m$^{-2}$ h$^{-1}$', Target = img, /DATA, FONT_SIZE = 18, FONT_NAME='Arial', FONT_COLOR = 'black')
  !null = legend(target=[img1q, img1a, img1s, img1g], font_size = 18, font_name = 'Arial', COLOR = 'black', shadow = 0)




  STOP

END