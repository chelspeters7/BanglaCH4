FUNCTION amplitude, array

  a = max(annual(array), /NAN)- min(annual(array), /NAN)
 
  RETURN, a
END