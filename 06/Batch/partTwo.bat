echo off
setlocal EnableDelayedExpansion
set /A sw=0
set /A index=0
set /A count=0
for /F "delims=" %%a in (input.txt) do (
  set /A count=0
  set /A index=0
  for %%b in (%%a) do (
    if !count! EQU 0 (
      set /A count=1
    ) else (
      if !sw! EQU 0 (
        set /A timeText=!timeText!+%%b
      ) else (
        set /A distanceText=!distanceText!%%b
      )
    )
    set /A index=!index!+1
  )
  set /A sw=1
)
echo "!timeText! | !distanceText!"
set /A time[1]=!timeText!
set /A distance[1]=!distanceText!
set /A index=1
set /A s=1
for /l %%i in (1, 1, !index!) do (
  set /A count=0
  set /A "floorNumber=!time[%%i]!/2"
  set /A floorNumber=!floorNumber!
  set /A sum=0
  for /l %%j in (0, 1, !floorNumber!) do (
    set /A dis=!time[%%i]!-%%j
    set /A dis=!dis!*%%j
    if !dis! GTR !distance[%%i]! (
      set /A mod=!time[%%i]! %% 2
      echo "!time[%%i]! mod 2 = !mod!"
      if !mod! EQU 0 (
        set /A "asd=!time[%%i]! / 2"
        echo "!time[%%i]! / 2 = !asd!  | %%j"
        if %%j EQU !asd! (
          set /A sum=!sum!+1
        ) else (
          set /A sum=!sum!+2
        )
      ) else (
        set /A sum=!sum!+2
      )
    )
  )
  set /A s=!s!*!sum!
)
echo !s!

