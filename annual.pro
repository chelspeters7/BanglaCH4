FUNCTION annual, avetseries
;create average annual cycle from entire time series
nyears  = size(avetseries,/N_ELEMENTS)/12 ;Number of years
nmonths = size(avetseries,/N_ELEMENTS) ;Number of months

z = REFORM(avetseries, 12, nyears) ;Rearrange for convenience
zz = mean(z, dimension = 1, /NAN)
y = size(zz, /N_ELEMENTS)

zzz = fltarr(12,y)
FOR i = 0, y-1 DO BEGIN
  FOR j = 0, 12-1 DO BEGIN
    zzz[j,i] = z[j,i] ;- zz[i]
  ENDFOR
ENDFOR
zave = mean(zzz, dimension=2, /NAN)
return, zave
END