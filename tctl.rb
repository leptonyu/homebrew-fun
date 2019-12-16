# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Tctl < Formula
  desc "Tinc Utils"
  homepage "https://github.com/leptonyu/homebrew-fun"
  url "https://github.com/leptonyu/homebrew-fun/raw/master/tctl.tar.gz"
  version "1.1"
  sha256 "82279c92a5698c00613a4316721e5ce700928cbbf55e22c20640def7ff104da2"

  # depends_on "cmake" => :build
  depends_on "tinc11"

  def install
    bin.install "tctl"
  end
end
