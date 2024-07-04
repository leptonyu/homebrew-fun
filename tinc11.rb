class Tinc11 < Formula
  desc "Virtual Private Network (VPN) tool"
  homepage "https://www.tinc-vpn.org/"
  url "https://github.com/gsliepen/tinc/archive/refs/tags/latest.tar.gz"
  sha256 "a8f19e8df68d3b08f04d7991d40282601b5af0cd430d042c694f8abe837c2c4c"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  version "1.1-pre18"

  # depends_on "lzo"
  depends_on "openssl@3"
  depends_on "meson"
  depends_on "ncurses"

  uses_from_macos "zlib"

  def install
    system "meson", "setup", "builddir", "-Dprefix=#{prefix}", "-Dbuildtype=release", "-Djumbograms=true", "-Dsystemd=disabled", "-Dcrypto=nolegacy", "-Dlzo=disabled"
    system "meson", "compile", "-C", "builddir"
    system "meson", "install", "-C", "builddir"
  end

  def post_install
    (var/"run/tinc").mkpath
  end

  service do
    run [opt_sbin/"tincd", "--config=#{etc}/tinc", "--pidfile=#{var}/run/tinc/tinc.pid", "-D"]
    keep_alive true
    require_root true
    working_dir etc/"tinc"
    log_path var/"log/tinc/stdout.log"
    error_log_path var/"log/tinc/stderr.log"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/tincd --version")
  end
end