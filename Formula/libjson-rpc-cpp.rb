class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v0.7.0.tar.gz"
  sha256 "669c2259909f11a8c196923a910f9a16a8225ecc14e6c30e2bcb712bab9097eb"
  head "https://github.com/cinemast/libjson-rpc-cpp.git"

  bottle do
    cellar :any
    sha256 "f27340f082f29eb626411d0d17f1a5436abbe1eb01e3243b4a8923893e68d3a1" => :el_capitan
    sha256 "ab5deb325fcf3edfcc03c2b4b7d22803c63c4722af4162c3076c58850629879b" => :yosemite
    sha256 "a5963cbefa7a381a8da48f16a3d86f3beb522a019a3db55b3919f789a7bc0121" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "argtable"
  depends_on "jsoncpp"
  depends_on "libmicrohttpd"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/jsonrpcstub", "-h"
  end
end
