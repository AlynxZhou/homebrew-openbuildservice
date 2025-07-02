class ObsServiceSetVersion < Formula
  include Language::Python::Virtualenv

  desc "An OBS source service: Update spec file version"
  homepage "https://github.com/openSUSE/obs-service-set_version"
  url "https://github.com/openSUSE/obs-service-set_version/archive/0.6.5.tar.gz"
  sha256 "198eea99e2d513a57d10ef0cbfe2e1a37303d7914c70d53e1b2ce5e020244de3"
  license "GPL-2.0"

  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  def install
    # obs-service-set_version itself is not a pip package, so we cannot use
    # virtualenv_install_with_resources, we need to install resources manually.
    # Create a virtualenv in `libexec`.
    venv = virtualenv_create(libexec)
    # Install all of the resources declared on the formula into the virtualenv.
    venv.pip_install resources
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test obs-service-set_version`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system bin/"program", "do", "something"`.
    # system "false"
  end
end
