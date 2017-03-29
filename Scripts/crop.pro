FUNCTION crop, n

 restore,'/data2/ralf/latlon.sav'

 ;ilon = WHERE(lon[*,0] GE 89 AND lon[*,0] LE 91) 
 ;ilat = WHERE(lat[0,*] GE 23 AND lat[0,*] LE 25)
 ilon = WHERE(lon[*,0] GE 87 AND lon[*,0] LE 92)
ilat = WHERE(lat[0,*] GE 22 AND lat[0,*] LE 26)

  a = n[ilon,ilat,*]
  a[where(a[*,*,*] EQ 0)] = !values.F_NAN
  
  RETURN, a
END