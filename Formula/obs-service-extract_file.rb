class ObsServiceExtractFile < Formula
  desc "OBS source service to extract files from tar balls, eg .spec files maintained inside of the tar ball."
  homepage "https://github.com/openSUSE/obs-service-extract_file"
  license "GPL-2.0"
  head "https://github.com/openSUSE/obs-service-extract_file.git"

  depends_on "xz"

  uses_from_macos "tar"
  uses_from_macos "bzip2"
  uses_from_macos "gzip"
  uses_from_macos "unzip"

  def install
    (lib/"obs/service").install "extract_file"
    (lib/"obs/service").install "extract_file.service"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test obs-service-extract_file`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system bin/"program", "do", "something"`.
    # system "false"
  end
end
