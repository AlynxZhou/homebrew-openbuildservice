class ObsServiceTarScm < Formula
  include Language::Python::Virtualenv

  desc "An OBS source service: fetches code from any SCM and archives it"
  homepage "https://github.com/openSUSE/obs-service-tar_scm"
  url "https://github.com/openSUSE/obs-service-tar_scm/archive/0.10.41.tar.gz"
  sha256 "5b30f448b6eb4a55a7af6ec6e8c5fa20aba3f1d34cdd8028821f9f55e7ddd803"
  license "GPL-2.0"

  depends_on "python@3.13"

  on_macos do
    depends_on "findutils" => :build
    depends_on "coreutils" => :build
  end

  uses_from_macos "curl"
  uses_from_macos "cpio" => :optional
  uses_from_macos "git" => :optional

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  def install
    # obs-service-tar_scm itself is not a pip package, so we cannot use
    # virtualenv_install_with_resources, we need to install resources manually.
    # Create a virtualenv in `libexec`.
    venv = virtualenv_create(libexec)
    # Install all of the resources declared on the formula into the virtualenv.
    venv.pip_install resources
    # This Makefile requires GNU find and install.
    ENV.prepend_path "PATH", Formula["findutils"].libexec/"gnubin" if OS.mac?
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" if OS.mac?
    system "make", "PREFIX=#{prefix}", "SYSCFG=#{etc}", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test obs-service-tar_scm`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system bin/"program", "do", "something"`.
    # system "false"
  end
end
