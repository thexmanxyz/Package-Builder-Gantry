@echo off
REM #######################################################
REM #                                                     #
REM #   Package Builder Gantry - Shell Script             #
REM #                                                     #
REM #   Purpose: A windows shell script which allows      #
REM #            with a minimal configuration to build    #
REM #            Joomla plugin and Gantry component       #
REM #            packages.                                #
REM #                                                     #
REM #   Author: Andreas Kar (thex) <andreas.kar@gmx.at>   #
REM #   Repository: https://git.io/fA9Xu                  #
REM #   Homepage: https://gantryprojects.com              #
REM #                                                     #
REM #######################################################

REM # EXAMPLE Configuration

REM --- Script Variables ---
set scr_remove_folders=1
set scr_log_files=0

REM --- Project Variables ---
set prj_id=abc
set prj_rev=v1.0.0
set prj_name=anti-backup-cookie
set prj_fullname=Anti Backup Cookie - Particle
set prj_title_hr=-----------------------------
set prj_def_lang=EN
set prj_sup_langs=EN, IT, DE

REM --- Packaging Variables ---
set pkg_part_only=particle.only
set pkg_def_files=LICENSE, README.md
set pkg_j3_def_files=LICENSE.pdf
set pkg_expl_files=
set pkg_lang_id=yaml
set pkg_part_file_ext=yaml, html.twig

set pkg_def_enable=1
set pkg_leg_enable=1
set pkg_helium_enable=1
set pkg_hydro_enable=1
set pkg_global_enable=1

"base-build.bat"