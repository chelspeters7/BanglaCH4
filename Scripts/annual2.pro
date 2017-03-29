FUNCTION annual2, avetseries
  ;create average annual cycle from entire time series
  s = size(avetseries)
  nyears  = s[3]/12 ;Number of years
  nmonths = s[3] ;Number of months

  z = REFORM(avetseries, 360, 180, 12, nyears) ;Rearrange for convenience
  zz = mean(z, dimension = 3, /NAN)
;  y = size(zz)
;  y = y[3]
;
;  zzz = fltarr(360,180,12,y)
;  FOR i = 0, y-1 DO BEGIN
;    FOR j = 0, 12-1 DO BEGIN
;      zzz[*,*,j,i] = z[*,*,j,i] ;- zz[i]
;    ENDFOR
;  ENDFOR
;  zave = mean(zzz, dimension=2, /NAN)
  return, zz
END