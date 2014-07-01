pro ellipse_final

args = command_line_args()
cartesian_file = args[0]
ellipse_file = args[1]

set_plot,'ps'
!p.font=0
device,file=ellipse_file,/encapsulated,/inches,xs=8,ys=7,xoffset=0.5,$
yoffset=1.5,/color,set_font='Helvetica'
device,/helvetica,/bold
readcol,cartesian_file,x,y,z,format='D,D,D'
n=n_elements(x)
xcm=total(x)/n
ycm=total(y)/n
print,xcm,ycm
sumxx=(total((x-xcm)^2))/n
sumyy=(total((y-ycm)^2))/n
sumxy=(total((x-xcm)*(y-ycm)))/n
ixx=sumyy;Diagonal Terms
iyy=sumxx
ixy=sumxy     ;Off-diagonal Terms
red=[0,1,1,0,0]
green=[0,1,0,1,0]
blue=[0,1,0,0,1]
tvlct,255*red,255*green,255*blue
x=x-xcm
y=y-ycm
xcm=xcm-xcm
ycm=ycm-ycm
plot,x,y,ps=1,xrange=[min(x)-1,max(x)+1],/xst,xtitle='x [kpc]',$
ytitle='y [kpc]',thick=2,xthick=2,ythick=2,charsize=2,charthick=2,$
yrange=[-4,4],/yst
plots,[xcm,xcm],[ycm,ycm],ps=sym(1),color=3,symsize=2
plots,[ycm,ycm],[-4,4],thick=2,color=3
plots,[min(x)-1,max(x)+1],[ycm,ycm],thick=2,color=3
matrix=fltarr(2,2);Inertia tensor in matrix form
matrix(0,0)=ixx
matrix(1,1)=iyy
matrix(0,1)=ixy
matrix(1,0)=ixy
print,matrix
evecs=fltarr(2,2)
eval=eigenql(matrix,eigenvectors=evecs,/double)
print,'Eigenvalues'
print,eval
s1=where(eval eq min(eval))
s2=where(eval eq max(eval))
evecs1=evecs[s2,*]
evecs2=evecs[s1,*]
print,'Eigenvectors: '
print,evecs
;print,'Tansposed Eigenvectors: '
print,transpose(evecs)
;print,evecs1
;print,evecs2
px1=2.45*evecs2[0,s1]*sqrt(eval[s1])
py1=2.45*evecs2[0,s2]*sqrt(eval[s1])
oplot,xcm+[-px1,px1],ycm+[-py1,py1],color=2,thick=3;minor axis plot
arrow,0,0,px1,py1,/solid,/data,color=2
semmin=sqrt((px1)^2+(py1)^2)
print,'semmin='
print,semmin
print,'min='
print,2.0*semmin
px2=2.45*evecs1[0,s1]*sqrt(eval[s2])
py2=2.45*evecs1[0,s2]*sqrt(eval[s2])
oplot,xcm+[-px2,px2],ycm+[-py2,py2],color=2,thick=3;major axis plot
arrow,0,0,px2,py2,/solid,/data,color=2
semmaj=sqrt((px2)^2+(py2)^2)
print,'semmaj='
print,semmaj
print,'maj='
print,2.0*semmaj
;legend,[string('v1=',evecs1),string('v2=',evecs2)],pos=[-2,1]
theta_xp=(atan(evecs1[0,s2],evecs1[0,s1])*180./!pi);counter clockwise 
;from the axis 0<=theta_xp<=2pi
print,'Orientation Angle'
print,theta_xp
print,'Axis ratio:'
print,sqrt(eval[s2]/eval[s1])

ang=theta_xp*!pi/180.0
cosang = cos(ang)
sinang = sin(ang)
phi=2.0*!pi*(findgen(13493)/13492)
;print,phi
sa=[semmaj,semmin]
xr=sa[0]*cos(phi)
yr=sa[1]*sin(phi)
print,'# of xr',n_elements(xr)
oplot,xr,yr,color=3,thick=3
xpr=fltarr(n_elements(xr))
ypr=fltarr(n_elements(yr))
for i=0,n_elements(xr)-1 do begin
xpr[i]=xcm+(xr[i]*cosang)-(yr[i]*sinang)
ypr[i]=ycm+(xr[i]*sinang)+(yr[i]*cosang)
endfor
;item='!6 i[!U!M%!X!N] = '+strtrim(strmid(string(theta_xp),0,12),2)
;item=('!6 i = 24!U!M%!X!N.20')
item=('i = 73'+cgsymbol('deg')+'.70')
pos=[-4,3]
legend,item,pos=[-3,3.5],thick=2,charsize=2,charthick=2
oplot,xpr,ypr,color=2,thick=3
arrow,3.5,-2.8,3.5,-3.5,/data
xyouts,3.42, -3.8,'S',charthick=2,charsize=1.3
arrow,3.5,-2.8,3.5,-2.1,/data,thick=2
xyouts,3.4, -2.0,'N',charthick=2,charsize=1.3
arrow,3.5,-2.8,2.8,-2.8,/data,thick=2
xyouts,2.5, -2.85,'E',charthick=2,charsize=1.3
arrow,3.5,-2.8,4.2,-2.8,/data,thick=2
xyouts,4.3, -2.85,'W',charthick=2,charsize=1.3
plots,[3.5,3.5],[-2.8,-2.8],ps=sym(1),thick=2,/data
arrow,0,0,semmaj,0,/solid,/data,color=3
arrow,0,0,0,semmin,/solid,/data,color=3
device,/close
end

end
