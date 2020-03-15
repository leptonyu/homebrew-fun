class Tinc11 < Formula
  desc "Virtual Private Network (VPN) tool"
  homepage "https://www.tinc-vpn.org/"
  url "https://github.com/leptonyu/tinc/releases/download/1.1pre17-36-gf46d99f/tinc-1.1pre17-36-gf46d99f.tar.gz"
  sha256 "56db0d44d02ee5d42f0eaa3238c39f98bf04eb81d5056447acc8add422656d82"

  depends_on "lzo"
  depends_on "libressl"
  if OS.linux?
  depends_on "readline"
  end

  private def create_tc
    wrapper = '#!/bin/bash
_tinc_check(){
  [ -n "$2" ] && tc l | grep -q "$2" || (tc h $1 && return 1)
}
LOF=/usr/local/var/log
case $1 in 
  l|list)
    tinc network
  ;;
  a|active)
    ps -ef | grep tinc | grep log | awk \'{print $11}\' | awk -F\'[/.]\' \'{print $7}\'
  ;;
  h|help)
    echo "Usage:"
    AA=$(tc a | tr \'\n\' \'|\' | sed \'s/|$//\')
    if echo "$2" | grep -vq \'\(stop\|restart\)\'; then
      BB=$(echo "$AA" | sed \'s/|/\\|/g\')
      AA=$(tc l | grep -v "\($BB\|_\)" | tr \'\n\' \'|\' | sed \'s/|$//\')
    fi
    echo "  tinc $2 $AA"
  ;;
  start)
    if [ $# -gt 1 ]; then
      shift 1
      for x in $@; do
        _tinc_check start $x && sudo tinc -n $x start --logfile=$LOF/tinc.$x.log
      done
    else
      _tinc_check $@ && sudo tinc -n $2 start --logfile=$LOF/tinc.log
    fi
  ;;
  stop)
    case $2 in 
      all)
        tc a | awk \'{print "sudo tinc -n "$1" stop"}\' | sh
      ;;
      *)
        if [ $# -gt 1 ]; then
          shift 1
          for x in $@; do
            _tinc_check stop $x && sudo tinc -n $x stop
          done
        else
          _tinc_check $@ && sudo tinc -n $2 stop
        fi
      ;;
    esac
  ;;
  restart)
    if [ $# -gt 1 ]; then
      shift 1
      for x in $@; do
        _tinc_check restart $x && sudo tinc -n $x restart --logfile=$LOF/tinc.$x.log
      done
    else
      _tinc_check $@ && sudo tinc -n $2 restart --logfile=$LOF/tinc.log
    fi
  ;;
  log)
    _tinc_check $@ && tail -f $LOF/tinc.$2.log
  ;;
  s|shell|console)
    _tinc_check $@ && shift 1 && sudo tinc -n $@
  ;;
  *)
    echo "Usage:"
    echo "  tinc l|list"
    echo "  tinc a|active"
    echo "  tinc stop    VPN"
    echo "  tinc start   VPN"
    echo "  tinc restart VPN"
    echo "  tinc log     VPN"
  ;;
esac'
    File.write('tc', wrapper)
  end
  def install
    system "./configure", 
      "--prefix=#{prefix}", 
      "--sysconfdir=#{etc}",
      "--localstatedir=#{var}",
      "--runstatedir=#{var}/run",
      "--with-openssl=#{Formula["libressl"].opt_prefix}",
      "--disable-legacy-protocol",
      "--enable-jumbograms"
    system "make", "install"
    create_tc
    bin.install "tc"
    mkdir("#{var}/run")
    mkdir("#{var}/log")
  end

  plist_options :manual => "tinc start mt1"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <false/>
        <key>ProgramArguments</key>
        <array>
            <string>#{sbin}/tincd</string>
            <string>-n</string>
            <string>mt1</string>
            <string>--logfile=/usr/local/var/log/tinc.mt1.log</string>
            <string>--pidfile=/usr/local/var/run/tinc.mt1.pid</string>
        </array>
      </dict>
    </plist>
  EOS
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/tincd --version")
  end
 end
