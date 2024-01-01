@ECHO ON
del EoD.love
set path="C:\Program Files\WinRAR"
winrar a -afzip -x.git* -x*\.git -x*\.git\* -x*.bat -x*.db -r EoD.love *.*
copy EoD.love C:\Users\youge\Desktop\EoD
copy EoD.db C:\Users\youge\Desktop\EoD
C:
cd \Users\youge\Desktop\EoD
EoD.love