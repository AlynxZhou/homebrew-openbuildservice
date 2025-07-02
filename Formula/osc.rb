class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/refs/tags/1.17.0.tar.gz"
  sha256 "12e1d4fcca71a5b8e23dfc6476292d6c70bdda240ac597b7664d6df7aea90469"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "curl"
  uses_from_macos "libffi"

  resource "rpm" do
    url "https://files.pythonhosted.org/packages/bd/ce/8db44d2b8fd6713a59e391d12b6816854b7bee8121ae7370c2d565de4265/rpm-0.4.0.tar.gz"
    sha256 "79adbefa82318e2625d6e4fa16666cf88543498a1f2c10dc3879165d1dc3ecee"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/39/87/6da0df742a4684263261c253f00edd5829e6aca970fff69e75028cccc547/ruamel.yaml-0.18.14.tar.gz"
    sha256 "7227b76aaec364df15936730efbf7d72b30c0b79b1d578bbb8e3dcb2d81f52b7"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/20/84/80203abff8ea4993a87d823a5f632e4d92831ef75d404c9fc78d0176d2b5/ruamel.yaml.clib-0.2.12.tar.gz"
    sha256 "6c8fbb13ec503f99a91901ab46e0b07ae7941cd527393187039aec586fdfd36f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/70/09/d904a6e96f76ff214be59e7aa6ef7190008f52a0ab6689760a98de0bf37d/keyring-25.6.0.tar.gz"
    sha256 "0b39998aa941431eb3d9b0d4b2460bc773b9df6fed7621c2dfb291a7e0187a66"
  end

  def install
    # FIXME: inreplace does not accept dir.
    # inreplace "." do |s|
    #   # NOTE: At least I don't see this dirs on Arch.
    #   s.gsub! "/usr/lib/osc", "#{HOMEBREW_PREFIX}/lib/osc"
    #   s.gsub! "/usr/lib64/osc", "#{HOMEBREW_PREFIX}/lib/osc"
    #   s.gsub! "/usr/libexec/osc", "#{HOMEBREW_PREFIX}/lib/osc"
    #   # FIXME: Replace them with obs-build's dir once we can package obs-build.
    #   s.gsub! "/usr/bin/build", "#{HOMEBREW_PREFIX}/bin/build"
    #   s.gsub! "/usr/lib/build", "#{HOMEBREW_PREFIX}/lib/build"
    #   s.gsub! "/usr/bin/vc", "#{HOMEBREW_PREFIX}/bin/vc"
    # end
    inreplace "osc/conf.py", "/usr/lib/obs/service", "#{HOMEBREW_PREFIX}/lib/obs/service"
    inreplace "osc/obs_scm/serviceinfo.py", "/usr/lib/obs/service", "#{HOMEBREW_PREFIX}/lib/obs/service"
    virtualenv_install_with_resources
  end

  def post_install
    (HOMEBREW_PREFIX/"lib/obs/service").mkpath
  end

  def caveats
    <<~EOS
      OBS services will be installed at:
        #{HOMEBREW_PREFIX}/lib/obs/service
    EOS
  end

  test do
    test_config = testpath/"oscrc"
    ENV["OSC_CONFIG"] = test_config

    test_config.write <<~INI
      [general]
      apiurl = https://api.opensuse.org

      [https://api.opensuse.org]
      credentials_mgr_class=osc.credentials.TransientCredentialsManager
      user=brewtest
      pass=
    INI

    output = shell_output("#{bin}/osc status 2>&1", 1).chomp
    assert_match "Directory '.' is not a working copy", output
    assert_match "Please specify a command", shell_output("#{bin}/osc 2>&1", 2)
  end
end
