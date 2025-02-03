:: Made By [Nominaz/Lipicode] 
:: Version [Beta]

setlocal enableextensions enabledelayedexpansion
:main_menu
cls
color 08
echo                                      ============================================
echo                                                      temak beta
echo                                      ============================================
echo.
color 04
echo                                             1  - Single Token Checker
echo                                             2  - Mass Token Checker from TXT File
echo                                             3  - Delete Webhook(s)
echo                                             4  - Webhook Spammer
echo                                             5  - Open GitHub
echo                                             6  - Clear Token Info Log
echo                                             7  - Show Credits
echo                                             8  - ID - Token Tool
echo                                             9  - ID - IPv4 Tool
echo                                            10  - ID - Info Tool
echo                                            11  - Guild Info Tool
echo                                            12  - Mass Webhook Spammer
echo                                            13  - User Avatar Tool
echo                                            14  - Role Checker Tool
echo                                            15  - Snowflake Converter Tool
echo                                                    0  - Exit
echo.
set /p choice="Select an option: "

if "%choice%"=="0" exit
if "%choice%"=="1" goto single_token
if "%choice%"=="2" goto mass_token
if "%choice%"=="3" goto delete_webhook
if "%choice%"=="4" goto spam_webhook
if "%choice%"=="5" goto open_github
if "%choice%"=="6" goto clear_log
if "%choice%"=="7" goto credits
if "%choice%"=="8" goto token_id_tool
if "%choice%"=="9" goto ipv4_tool
if "%choice%"=="10" goto info_tool
if "%choice%"=="11" goto guild_info_tool
if "%choice%"=="12" goto mass_webhook_spammer
if "%choice%"=="13" goto user_avatar_tool
if "%choice%"=="14" goto role_checker_tool
if "%choice%"=="15" goto snowflake_converter_tool

echo.
echo Invalid selection. Please try again.
timeout /t 2 >nul
goto main_menu

:single_token
cls
echo --- Single Token Checker ---
echo.
set /p token="Enter your token: "

for /F "usebackq delims=" %%I in (curl --silent -H "Content-Type: application/json" -H "Authorization: %token%" "https://discord.com/api/v9/users/@me/library") do (
set "response=%%I"
)

echo %response% | findstr /C:"{\"message\":" >nul
if errorlevel 1 (
color 2
echo Token is valid or locked.
echo.
curl --silent -H "Content-Type: application/json" -H "Authorization: %token%" "https://discord.com/api/v9/users/@me" >> tokeninfo.json
echo. >> tokeninfo.json
echo Token information saved in tokeninfo.json.
) else (
color 4
echo Token is invalid!
)
call :return_to_menu single_token

:mass_token
cls
echo --- Mass Token Checker ---
echo.
set /p pathTokens="Enter path to tokens (*.txt): "

if not exist "%pathTokens%" (
cls
echo File not found!
timeout /t 3 >nul
goto main_menu
)

if exist tokeninfo.json del tokeninfo.json

for /F "usebackq delims=" %%A in ("%pathTokens%") do (
for /F "usebackq delims=" %%I in (curl --silent -H "Content-Type: application/json" -H "Authorization: %%A" "https://discord.com/api/v9/users/@me/library") do (
set "tokenResponse=%%I"
)
echo %%A | findstr /C:"{\"message\":" >nul
if errorlevel 1 (
echo [Valid/Locked] %%A
curl --silent -H "Content-Type: application/json" -H "Authorization: %%A" "https://discord.com/api/v9/users/@me" >> tokeninfo.json
echo. >> tokeninfo.json
) else (
echo [Invalid] %%A
)
)
echo.
echo Valid tokens (if any) have been saved in tokeninfo.json.
echo.
call :return_to_menu mass_token

:delete_webhook
cls
echo --- Delete Webhook(s) ---
echo.
echo You can enter multiple webhook URLs separated by a space.
set /p webhookInput="Enter webhook URL(s): "

for %%W in (%webhookInput%) do (
echo Deleting webhook: %%W
curl --silent -X DELETE "%%W"
echo.
)
echo All deletion requests sent.
echo.
call :return_to_menu delete_webhook

:spam_webhook
cls
echo --- Webhook Spammer ---
echo.
set /p webhook="Enter the webhook URL: "
set /p username="Enter the username to display: "
set /p message="Enter the message content: "
set /p amount="Enter number of times to spam (or type x for unlimited): "

