pro ellipsoid

catch, Error_status

if Error_status ne 0 then begin
   print, 'Error in ellipsoid.pro'
   print, 'Error index: ', Error_status
   print, 'Error message: ', !ERROR_STATE.MSG
   exit, status=1
endif

args = command_line_args()
cartesian_file = args[0]
output_file =args[1]

readcol,cartesian_file,x,y,z,format='D,D,D'
n=n_elements(x)
xcm=total(x)/n
ycm=total(y)/n
zcm=total(z)/n
print,xcm,ycm,zcm
sumxx=(total((x-xcm)^2))/n
sumyy=(total((y-ycm)^2))/n
sumzz=(total((z-zcm)^2))/n
sumxy=(total((x-xcm)*(y-ycm)))/n
sumxz=(total((x-xcm)*(z-zcm)))/n
sumyz=(total((y-ycm)*(z-zcm)))/n
ixx=sumyy+sumzz; Diagonal Terms
iyy=sumxx+sumzz
izz=sumxx+sumyy
ixy=-sumxy     ;Off-diagonal Terms
ixz=-sumxz
iyz=-sumyz
matrix=fltarr(3,3);Inertia tensor in matrix form
tri=fltarr(3)	  ;Variable to put eigenvalues in
e=fltarr(3)	  ;scratch variable for TRIRED
ev=fltarr(3,3)    ;Variables to put eigenvalues
matrix(0,0)=ixx
matrix(1,1)=iyy
matrix(2,2)=izz
matrix(0,1)=ixy
matrix(0,2)=ixz
matrix(1,2)=iyz
matrix(1,0)=ixy
matrix(2,0)=ixz
matrix(2,1)=iyz
print,matrix
evecs=fltarr(3,3)
evals=eigenql(matrix,eigenvectors=evecs,/double)
semimajor=sqrt(evals[0])
semiminor=sqrt(evals[1])
semiinter=sqrt(evals[2])
openw,lun,output_file,/get_lun
printf,lun,'Eigenvalues are: '
printf,lun,evals
printf,lun,'Eigenvectors are: '
printf,lun,evecs
s0=sqrt(2.5*(evals[1]+evals[2]-evals[0]))
s1=sqrt(2.5*(evals[0]+evals[2]-evals[1]))
s2=sqrt(2.5*(evals[0]+evals[1]-evals[2]))
printf,lun,'Axes Lengths'
printf,lun,s0,s1,s2
printf,lun,'---------------------'
red=[0,1,1,0,0]
green=[0,1,0,1,0]
blue=[0,1,0,0,1]
tvlct,255*red,255*green,255*blue
evec1=evecs[*,0]
evec2=evecs[*,1]
evec3=evecs[*,2]
px1=evec1(0)*s0
py1=evec1(1)*s0
pz1=evec1(2)*s0
;plot,x,y,ps=1
;plots,[xcm,xcm],[ycm,ycm],ps=sym(1),color=3,symsize=2
semmin=sqrt(px1^2+py1^2+pz1^2)
;oplot,xcm+[-px1,px1],ycm+[-py1,py1],thick=2,color=2
px2=evec2(0)*s1
py2=evec2(1)*s1
pz2=evec2(2)*s1
px3=evec3(0)*s2
py3=evec3(1)*s2
pz3=evec3(2)*s2
;oplot,xcm+[-px2,px2],ycm+[-py2,py2],thick=2,color=2
;oplot,xcm+[-px2,px2],zcm+[-pz2,pz2],thick=2,color=2
semmint=sqrt(px2^2+py2^2+pz2^2)
semmaj=sqrt(px3^2+py3^2+pz3^2)
theta=(atan(evec1[1],evec1[0])*!radeg)
printf,lun,"Theta = ",theta
incl=180-acos(evec2[0]/evec1[1])*!radeg
printf,lun,"Incl = ",incl
Npoints = 200
printf,lun,'Axis Ratio:'
printf,lun,s0/s0,s1/s0,s2/s0
end
