pro test1
catch, Error_status
if Error_status ne 0 then begin
   print, 'Error in test1.pro'
   print, 'Error index: ', Error_status
   print, 'Error message: ', !ERROR_STATE.MSG
   exit, status=1
endif
go=strarr(1)
args=command_line_args()
data_file=args[0]
out_file=args[1]
yesno=args[2]
readcol,data_file,x,y,format='d,d'
y=x^2+1
openw,lun,out_file,/get_lun
for i=0,n_elements(x)-1 do printf,lun,x[i],y[i],format='(2(D10.3))'
close,lun
free_lun,lun
if yesno eq '1' then begin  
set_plot,'ps'
device,file="test1.eps",/encapsulated,/inches,xs=8,ys=7,xoffset=0.5,yoffset=1.5
plot,x,y,ps=1
device,/close
endif else begin
exit,status=2
endelse
end
end
