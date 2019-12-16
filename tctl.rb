# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Tctl < Formula
  desc "Tinc Utils"
  homepage "https://github.com/leptonyu/homebrew-fun"
  url "https://github.com/leptonyu/homebrew-fun/raw/master/tctl.tar.gz"
  version "1.1"
  sha256 "ae8f3ba7fe101206a21ec5f82342b204ce057fbd29bb88e3322d67a45f8efc21"

  # depends_on "cmake" => :build
  depends_on "tinc11"

  def install
    bin.install "tctl"
  end
end
