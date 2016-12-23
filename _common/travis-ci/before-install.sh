#!/bin/bash
git submodule init;
git submodule update;

if [ $TRAVIS_OS_NAME == linux ];
then
    if [ ! -d /home/runner ]; 
    then
        echo -n | openssl s_client -connect scan.coverity.com:443 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' | sudo tee -a /etc/ssl/certs/ca-
        sudo ln -s /home/travis /home/runner
    fi

    bash _Misc/dev_scripts/generate_version_files.sh
    sudo add-apt-repository --yes ppa:ubuntu-sdk-team/ppa
    sudo apt-get update -qq
    sudo apt-get install -qq "^libxcb.*" libx11-dev libx11-xcb-dev libxcursor-dev libxrender-dev libxrandr-dev libxext-dev libxi-dev libxss-dev libxt-dev libxv-dev libxxf86vm-dev libxinerama-dev libxkbcommon-dev libfontconfig1-dev libasound2-dev libpulse-dev libdbus-1-dev libts-dev udev mtdev-tools webp libudev-dev libglm-dev libwayland-dev libegl1-mesa-dev mesa-common-dev libgl1-mesa-dev libglu1-mesa-dev libgles2-mesa libgles2-mesa-dev libmirclient-dev libproxy-dev ccache
    mkdir /home/runner/Qt
    wget http://wohlsoft.ru/docs/Software/QtBuilts/qt-5-6-0-static-ubuntu-14-04-x64.tar.gz -O /home/runner/Qt/qt-5-6-0-static-ubuntu-14-04-x64.tar.gz
    tar -xf /home/runner/Qt/qt-5-6-0-static-ubuntu-14-04-x64.tar.gz -C /home/runner/Qt
    export PATH=/home/runner/Qt/5.6.0_static/bin:$PATH
    /home/runner/Qt/5.6.0_static/bin/qmake --version
    chmod u+x generate_paths.sh
    bash generate_paths.sh silent semaphore

elif [ $TRAVIS_OS_NAME == osx ];
then
    source _common/travis-ci/_osx_env.sh

    sudo mkdir -p /Users/StaticQt/;
    sudo chown -R travis /Users/StaticQt/;
# ==============================================================================
# Downloading and unpacking of pre-built static Qt 5.7.0 on OS X 10.10.5
# ------------------------------------------------------------------------------
# Static Qt is dependent to absolute build path, so,
# we are re-making same tree which was on previous machine where this build of Qt was built
# ==============================================================================
    wget http://wohlsoft.ru/docs/Software/QtBuilts/qt-5.7.0-static-osx-10.10.5.tar.gz -O /Users/StaticQt/qt-5.7.0-static-osx-10.10.5.tar.gz;
    Bak=~+;
    cd /Users/StaticQt/;
    tar -xf qt-5.7.0-static-osx-10.10.5.tar.gz;
    cd $Bak;

# ==============================================================================
# Installing of required for building process tools via homebrew toolset
# ==============================================================================
    brew install coreutils binutils gnu-sed
    # Thanks to St. StackOverflow if this will work http://stackoverflow.com/questions/39633159/homebrew-cant-find-lftp-formula-on-macos-sierra
    brew install homebrew/boneyard/lftp

# Workaround for ElCapitan
    if [ ! -d /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk ];
    then
        ln -s /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk
    fi

# ==============================================================================
# Making "_paths.sh" config file
# ==============================================================================
    echo "QT_PATH=\"/Users/StaticQt/5.7.0/bin/\"" > _paths.sh;
    echo "QMake=\"qmake\"" > _paths.sh;
    echo "LRelease=\"lrelease\"" >> _paths.sh;
    echo "" >> _paths.sh;
    chmod u+x _paths.sh;

fi
