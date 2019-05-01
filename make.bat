@ECHO ON
del EoD.love
set path="D:\Program Files\WinRAR"
winrar a -afzip -x.git* -x*\.git -x*\.git\* -r EoD.love *.*
EoD.love