if /I "%amount%"=="x" (
:unlimited_spam
curl --silent -d "content=%message%" -d "username=%username%" -X POST "%webhook%"
goto unlimited_spam
) else (
for /L %%a in (1, 1, %amount%) do (
curl --silent -d "content=%message%" -d "username=%username%" -X POST "%webhook%"
cls
echo Message sent %%a times.
)
)
echo.
call :return_to_menu spam_webhook

:open_github
cls
echo Opening GitHub repository...
start "" "https://github.com/sipinslowly"
timeout /t 2 >nul
goto main_menu

:clear_log
cls
echo --- Clear Token Info Log ---
echo.
if exist tokeninfo.json (
del tokeninfo.json
echo tokeninfo.json has been cleared.
) else (
echo No tokeninfo.json file found.
)
echo.
pause
goto main_menu

:credits
cls
echo --- Credits ---
echo.
echo Batch Discord Tools originally created by SipinSlowly.
echo Enhanced and extended by [Your Name].
echo.
echo This script uses cURL to interact with Discord's API.
echo Feel free to contribute or suggest improvements.
echo.
pause
goto main_menu

:token_id_tool
cls
echo --- ID - Token Tool ---
echo.
set /p token="Enter your token: "
echo Retrieving user information...
curl --silent -H "Authorization: %token%" -H "Content-Type: application/json" "https://discord.com/api/v9/users/@me" > temp.json

for /F "tokens=2 delims=:" %%a in ('findstr /C:"\"id\":" temp.json') do (
set userId=%%a
goto gotId
)
:gotId
set userId=%userId: =%
set userId=%userId:,=%
set userId=%userId:"=%
echo.
echo User ID is: %userId%
del temp.json
echo.
pause
call :return_to_menu token_id_tool

:ipv4_tool
cls
echo --- ID - IPv4 Tool ---
echo.
echo Retrieving your public IPv4 address...
for /F "usebackq delims=" %%I in (curl --silent "https://api.ipify.org") do (
set "ipv4=%%I"
)
echo.
echo Your public IPv4 address is: %ipv4%
echo.
pause
call :return_to_menu ipv4_tool

:info_tool
cls
echo --- ID - Info Tool ---
echo.
set /p token="Enter your token: "
echo Retrieving your account information...
curl --silent -H "Authorization: %token%" -H "Content-Type: application/json" "https://discord.com/api/v9/users/@me" > info_temp.json

for /F "tokens=2 delims=:" %%a in ('findstr /C:"\"id\":" info_temp.json') do (
set userId=%%a
goto gotUserId
)
:gotUserId
set userId=%userId: =%
set userId=%userId:,=%
set userId=%userId:"=%
for /F "tokens=2 delims=:" %%a in ('findstr /C:"\"username\":" info_temp.json') do (
set username=%%a
goto gotUsername
)
:gotUsername
set username=%username: =%
set username=%username:,=%
set username=%username:"=%
for /F "tokens=2 delims=:" %%a in ('findstr /C:"\"discriminator\":" info_temp.json') do (
set discriminator=%%a
goto gotDisc
)
:gotDisc
set discriminator=%discriminator: =%
set discriminator=%discriminator:,=%
set discriminator=%discriminator:"=%
echo.
echo Token: %token%
echo User ID: %userId%
echo Username: %username%#%discriminator%
echo Password: Not Available
echo.
set /p useGuild="Do you want to retrieve join date from a guild? (Y/N): "
if /I "%useGuild%"=="Y" (
set /p guildId="Enter Guild ID: "
echo Retrieving guild join date...
curl --silent -H "Authorization: %token%" -H "Content-Type: application/json" "https://discord.com/api/v9/guilds/%guildId%/members/@me" > join_temp.json
for /F "tokens=2 delims=:" %%a in ('findstr /C:"\"joined_at\":" join_temp.json') do (
set joinedAt=%%a
goto gotJoin
)
:gotJoin
set joinedAt=%joinedAt: =%
set joinedAt=%joinedAt:,=%
set joinedAt=%joinedAt:"=%
echo Joined At: %joinedAt%
del join_temp.json
) else (
echo Joined At: Not Retrieved
)
del info_temp.json
echo.
pause
call :return_to_menu info_tool

