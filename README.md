personal homebrew tap

# qutebrowser
the qutebrowser in cask doesn't have proprietary codecs. this uses
your system qt which, unless installed with
```--without-proprietary-codecs```, should enable h264, mp3 and
other missing codecs.

```
brew install Francesco149/homebrew-tap/qutebrowser
ln -s /usr/local/Cellar/qutebrowser/*/qutebrowser.app /Applications
```
