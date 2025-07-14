class ObsServiceFormatSpecFile < Formula
  desc "An OBS source service: reformats a spec file to SUSE standard"
  homepage "https://github.com/openSUSE/obs-service-format_spec_file"
  license "GPL-2.0"
  head "https://github.com/openSUSE/obs-service-format_spec_file.git"

  depends_on "obs-service-source_validator"

  uses_from_macos "perl"

  def install
    inreplace "format_spec_file", "/usr/lib/obs/service", "#{HOMEBREW_PREFIX}/lib/obs/service"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test obs-service-format_spec_file`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system bin/"program", "do", "something"`.
    # system "false"
  end
end
