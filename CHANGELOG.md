# Changelog

All significant changes to the OLS project are documented here.

## [unrealized]
- new commands:
  - `kuber`
  - `ossh`

## [0.6.0] - 2024-05-18
### Added
- SSH for `gx`
- flag --debug for `lslog`

### Improved
- command `ols update` upgraded


## [0.5.2] - 2024-05-09
### Added
- Usage Policy
- debug loging
- new system modules:
  - `fs`
- new commands:
  - `cicd`


## [0.5.1] - 2026-04-26
### Added
- new system modules:
  - `sysd`
- binary plugins (`"bin": true`)
- Sticky bit for Makefile

## [0.5.0] - 2026-04-02
### Added
- flag -l for `mkfile`
- flag -o for `nurl`
- flag -e for main manager
- flag --LOG_LEVEL= for main manager
- UI to command `uedit`
- System modules added:
  - `netcli`
  - `cleanz`
  - `sysinfo`


### Improved
- command `ols update` upgraded
- command `ols doctor` upgraded

### Fixed
- olsp now generates keys correctly.
- from command ols update helper
