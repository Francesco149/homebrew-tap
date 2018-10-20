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

  def install
    virtualenv_install_with_resources
    appdir = buildpath/"qutebrowser.app/Contents/"
    (appdir/"Info.plist").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleDisplayName</key>
        <string>qutebrowser</string>
        <key>CFBundleDocumentTypes</key>
        <array>
          <dict>
            <key>CFBundleTypeExtensions</key>
            <array>
              <string>html</string>
              <string>htm</string>
            </array>
            <key>CFBundleTypeMIMETypes</key>
            <array>
              <string>text/html</string>
            </array>
            <key>CFBundleTypeName</key>
            <string>HTML document</string>
            <key>CFBundleTypeOSTypes</key>
            <array>
              <string>HTML</string>
            </array>
            <key>CFBundleTypeRole</key>
            <string>Viewer</string>
          </dict>
          <dict>
            <key>CFBundleTypeExtensions</key>
            <array>
              <string>xhtml</string>
            </array>
            <key>CFBundleTypeMIMETypes</key>
            <array>
              <string>text/xhtml</string>
            </array>
            <key>CFBundleTypeName</key>
            <string>XHTML document</string>
            <key>CFBundleTypeRole</key>
            <string>Viewer</string>
          </dict>
        </array>
        <key>CFBundleExecutable</key>
        <string>MacOS/qutebrowser</string>
        <key>CFBundleIconFile</key>
        <string>qutebrowser.icns</string>
        <key>CFBundleIdentifier</key>
        <string>org.qt-project.Qt.QtWebEngineCore</string>
        <key>CFBundleInfoDictionaryVersion</key>
        <string>6.0</string>
        <key>CFBundleName</key>
        <string>qutebrowser</string>
        <key>CFBundlePackageType</key>
        <string>APPL</string>
        <key>CFBundleShortVersionString</key>
        <string>#{version}</string>
        <key>CFBundleURLTypes</key>
        <array>
          <dict>
            <key>CFBundleURLName</key>
            <string>http(s) URL</string>
            <key>CFBundleURLSchemes</key>
            <array>
              <string>http</string>
              <string>https</string>
            </array>
          </dict>
          <dict>
            <key>CFBundleURLName</key>
            <string>local file URL</string>
            <key>CFBundleURLSchemes</key>
            <array>
              <string>file</string>
            </array>
          </dict>
        </array>
        <key>CFBundleVersion</key>
        <string>#{version}</string>
        <key>NSHighResolutionCapable</key>
        <true/>
        <key>NSSupportsAutomaticGraphicsSwitching</key>
        <true/>
      </dict>
      </plist>
    EOS
    script = appdir/"MacOS/qutebrowser"
    script.write <<~EOS
      #!/usr/bin/osascript
      on run
        do shell script "#{prefix}/bin/qutebrowser"
      end run
      on open location this_URL
        do shell script "#{prefix}/bin/qutebrowser '" & this_URL & "'"
      end open location
    EOS
    script.chmod(0755)
    (appdir/"Resources").install "icons/qutebrowser.icns"
    prefix.install "qutebrowser.app"
  end

  def caveats
    <<~EOS
      to see qutebrowser in spotlight and in the default browser
      settings, link the .app by running
      ln -s #{prefix}/qutebrowser.app /Applications
    EOS
  end
end
