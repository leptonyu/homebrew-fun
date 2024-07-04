class Tinc < Formula
  desc "Virtual Private Network (VPN) tool"
  homepage "https://www.tinc-vpn.org/"
  url "https://github.com/gsliepen/tinc/archive/refs/tags/latest.tar.gz"
  sha256 "a8f19e8df68d3b08f04d7991d40282601b5af0cd430d042c694f8abe837c2c4c"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://www.tinc-vpn.org/download/"
    regex(/href=.*?tinc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "ab60d88c2bb9f1d867bc7fad3ff18086c3bb907502cc1f9af3c61eab5c633771"
    sha256 cellar: :any,                 arm64_ventura:  "9f2467372c458402453d111b49be9ebdfb5d7e53f1a3a33d32bf2c43e9cd6b1b"
    sha256 cellar: :any,                 arm64_monterey: "4fb0f6f2276a92f60c5aad1674c137850d6e0a6ac77adc8ce575aa4288a8b942"
    sha256 cellar: :any,                 arm64_big_sur:  "88d77dd06ee97bf7c1cc0e330876c992d7d460cc55e8e62ebb5c03a0f4ebb0e2"
    sha256 cellar: :any,                 sonoma:         "dfbaa4b890c987e2daeb4a38a4a82d8008ad23e38b135768909c9eeda980c2ff"
    sha256 cellar: :any,                 ventura:        "3f2730126370c8ded288e13b4756426213aef4082039f8a7b64776214ce70db6"
    sha256 cellar: :any,                 monterey:       "58d69be546dceda9a4d413770531633c132cf46a5901553f3d0367cd0bae282f"
    sha256 cellar: :any,                 big_sur:        "094208fa2043d75696fa60b47a4d26f32e67fbffcce78cc37429a6eac641ddb8"
    sha256 cellar: :any,                 catalina:       "878a5d0ded29f6b9ad6a18e040508e7597551d4b359c39f9ecaaa7fc6cb91b12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1cf23e958fe70fd7662d67e87ab9adfd4d838550b104216ec70363391ec7595"
  end

  depends_on "lzo"
  depends_on "openssl@3"
  depends_on "meson"

  uses_from_macos "zlib"

  def install
    system "meson", "setup", "builddir", "-Dprefix=#{prefix}", "-Dbuildtype=release", "-Djumbograms=true", "-Dsystemd=disabled", "-Dcrypto=nolegacy"
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