@ECHO ON
del EoD.love
set path="D:\Program Files\WinRAR"
winrar a -afzip -x.git* -x*\.git -x*\.git\* -x*.bat -x*.db -r EoD.love *.*
copy EoD.love C:\Users\UG\Desktop\test
copy EoD.db C:\Users\UG\Desktop\test
C:
cd \Users\UG\Desktop\test
EoD.love