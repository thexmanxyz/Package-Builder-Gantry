# Gantry Package Builder - Shell Script
This project contains a Windows Shell script which allows with a minimal configuration to automatically build Joomla plugin and Gantry component archives. The **Gantry Package Builder** can be easily configured to assist the release process with a consistent naming scheme and a flexible setup for the actual package content.

## Prerequisites
* Windows Shell

## Download
[Download v1.0.0](https://github.com/thexmanxyz/Package-Builder-Gantry/archive/v1.0.0.zip) of the *Gantry Package Builder*.

## Configuration and Parameters
The *Gantry Package Builder* consists of the following two script files:

* `build.bat`: contains the configuration variables for the build script
* `base-build.bat`: contains the actual build script

The following configuration parameters are available:

* `scr_remove_folders`: `0` or `1`, defines if the temporary files should be removed after completion
* `scr_log_files`: `0` or `1`, defines if the script should log the processed files
* `prj_id`: the unique identifier of the project, typically consists of three characters e.g. `abc`
* `prj_rev`: the revision of the project e.g. `v1.2.3`.
* `prj_name`: the name of the project which is used for the file generation and identification e.g. Joomla or Gantry files
* `prj_fullname`: the human readable project name for debug and log outputs
* `prj_title_hr`: horizontal line for debug and log outputs
* `prj_def_lang`: the default language of the project e.g. `EN`
* `prj_sup_langs`: the languages supported by the project, comma separated list e.g. `EN, DE`
* `pkg_g5_name`: a string appended to every Gantry package name to distinguish between Gantry object types e.g. `particle.only` or `atom.only`
* `pkg_g5_def_files`: a set of default files that should be included within the Gantry package, comma separated list e.g. `LICENSE, README.md`
* `pkg_j3_def_files`: a set of default files that included within the Joomla plugin package, comma separated list e.g. `LICENSE.pdf` or `README.txt`
* `pkg_expl_files`: a list of explicit files that should be added to all packages, e.g. `abc.html.twig`
* `pkg_lang_id`: identification of the language source file, either file extension or full filename
* `pkg_file_ext`: file extensions that should be automatically added to all packages, comma separated list e.g. `yaml` or `html.twig`
* `pkg_release_folder`: the target release folder were the created packages should be finally moved to e.g. `..\releases` would create `releases\v1.2.3` in the root folder of the project
* `pkg_def_enable`: `0` or `1`, defines if the Gantry default package should be generated
* `pkg_leg_enable`: `0` or `1`, defines if the Gantry legacy package should be generated
* `pkg_helium_enable`: `0` or `1`, defines if the Joomla plugin for Helium should be generated
* `pkg_hydro_enable`: `0` or `1`, defines if the Joomla plugin for Hydrogen should be generated
* `pkg_global_enable`: `0` or `1`, defines if the Joomla plugin for global installation should be generated

The build files have to be placed in a directory one layer below the project root to work correctly e.g. `root\build` or `root\make`.

## Future Tasks
- [ ] Grav plugin package generation
- [ ] Wordpress plugin package generation

## Known Issues
* none

## by [thex](https://github.com/thexmanxyz) | [gantryprojects](https://gantryprojects.com)
Copyright (c) 2018, free to use in personal and commercial software as per the [license](/LICENSE.md).

