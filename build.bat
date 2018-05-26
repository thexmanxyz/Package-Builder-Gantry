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
REM #                                                     #
REM #######################################################

REM # EXAMPLE Configuration

REM --- Script Variables ---
set remove_folders=1
set log_files=0
set title_hr=-----------------------------

REM --- Packaging Variables ---
set langs_upper=EN, IT, DE
set default_lang=EN

set prj_id=abc
set prj_rev=v1.0.0
set prj_name=anti-backup-cookie
set prj_fullname=Anti Backup Cookie - Particle

set pkg_part_only=particle.only
set pkg_def_enable=1
set pkg_leg_enable=1
set pkg_helium_enable=1
set pkg_hydro_enable=1

REM --- File Variables ---
set comp_files=
set part_def_files=LICENSE, README.md
set plugin_def_files=LICENSE.pdf
set file_ext=yaml, html.twig
set lang_ext=yaml

"base-build.bat"