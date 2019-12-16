# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Tctl < Formula
  desc "Tinc Utils"
  homepage "https://github.com/leptonyu/homebrew-fun"
  url "https://github.com/leptonyu/homebrew-fun/raw/master/tctl.tar.gz"
  version "1.1"
  sha256 "7f155b93a6325b5e9c27fcc15603c55e91e0654006494b1402ca6fea7c987114"

  # depends_on "cmake" => :build
  depends_on "tinc11"

  def install
    bin.install "tctl"
  end
end
