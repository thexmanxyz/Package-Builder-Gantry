REM #######################################################
REM #                                                     #
REM #   Package Builder Gantry - Shell Script             #
REM #                                                     #
REM #   Purpose: This project contains a Windows Shell    #
REM #            script which allows with a minimal       #
REM #            configuration to automatically build     #
REM #            Joomla plugin and Gantry component       #
REM #            archives.                                #
REM #                                                     #
REM #   Author: Andreas Kar (thex) <andreas.kar@gmx.at>   #
REM #   Repository: https://git.io/fA9Xu                  #
REM #   Homepage: https://gantryprojects.com              #
REM #                                                     #
REM #######################################################

REM --- package variables ---
set pkg_leg=legacy
set pkg_helium=helium
set pkg_hydro=hydrogen
set pkg_global=global
set pkg_j3=j3

REM --- folder variables ---
set folder_root=..\..
set folder_src_def=src\default
set folder_src_leg=src\legacy
set folder_platform_joomla=platform\joomla
set folder_trans=translation
set folder_gantry=gantry
set folder_temp=temp
set folder_release=release
set folder_def=default
set folder_leg=legacy
set folder_js=js
set folder_css=css
set folder_scss=scss
set folder_helium=%pkg_j3%_%pkg_helium%
set folder_hydro=%pkg_j3%_%pkg_hydro%
set folder_global=%pkg_j3%_%pkg_global%
set folder_src_js=src\%folder_js%
set folder_src_css=src\%folder_css%
set folder_src_scss=src\%folder_scss%
set folder_release_dest=%pkg_release_folder%\%prj_rev%

REM --- message variables ---
set msg_start=Start build process and create release %prj_rev%.
set msg_finished=Successfully finished build process.
set msg_failed=Build process failed with an error.
set msg_success=successfully created.
set msg_release_success=Successfully created release %prj_rev%, packages moved to destination folder.
set msg_release_failed=Could not move packages to release folder %prj_rev%, already exists.

REM --- start script ---
SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)

echo.
echo %prj_title_hr%
echo # %prj_fullname% #
echo %prj_title_hr%
echo.
call :ColorizeText 0a "%msg_start%"

IF NOT EXIST %folder_temp% ( mkdir %folder_temp% )
IF NOT EXIST %folder_release% (	mkdir %folder_release% )

echo.
cd %folder_temp%

REM --- call Gantry default and legacy package creation ----
IF %pkg_def_enable% == 1 ( call :create_gantry "%folder_def%" "" "%folder_src_def%" )
IF %pkg_leg_enable% == 1 ( call :create_gantry "%folder_leg%" "%pkg_leg%." "%folder_src_leg%" )

REM --- call Hydrogen and Helium package creation ----
IF %pkg_hydro_enable% == 1 ( call :create_j3plugin "%folder_hydro%" "%pkg_hydro%" )
IF %pkg_helium_enable% == 1 ( call :create_j3plugin "%folder_helium%" "%pkg_helium%" )
IF %pkg_global_enable% == 1 ( call :create_j3plugin "%folder_global%" "%pkg_global%" )

REM --- move packages to release folder ---
IF %scr_log_files% == 0 ( echo. )
cd..
IF NOT EXIST %folder_release_dest% ( 
	mkdir %folder_release_dest%
	call :copy_folder_content "%folder_release%" "%folder_release_dest%"
	IF %scr_log_files% == 1 ( echo ------------------------- )
	call :ColorizeText 0a "%msg_release_success%"
	set script_ok=1
) ELSE (
	call :ColorizeText 0C "%msg_release_failed%"
	set script_ok=0
)

REM --- stop script and cleanup ---
IF %scr_remove_folders% == 1 (
	rmdir "%folder_temp%" /S /Q
	rmdir "%folder_release%" /S /Q
)

IF %script_ok% == 1 (
	call :ColorizeText 0a "%msg_finished%"
) ELSE (
	call :ColorizeText 0C "%msg_failed%"
)

goto :EOF

