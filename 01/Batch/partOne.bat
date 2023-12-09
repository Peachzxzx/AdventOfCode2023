@echo off
@REM https://www.reddit.com/r/Batch/comments/pa4wv3/reading_a_text_file_character_by_character_with_a/
@REM https://stackoverflow.com/questions/17584282/how-to-check-if-a-parameter-or-variable-is-a-number-in-a-batch-script
@REM https://stackoverflow.com/questions/7219672/how-do-i-remove-a-cmd-variable
setlocal EnableDelayedExpansion
set /A sum=0
rem Get (accumulated) line lengths
rem IMPORTANT: the file *must* end in an empty line!
set /A "i=0, adj=-1"
for /F "skip=1 delims=:" %%a in ('findstr /O "^" input.txt') do (
  set /A i+=1, adj+=2
  set /A len[!i!]=%%a-adj
)

rem Merge characters and line lengths
set /A line=1, char=0
set first=
set second=
for /F "delims=" %%a in ('cmd /U /C type input.txt ^| find /V ""') do (
  set /A char+=1
  for %%i in (!line!) do if !char! equ !len[%%i]! call :EndOfLine
  SET "var="&for /f "delims=0123456789" %%i in ("%%a") do set var=%%i
  if NOT defined var (
    if NOT defined first (
      set /A "first=%%a"
    )
    set /A "second=%%a"
  )
)

:EndOfLine
if NOT defined second (
  set /A "first=%second%"
)
set /A temp = %first%
set /A sum=!sum!+(%temp%*10)
set /A temp = %second%
set /A sum=!sum!+%temp%
set first=
set second=
set /A line+=1
if %char% equ !len[%line%]! goto EndOfLine
echo !sum!
exit /B