# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Tctl < Formula
  desc "Tinc Utils"
  homepage "https://github.com/leptonyu/homebrew-fun"
  url "https://github.com/leptonyu/homebrew-fun/raw/master/tctl.tar.gz"
  version "1.1"
  sha256 "d8521a3f4190a02ec427106d9c1d84cee54743967b962e861aa9687956a463e1"

  # depends_on "cmake" => :build
  depends_on "tinc11"

  def install
    bin.install "tctl"
  end
end
