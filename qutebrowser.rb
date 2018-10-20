class Qutebrowser < Formula
  include Language::Python::Virtualenv

  desc "A keyboard-driven, vim-like browser based on PyQt5 and QtWebEngine"
  homepage "https://github.com/qutebrowser/qutebrowser"
  url "https://github.com/qutebrowser/qutebrowser/archive/v1.5.1.tar.gz"
  sha256 "55e68ef3386fe1d695ba52fb9a239fed1f89e4b09280c10cac143bc7526b039b"
  head "https://github.com/qutebrowser/qutebrowser.git"

  conflicts_with cask: "qutebrowser", :because =>
    "the cask binaries ship with their own version of "\
    "qt which doesn't include proprietary codecs"

  depends_on "python"
  depends_on "pyqt"

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"
    sha256 "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/4d/de/32d741db316d8fdb7680822dd37001ef7a448255de9699ab4bfcbdf4172b/MarkupSafe-1.0.tar.gz"
    sha256 "a6be69091dac236ea9c6bc7d012beab42010fa914c459791d627dad4910eb665"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/56/e6/332789f295cf22308386cf5bbd1f4e00ed11484299c5d7383378cf48ba47/Jinja2-2.10.tar.gz"
    sha256 "f84be1bb0040caca4cea721fcbbbbd61f9be9464ca236387158b0feea01914a4"
  end

  resource "pyPEG2" do
    url "http://fdik.org/pyPEG2/pyPEG2-2.15.2.tar.gz"
    sha256 "e2c2486742691054b4d1fc59e9476df1a2fa254e49d599e322e1cfa879130bdc"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/0f/9e/26b1d194aab960063b266170e53c39f73ea0d0d3f5ce23313e0ec8ee9bdf/attrs-18.2.0.tar.gz"
    sha256 "10cbf6e27dbce8c30807caf056c8eb50917e0eaafe86347671b57254006c3e69"
  end

  resource "MacQutebrowser" do
    url "https://github.com/Francesco149/MacQutebrowser/releases/download/1.0.0/MacQutebrowser.zip"
    sha256 "6bba682a0519689208ea70348654e0a8c3cd8971384f7a06ca406038e8cecac0"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources
      .select { |x| x.name != "MacQutebrowser" }
    venv.pip_install_and_link buildpath
    (prefix/"MacQutebrowser.app")
      .install resource("MacQutebrowser")
  end

  def caveats
    <<~EOS
      the app bundle wrapper is named MacQutebrowser and it's
      unsigned, so you might need to allow it to run the first time

      install the app bundle with

        cp -r #{prefix}/MacQutebrowser.app /Applications
    EOS
  end
end
