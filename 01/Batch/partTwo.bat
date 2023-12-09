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
set /A count=0
for /F "delims=" %%a in ('cmd /U /C type input.txt ^| find /V ""') do (
  set /A char+=1
  for %%i in (!line!) do if !char! equ !len[%%i]! call :EndOfLine
  set list[!count!]="%%a"
  set /A count=!count!+1
)

:EndOfLine
set /A count=!count!-1
set /A i1=1
set /A i2=2
set /A i3=3
set /A i4=4
for /l %%i in (0, 1, !count!) do (
  set /A textRemainCount=!count!-%%i
  if !textRemainCount! GEQ 4 (
    if !list[%%i]!=="t" (
      for /l %%j in (!i1!, 1, !i1!) do (
        if !list[%%j]!=="h" (
          for /l %%k in (!i2!, 1, !i2!) do (
            if !list[%%k]!=="r" (
              for /l %%l in (!i3!, 1, !i3!) do (
                if !list[%%l]!=="e" (
                  for /l %%m in (!i4!, 1, !i4!) do (
                    if !list[%%m]!=="e" (
                      if NOT defined first (
                        set /A "first=3"
                        )
                      set /A "second=3"
                    )
                  )
                  
                ) 
              )
            )
          )
        )
      )
    )
    if !list[%%i]!=="s" (
      for /l %%j in (!i1!, 1, !i1!) do (
        if !list[%%j]!=="e" (
          for /l %%k in (!i2!, 1, !i2!) do (
            if !list[%%k]!=="v" (
              for /l %%l in (!i3!, 1, !i3!) do (
                if !list[%%l]!=="e" (
                  for /l %%m in (!i4!, 1, !i4!) do (
                    if !list[%%m]!=="n" (
                      if NOT defined first (
                        set /A "first=7"
                        )
                      set /A "second=7"
                    )
                  )
                  
                ) 
              )
            )
          )
        )
      )
    )
    if !list[%%i]!=="e" (
      for /l %%j in (!i1!, 1, !i1!) do (
        if !list[%%j]!=="i" (
          for /l %%k in (!i2!, 1, !i2!) do (
            if !list[%%k]!=="g" (
              for /l %%l in (!i3!, 1, !i3!) do (
                if !list[%%l]!=="h" (
                  for /l %%m in (!i4!, 1, !i4!) do (
                    if !list[%%m]!=="t" (
                      if NOT defined first (
                        set /A "first=8"
                        )
                      set /A "second=8"
                    )
                  )
                ) 
              )
            )
          )
        )
      )
    )
  )
  if !textRemainCount! GEQ 3 (
    if !list[%%i]!=="f" (
      for /l %%j in (!i1!, 1, !i1!) do (
        if !list[%%j]!=="o" (
          for /l %%k in (!i2!, 1, !i2!) do (
            if !list[%%k]!=="u" (
              for /l %%l in (!i3!, 1, !i3!) do (
                if !list[%%l]!=="r" (
                  if NOT defined first (
                    set /A "first=4"
                  )
                  set /A "second=4"
                ) 
              )
            )
          )
        )
        if !list[%%j]!=="i" (
          for /l %%k in (!i2!, 1, !i2!) do (
            if !list[%%k]!=="v" (
              for /l %%l in (!i3!, 1, !i3!) do (
                if !list[%%l]!=="e" (
                  if NOT defined first (
                    set /A "first=5"
                  )
                  set /A "second=5"
                ) 
              )
            )
          )
        )
      )
    )
    if !list[%%i]!=="n" (
      for /l %%j in (!i1!, 1, !i1!) do (
        if !list[%%j]!=="i" (
          for /l %%k in (!i2!, 1, !i2!) do (
            if !list[%%k]!=="n" (
              for /l %%l in (!i3!, 1, !i3!) do (
                if !list[%%l]!=="e" (
                  if NOT defined first (
                    set /A "first=9"
                  )
                  set /A "second=9"
                ) 
              )
            )
          )
        )
      )
    )
  )
  if !textRemainCount! GEQ 2 (
    if !list[%%i]!=="o" (
      for /l %%j in (!i1!, 1, !i1!) do (
        if !list[%%j]!=="n" (
          for /l %%k in (!i2!, 1, !i2!) do (
            if !list[%%k]!=="e" (
              if NOT defined first (
                set /A "first=1"
              )
              set /A "second=1"
            )
          )
        )
      )
    )
    if !list[%%i]!=="t" (
      for /l %%j in (!i1!, 1, !i1!) do (
        if !list[%%j]!=="w" (
          for /l %%k in (!i2!, 1, !i2!) do (
            if !list[%%k]!=="o" (
              if NOT defined first (
                set /A "first=2"
              )
              set /A "second=2"
            )
          )
        )
      )
    )
    if !list[%%i]!=="s" (
      for /l %%j in (!i1!, 1, !i1!) do (
        if !list[%%j]!=="i" (
          for /l %%k in (!i2!, 1, !i2!) do (
            if !list[%%k]!=="x" (
              if NOT defined first (
                set /A "first=6"
              )
              set /A "second=6"
            )
          )
        )
      )
    )
  )
  SET "var="&for /f "delims=0123456789" %%d in (!list[%%i]!) do set var=%%d
  if NOT defined var (
    if NOT defined first (
      set /A "first=!list[%%i]!"
    )
    set /A "second=!list[%%i]!"
  )
  set /A i1=!i1!+1
  set /A i2=!i2!+1
  set /A i3=!i3!+1
  set /A i4=!i4!+1
)
set /A temp = !first!
set /A sum=!sum!+(!temp!*10)
set /A temp = !second!
set /A sum=!sum!+!temp!
set first=
set second=
set /A line+=1
if %char% equ !len[%line%]! goto EndOfLine
echo !sum!
set /A count=0
exit /B