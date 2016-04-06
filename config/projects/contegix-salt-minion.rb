#
# Copyright 2016 YOUR NAME
#
# All Rights Reserved.
#

name "contegix-salt-minion"
maintainer "Contegix, LLC"
homepage "https://github.com/contegix/omnibus-salt-minion"

# Defaults to C:/salt-minion on Windows
# and /opt/salt-minion on all other platforms
install_dir "/opt/contegix/salt"

build_version '2015.8.7'
build_iteration 1

# Creates required build directories
#dependency "preparation"
#dependency "zlib"
#dependency "m2crypto"
dependency "python"
dependency "salt"

# salt-minion dependencies/components
# dependency "somedep"

# Version manifest file
dependency "version-manifest"

exclude "**/.git"
exclude "**/bundler/git"
