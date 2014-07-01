pro weinberg

args = command_line_args()
radec_file     = args[0]
distances_file = args[1]
output_file    = args[2]

readcol,radec_file,ra,dec,format='D,D'
ra0=79.275  ;center of the lmc
dec0=-69.017
d=ra-ra0
ra0r=ra0*!dtor
dec0r=dec0*!dtor
rar=ra*!dtor
decr=dec*!dtor
dr=d*!dtor
readcol,distances_file,name,distanceV,distanceI,format='A,D,D'
distance=distanceI
distance0=49.97 ; distance to LMC
x=-distance*cos(decr)*sin(dr)
y=distance*sin(decr)*cos(dec0r)-distance*cos(decr)*sin(dec0r)*cos(dr)
z=distance0-distance*cos(decr)*cos(dec0r)*cos(dr)-distance*sin(decr)*sin(dec0r)
openw,lun,output_file,/get_lun
for i=0,n_elements(ra)-1 do printf,lun,x[i],y[i],z[i],$
format='(3(D10.3,X))'
close,lun
free_lun,lun
;print,distance
end

end