REM --- Create Gantry package(s) for different languages ---
REM --- Parameters: %~1 = destination folder gantry, %~2 = archive name, %~3 = yaml base path ---
:create_gantry
	setlocal EnableDelayedExpansion
	(for %%l in (%prj_sup_langs%) do (

		set "lang=%%l"
		set folder_out=%~1_!lang!
		set package_name=%prj_id%.%pkg_g5_name%.%~2!lang!.%prj_rev%

		IF NOT EXIST !folder_out! ( mkdir !folder_out! )

		(for %%f in (%pkg_g5_def_files%) do ( call :copy_general_files "%folder_root%\%%f" "!folder_out!"	))
		(for %%c in (%pkg_expl_files%) do ( call :copy_component_files "%%c" "!lang!" "%~3" "!folder_out!" ))
		(for %%e in (%pkg_file_ext%) do ( call :copy_gantry_files "%%e" "!lang!" "%~3" "!folder_out!" ))
		call :copy_include_sub_folder "%folder_src_js%" "%folder_js%"
		call :copy_include_sub_folder "%folder_src_css%" "%folder_css%"
		call :copy_include_sub_folder "%folder_src_scss%" "%folder_scss%"
		call :create_archives "!package_name!" "!folder_out!" 1 1

		IF %scr_remove_folders% == 1 ( rmdir "!folder_out!" /S /Q )
		IF %scr_log_files% == 1 ( echo ------------------------- )
		echo !package_name! %msg_success%
		IF %scr_log_files% == 1 ( echo. )
	))
	endlocal
goto :EOF

REM --- Create Joomla 3 plugin packages for different languages ---
REM --- Parameters: %~1 = destination folder plugin, %~2 = template name ---
:create_j3plugin
	setlocal EnableDelayedExpansion
	(for %%l in (%prj_sup_langs%) do (

		set "lang=%%l"
		set folder_out=%~1_!lang!
		set folder_out_sub=!folder_out!\%folder_gantry%
		set folder_platform=%folder_root%\%folder_platform_joomla%
		set package_name=%prj_id%.%pkg_j3%.%~2.!lang!.%prj_rev%

		IF NOT EXIST !folder_out! ( mkdir !folder_out! )
		IF NOT EXIST !folder_out_sub! ( mkdir !folder_out_sub! )

		(for %%e in (%pkg_file_ext%) do ( call :copy_gantry_files "%%e" "!lang!" "%folder_src_def%" "!folder_out_sub!" ))
		(for %%c in (%pkg_expl_files%) do ( call :copy_component_files "%%c" "!lang!" "%folder_src_def%" "!folder_out_sub!" ))
		(for %%f in (%pkg_j3_def_files%) do ( call :copy_general_files "!folder_platform!\%%f" "!folder_out!" ))
		call :copy_include_sub_folder "%folder_src_js%" "%folder_js%"
		call :copy_include_sub_folder "%folder_src_css%" "%folder_css%"
		call :copy_include_sub_folder "%folder_src_scss%" "%folder_scss%"
		call :copy_plugin_files "!lang!" "!folder_platform!" "%~2" "!folder_out!"
		call :create_archives "!package_name!" "!folder_out!" 1 0

		IF %scr_remove_folders% == 1 (
			rmdir "!folder_out_sub!" /S /Q
			rmdir "!folder_out!" /S /Q
		)
		IF %scr_log_files% == 1 ( echo ------------------------- )
		echo !package_name! %msg_success%
		IF %scr_log_files% == 1 ( echo. )
	))
	endlocal
goto :EOF

REM --- Copies the particle files to the current temp folder ---
REM --- Parameters: %~1 = extension, %~2 = language, %~3 = yaml base path, %~4 = output folder ---
:copy_gantry_files 
	set prj_trans_path=%folder_root%\%~3\%folder_trans%\!lang!\%prj_name%.%~1
	
	IF "%~1" == "%pkg_lang_id%" (
		set prj_path=%folder_root%\%~3\%prj_name%.%~1
		IF "%~2" == "%prj_def_lang%" (
			IF %scr_log_files% == 1 ( echo !prj_path! )
			copy !prj_path! %~4 >Nul
		) ELSE (
			IF %scr_log_files% == 1 ( echo !prj_trans_path! )
			copy !prj_trans_path! %~4 >Nul
		)
	) ELSE (
		set prj_path=%folder_root%\%folder_src_def%\%prj_name%.%~1
		IF %scr_log_files% == 1 ( echo !prj_path! )
		copy !prj_path! %~4 >Nul
	)
goto :EOF

