pro test2
compile_opt idl2
on_error,2
catch, Error_status
if Error_status ne 0 then begin
   catch,/cancel
   print, 'Error in test1.pro'
   print, 'Error index: ', Error_status
   print, 'Error message: ', !ERROR_STATE.MSG
   void=error_message()
   return 	
;   exit, status=1
endif
go=strarr(1)
args=command_line_args()
outfile=args[0]
lsfile=args[1]
readcol,outfile,x,y,format='d,d'
fit=linfit(x,y,yfit=yf)
print,fit
print,'Enter "y" to plot "n" to skip'
button=''
read,button,prompt='Enter the button: '
cmdlist=['y','n']
index=where(button eq cmdlist)
case index of 
0: begin
plot,x,y,ps=1
oplot,x,yf,color=cgcolor("red")
print,'Hit to continue'
readf,0,go
;wait,1
end
1:break
endcase
openw,lun,lsfile,/get_lun
printf,lun,'LSQ parameters are: '
printf,lun,fit
close,lun
free_lun,lun
end
