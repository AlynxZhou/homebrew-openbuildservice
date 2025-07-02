class ObsServiceDownloadUrl < Formula
  desc "OBS download URL service"
  homepage "https://github.com/openSUSE/obs-service-download_url"
  url "https://github.com/openSUSE/obs-service-download_url/archive/0.2.1.tar.gz"
  sha256 "218a3c3ef63fdf7022004e37f07870984279cfe2a2f84a402838079a26333711"
  license "GPL-2.0"

  depends_on "wget"

  def install
    (lib/"obs/service").install "download_url"
    (lib/"obs/service").install "download_url.service"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test obs-service-download_url`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system bin/"program", "do", "something"`.
    # system "false"
  end
end