REM --- Copies the component files to the current temp folder ---
REM --- Parameters: %~1 = file name, %~2 = language, %~3 = yaml base path, %~4 = output folder ---
:copy_component_files 
	set prj_trans_path=%folder_root%\%~3\%folder_trans%\!lang!\%~1
	
	IF "%~1" == "%pkg_lang_id%" (
		set prj_path=%folder_root%\%~3\%~1
		IF "%~2" == "%prj_def_lang%" (
			IF %scr_log_files% == 1 ( echo !prj_path! )
			copy !prj_path! %~4 >Nul
		) ELSE (
			IF %scr_log_files% == 1 ( echo !prj_trans_path! )
			copy !prj_trans_path! %~4 >Nul
		)
	) ELSE (
		set prj_path=%folder_root%\%folder_src_def%\%~1
		IF %scr_log_files% == 1 ( echo !prj_path! )
		copy !prj_path! %~4 >Nul
	)
goto :EOF

REM --- Copies the general project files like license and readme  ---
REM --- Parameters: %~1 = source folder, %~2 = output folder ---
:copy_general_files
	IF %scr_log_files% == 1 ( echo %~1 )
	copy %~1 %~2 >Nul
goto :EOF

REM --- Copies the Joomla 3 plugin files ---
REM --- Parameters: %~1 = language, %~2 = platform folder, %~3 = template name, %~4 = output folder ---
:copy_plugin_files
	set temp_path=%~2\%~3\%prj_name%
	set temp_trans_path=%~2\%~3\%folder_trans%\%~1\%prj_name%
	
	IF "%~1" == "%prj_def_lang%" (
		IF %scr_log_files% == 1 ( echo !temp_path!.xml )
		copy !temp_path!.xml %~4 >Nul
		ren %~4\%prj_name%.xml %prj_name%-%~3.xml >Nul
	) ELSE (
		IF %scr_log_files% == 1 ( echo !temp_trans_path!.xml )
		copy !temp_trans_path!.xml %~4 >Nul
		ren %~4\%prj_name%.xml %prj_name%-%~3.xml >Nul
	)
goto :EOF

REM --- Copy a sub folder which should be included in the package ---
REM --- Parameters: %~1 = src folder path, %~2 = target folder path ---
:copy_include_sub_folder
	IF EXIST %folder_root%\%~1 (
		set folder_out_inc=!folder_out!\%~2
		IF NOT EXIST !folder_out_inc! ( mkdir !folder_out_inc! )
		call :copy_folder_content_replace "%folder_root%\%~1" "!folder_out_inc!"
	)
goto :EOF

REM --- Copies content of a folder and overwrites content ---
REM --- Parameters: %~1 = Source Folder, %~2 = Destination Folder ---
:copy_folder_content_replace
	IF %scr_log_files% == 1 ( xcopy /s /Y %~1 %~2 ) ELSE ( xcopy /s /Y %~1 %~2 >Nul )
goto :EOF

REM --- Copies content of a folder without overwrite ---
REM --- Parameters: %~1 = Source Folder, %~2 = Destination Folder ---
:copy_folder_content
	IF %scr_log_files% == 1 ( xcopy /s %~1 %~2 ) ELSE ( xcopy /s %~1 %~2 >Nul )
goto :EOF

REM --- Creates release archives ---
REM --- Parameters: %~1 = package name, %~2 = output folder, %~3 = create zip, %~4 = create tar.gz ---
:create_archives
	set arch_dest=..\%folder_release%\%~1
	
	IF %~3 == 1 (
		set zip_dest=!arch_dest!.zip
		IF EXIST !zip_dest! ( del !zip_dest! )
		7z a -tzip !zip_dest! .\%~2\* >Nul
	)
	IF %~4 == 1 (
		set tar_dest=!arch_dest!.tar
		set gzip_dest=!arch_dest!.tar.gz
		7z a -ttar !tar_dest! .\%~2\* >Nul
		IF EXIST !gzip_dest! ( del !gzip_dest! )
		7z a !gzip_dest! !tar_dest! >Nul
		del !tar_dest!
	)
goto :EOF

REM --- Colorizes text ---
REM --- Parameters: %~1 = Color Hex, %~2 = Output ---
:ColorizeText
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
echo.
goto :EOF