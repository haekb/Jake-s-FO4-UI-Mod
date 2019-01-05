@echo off

echo Starting Setup!

set "dir=%cd%"

echo Creating shared directory links...
mklink /d "%dir%\Pipboy InvPage\Shared" "%dir%\Shared"
mklink /d "%dir%\PipboyMenu\Shared" "%dir%\Shared"
echo Creating scaleform directory links...
mklink /d "%dir%\Pipboy InvPage\scaleform" "%dir%\scaleform"
mklink /d "%dir%\PipboyMenu\scaleform" "%dir%\scaleform"

echo Finished Setup!
pause