:guild_info_tool
cls
echo --- Guild Info Tool ---
echo.
set /p token="Enter your token (bot token recommended): "
set /p guildId="Enter Guild ID: "
echo Retrieving guild information...
curl --silent -H "Authorization: %token%" -H "Content-Type: application/json" "https://discord.com/api/v9/guilds/%guildId%" > guild_info_temp.json
for /F "tokens=2 delims=:" %%a in ('findstr /C:"\"name\":" guild_info_temp.json') do (
set guildName=%%a
goto gotGuildName
)
:gotGuildName
set guildName=%guildName: =%
set guildName=%guildName:,=%
set guildName=%guildName:"=%
echo Guild Name: %guildName%
echo.
del guild_info_temp.json
pause
call :return_to_menu guild_info_tool

:mass_webhook_spammer
cls
echo --- Mass Webhook Spammer ---
echo.
set /p pathWebhooks="Enter path to webhooks file (*.txt): "
if not exist "%pathWebhooks%" (
echo File not found!
pause
goto mass_webhook_spammer
)
set /p message="Enter the message content: "
set /p amount="Enter number of times to spam each webhook: "
for /F "usebackq delims=" %%W in ("%pathWebhooks%") do (
echo Spamming webhook: %%W
for /L %%i in (1,1,%amount%) do (
curl --silent -d "content=%message%" -X POST "%%W"
)
echo Done spamming %%W
)
pause
call :return_to_menu mass_webhook_spammer

:user_avatar_tool
cls
echo --- User Avatar Tool ---
echo.
set /p token="Enter your token: "
echo Retrieving user information...
curl --silent -H "Authorization: %token%" -H "Content-Type: application/json" "https://discord.com/api/v9/users/@me" > avatar_temp.json
for /F "tokens=2 delims=:" %%a in ('findstr /C:"\"id\":" avatar_temp.json') do (
set userId=%%a
goto gotUserIdAvatar
)
:gotUserIdAvatar
set userId=%userId: =%
set userId=%userId:,=%
set userId=%userId:"=%
for /F "tokens=2 delims=:" %%a in ('findstr /C:"\"avatar\":" avatar_temp.json') do (
set avatarHash=%%a
goto gotAvatarHash
)
:gotAvatarHash
set avatarHash=%avatarHash: =%
set avatarHash=%avatarHash:,=%
set avatarHash=%avatarHash:"=%
if "%avatarHash%"=="null" (
echo No custom avatar found. Using default avatar.
set avatarUrl=https://cdn.discordapp.com/embed/avatars/0.png
) else (
set avatarUrl=https://cdn.discordapp.com/avatars/%userId%/%avatarHash%.png
)
echo Your avatar URL is: %avatarUrl%
del avatar_temp.json
pause
call :return_to_menu user_avatar_tool

:role_checker_tool
cls
echo --- Role Checker Tool ---
echo.
set /p token="Enter your token: "
set /p guildId="Enter Guild ID: "
echo Retrieving your roles in the guild...
curl --silent -H "Authorization: %token%" -H "Content-Type: application/json" "https://discord.com/api/v9/guilds/%guildId%/members/@me" > roles_temp.json
for /F "tokens=2 delims=:" %%a in ('findstr /C:"\"roles\":" roles_temp.json') do (
set roles=%%a
goto gotRoles
)
:gotRoles
set roles=%roles: =%
set roles=%roles:[=%
set roles=%roles:]=%
echo Your roles in the guild: %roles%
del roles_temp.json
pause
call :return_to_menu role_checker_tool

:snowflake_converter_tool
cls
echo --- Snowflake Converter Tool ---
echo.
set /p snowflake="Enter the Discord Snowflake ID: "
for /F "delims=" %%D in ('powershell -NoProfile -Command "$ts = ([math]::Floor(%snowflake% / 4194304)) + 1420070400000; [DateTimeOffset]::FromUnixTimeMilliseconds($ts).ToLocalTime().ToString()"') do (
set creationDate=%%D
)
echo The creation date for snowflake %snowflake% is: %creationDate%
pause
call :return_to_menu snowflake_converter_tool

:return_to_menu
echo.
set /p backChoice="Do you want to return to the main menu? [Y/N]: "
if /I "%backChoice%"=="Y" (
color 07
goto main_menu
) else if /I "%backChoice%"=="N" (
goto %1
) else (
color 07
goto main_menu
)
