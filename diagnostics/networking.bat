@echo off
:: Note: This script terminates WSL. Save your work before running it.

:: Check for administrator access
net session >nul 2>&1 || goto :admin

:: Validate that required files are here
if not exist wsl.wprp (echo wsl.wprp not found && exit /b 1)
if not exist networking.sh (echo networking.sh not found && exit /b 1)


:: Stop WSL
sc stop LxssManager

:: List all HNS objects
echo HNS objects: 
hnsdiag list all -df

:: The WSL HNS network is created once per boot. Resetting it to collect network creation logs
echo Deleting HNS network
hnsdiag reset networks

:: Collect WSL logs
wpr -start wsl.wprp -filemode || goto :fail
wsl bash ./networking.sh
wpr -stop wsl.etl || goto :fail

exit /b 0

:fail
echo Failed to collect WSL logs
exit /b 1

:admin
echo This script needs to run with administrative access
exit /b 1