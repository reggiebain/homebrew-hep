require 'formula'

class Thepeg < Formula
  homepage 'http://herwig.hepforge.org/'
  url 'http://www.hepforge.org/archive/thepeg/ThePEG-1.9.0.tar.gz'
  sha1 '7c2ede9d039fb1e78c2d520a98a0fd213a13de81'

  head do
    url 'http://thepeg.hepforge.org/hg/ThePEG', :using => :hg

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'gsl'
  depends_on 'hepmc'   => :recommended
  depends_on 'rivet'   => :recommended
  depends_on 'lhapdf'  => :recommended
  depends_on 'fastjet' => :recommended
  option 'with-check', 'Test during installation'

  def patches
    DATA
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--enable-stdcxx11"

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? 'check'
    system "make", "install"
  end

  test do
    system "setupThePEG", "#{share}/ThePEG/MultiLEP.in"
    system "runThePEG", "MultiLEP.run"
  end
end

__END__
diff --git a/Repository/Repository.cc b/Repository/Repository.cc
index 3e89b96..d6cc3d7 100644
--- a/Repository/Repository.cc
+++ b/Repository/Repository.cc
@@ -452,7 +452,7 @@ void Repository::execAndCheckReply(string line, ostream & os) {
 
 void Repository::read(istream & is, ostream & os, string prompt) {
 #ifdef HAVE_LIBREADLINE
-  if ( is == std::cin ) {
+  if ( &is == &std::cin ) {
     char * line_read = 0;
     do {
       if ( line_read ) {
