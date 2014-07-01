pro raconvert

catch, Error_status

if Error_status ne 0 then begin
   print, 'Error in raconvert.pro'
   print, 'Error index: ', Error_status
   print, 'Error message: ', !ERROR_STATE.MSG
   exit, status=1
endif

args = command_line_args()
hours_file   = args[0]
output_radec = args[1]
output_galac = args[2]


readcol,hours_file,b,c,d,e,f,g,format='D,D,D,D,D,D'
;center of the lmc (5h17m6sec,-69deg1sec);kim et al. (1998);epoch 2000
ra0=(5.0+(17.0/60.0)+(6.0/3600.0))*15.0
dec0=-(69.0+(1.0/60.0))
print,ra0,dec0,format='("RA0 = ",D10.3,X,"Dec0=",D10.3)'
ra=(b+(c/60.0)+(d/3600.0))*15.0 ;RA in degree
dec=(abs(e)+(f/60.0)+(g/3600.00))*(e/abs(e)); Dec in degree
n=n_elements(ra)
openw,lun,output_radec,/get_lun
for i=0,n-1 do printf,lun,ra[i],dec[i],format='(D10.4,X,D10.4)'
close,lun
free_lun,lun
lon=fltarr(n_elements(b))
lat=fltarr(n_elements(b))
for i=0,n_elements(b)-1 do begin
glactc, ten(b[i],c[i],d[i]),ten(e[i],f[i],g[i]),2000,gl,gb,1
lon(i)=gl
lat(i)=gb
endfor
openw,lun,output_galac,lun,/get_lun
for i=0,n_elements(b)-1 do printf,lun,lon(i),lat(i),format='((2(D10.3,X)))'
close,lun
free_lun,lun
end

end
