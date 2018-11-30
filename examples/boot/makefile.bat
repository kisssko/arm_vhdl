rem ---------------------------------------------------------------------------

set TOP_DIR=../boot/
set OBJ_DIR=%TOP_DIR%obj
set ELF_DIR=%TOP_DIR%bin

mkdir obj
mkdir bin

make -f make_boot TOP_DIR=%TOP_DIR% OBJ_DIR=%OBJ_DIR% ELF_DIR=%ELF_DIR%

pause
exit
