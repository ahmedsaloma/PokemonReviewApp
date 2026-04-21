@echo off
echo Linking Physical Phone to Laptop Localhost (Port 5219)...
"D:\Android\sdk\platform-tools\adb.exe" reverse tcp:5219 tcp:5219
echo Done! You can now test the API on your phone.
pause
