@echo off
:loop

REM التحقق من تغييرات ملفات Dart وpubspec.yaml فقط
git diff --name-only -- '*.dart' 'pubspec.yaml' > temp.txt
setlocal enabledelayedexpansion
set "changes="
for /f "delims=" %%f in (temp.txt) do (
    set "changes=!changes! %%f"
)

if not "!changes!"=="" (
    REM أضف الملفات المعدلة فقط
    git add .

    REM تجاهل الملفات غير المهمة
    git reset .metadata
    git reset *.gradle
    git reset .idea
    git reset pubspec.lock

    REM الحصول على التاريخ والوقت الحالي
    for /f "tokens=1-4 delims=/ " %%a in ("%date% %time%") do (
        set datetime=%%a-%%b-%%c_%%d
    )

    REM commit برسالة تلقائية تحتوي على أسماء الملفات + التاريخ والوقت
    git commit -m "تحديث تلقائي: !changes! | %datetime%"
    git push
)

del temp.txt
timeout /t 5
goto loop