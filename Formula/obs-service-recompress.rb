class ObsServiceRecompress < Formula
  desc "An OBS source service: Recompress files"
  homepage "https://github.com/openSUSE/obs-service-recompress"
  url "https://github.com/openSUSE/obs-service-recompress/archive/0.5.2.tar.gz"
  sha256 "6341709088e5d18cadaf8f3425a7c512f0eca7539f83885ed41c7ce5170b5efc"
  license "GPL-2.0"

  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "gzip"

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test obs-service-recompress`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system bin/"program", "do", "something"`.
    # system "false"
  end
end
