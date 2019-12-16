# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Tctl < Formula
  desc "Tinc Utils"
  homepage "https://github.com/leptonyu/homebrew-fun"
  url "https://github.com/leptonyu/homebrew-fun/raw/master/tctl.tar.gz"
  version "1.1"
  sha256 "7df5ae8ec6155143219647855eb5055866653fd28c46a7aca3c591b8c73d460c"

  # depends_on "cmake" => :build
  depends_on "tinc11"

  def install
    bin.install "tctl"
  end
end
