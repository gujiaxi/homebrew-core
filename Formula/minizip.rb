class Minizip < Formula
  desc "C library for zip/unzip via zLib"
  homepage "http://www.winimage.com/zLibDll/minizip.html"
  url "http://zlib.net/zlib-1.2.11.tar.gz"
  sha256 "c3e5e9fdd5004dcb542feda5ee4f0ff0744628baf8ed2dd5d66f8ca1197cb1a1"

  bottle do
    cellar :any
    sha256 "1d84feef5e29869e4eca8341e782f4b695abe1ec29d54c00cab82ac67c638b68" => :sierra
    sha256 "48a6ae81021c0208f72434b4f7d0c4b3095d192564b78574afb1f8ea27ac8af9" => :el_capitan
    sha256 "60235f0fe3bd432857c27b5c5b912d538925a7a477ff3822ac2af95ea9b00c22" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"

    cd "contrib/minizip" do
      # edits to statically link to libz.a
      inreplace "Makefile.am" do |s|
        s.sub! "-L$(zlib_top_builddir)", "$(zlib_top_builddir)/libz.a"
        s.sub! "-version-info 1:0:0 -lz", "-version-info 1:0:0"
        s.sub! "libminizip.la -lz", "libminizip.la"
      end
      system "autoreconf", "-fi"
      system "./configure", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  def caveats
    <<-EOS.undent
      Minizip headers installed in 'minizip' subdirectory, since they conflict
      with the venerable 'unzip' library.
    EOS
  end
end
