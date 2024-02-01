@ECHO OFF
FOR /F "tokens=*" %%i in ('type .env') do setx %%i