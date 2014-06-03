require 'formula'

class Rivet < Formula
  homepage 'http://rivet.hepforge.org/'
  #url 'http://www.hepforge.org/archive/rivet/Rivet-2.1.1.tar.gz'
  #sha1 '2fbd9c78130cae9af65c07d8116f56a9fb6dbe52'
  url 'http://www.hepforge.org/archive/rivet/Rivet-2.1.2.tar.gz'
  sha1 '616ada047ff36d628f51130dff59bd01f369fd60'

  head do
    url 'http://rivet.hepforge.org/hg/rivet', :using => :hg, :branch => 'tip'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
    depends_on 'cython' => :python
  end

  depends_on 'hepmc'
  depends_on 'fastjet'
  depends_on 'gsl'
  depends_on 'boost'
  depends_on 'yoda'
  depends_on 'yaml-cpp'
  depends_on :python
  option 'with-check', 'Test during installation'

  def patches
    # Fix compilation bug, correct rivet-config for Mac
    #DATA
  end unless build.head?

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    system "autoreconf", "-i" if build.head?
    system "export PATH=/usr/local/bin/:$PATH"
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? 'check'
    system "make", "install"

    prefix.install 'test'
    bash_completion.install share/'Rivet/rivet-completion'
  end

  test do
    system "cat #{prefix}/test/testApi.hepmc | rivet -a D0_2008_S7554427"
    ohai "Successfully ran dummy HepMC file through Drell-Yan analysis"
  end
end

__END__