class Haskell < Formula
  desc "Haskell Tools"
  url "https://github.com/leptonyu/homebrew-fun/raw/master/LICENSE"
  version "1.0"
  sha256 "1cdc0317e6c8d097ca21584fc05efe68e5d0800e9ef79cbfa22ce67db46b6b82"

  depends_on "haskell-stack"

  private def create_format
    wrap = '#!/bin/bash
    find . -name \'*.hs\' | grep -v \'.stack-work\' | xargs stylish-haskell -i'
    File.write('haskell_format', wrap)
  end

  private def create_ghci
    wrap = '#!/bin/bash
if [ ! -e "$HOME/.ghci_home" ]; then
  mkdir $HOME/.ghci_home
fi
cd $HOME/.ghci_home

if [ -z ${UPDATE+x} ]; then
  TURN_OFF_DAILY_CHECK=1
else
  TURN_OFF_DAILY_CHECK=0 
fi

NOW=`date +%Y%m%d`

setName(){
  NAME=$(curl -q -I https://www.stackage.org/lts 2>/dev/null | grep -i Location | grep -o \'lts-[0-9][0-9]*\.[0-9][0-9]*\')
  DIR=`stack path --local-pkg-db`
  DIR=`cd "$DIR/../..";pwd`
  NAME2=`basename "$DIR"`
  if [ -z "$NAME" ]; then
    NAME="$NAME2"
  fi
  if [ "$NAME" != "$NAME2" ]; then
    echo "Please update $HOME/.stack/global-project/stack.yaml to $NAME" >&2
  fi
  echo "$NOW:$NAME" > .lts
}


ltsDate(){
  head -1 .lts | grep -o \'^[0-9]\{8\}\'
}

ltsName(){
  head -1 .lts | grep -o \'\(lts-[0-9][0-9]*\.[0-9][0-9]*\|nightly-..*\)\'
}

if [ ! -e ".lts" ]; then
  setName
elif [ "`ltsDate`" != "$NOW" -a "1" != "$TURN_OFF_DAILY_CHECK" ]; then
  setName
fi

NAME=`ltsName`

echo "Hackage version $NAME..."
stack exec ghci --resolver $NAME $@'
     File.write('ghci', wrap)
   end
   def install
     create_format
     bin.install "haskell_format"
     create_ghci
     bin.install "ghci"
   end
 end
