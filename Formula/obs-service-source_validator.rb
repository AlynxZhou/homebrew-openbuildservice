class ObsServiceSourceValidator < Formula
  desc "The default source validator as used by openSUSE:Factory distribution"
  homepage "https://github.com/openSUSE/obs-service-source_validator"
  url "https://github.com/openSUSE/obs-service-source_validator/archive/0.42.tar.gz"
  sha256 "693b753855ea9b781b177d27b7e13999700e558b4dabbda8ade6b147ccbdb9de"
  license "GPL-2.0"

  depends_on "gnupg"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "perl"
  uses_from_macos "bzip2"
  uses_from_macos "cpio"
  uses_from_macos "diffutils"
  uses_from_macos "libxml2"
  uses_from_macos "patch"
  uses_from_macos "unzip"

  on_linux do
    resource "DateTime" do
      url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-1.65.tar.gz"
      sha256 "0bfda7ff0253fb3d88cf4bdb5a14afb8cea24d147975d5bdf3c88b40e7ab140e"
    end

    resource "DateTime::Locale" do
      url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-Locale-1.42.tar.gz"
      sha256 "7d8a138fa32faf24af30a1dbdee4dd11988ddb6a129138004d220b6cc4053cb0"
    end

    resource "DateTime::TimeZone" do
      url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/DateTime-TimeZone-2.62.tar.gz"
      sha256 "6214f9c9c8dfa2000bae912ef2b8ebc5b163a83a0b5b2a82705162dad63466fa"
    end

    resource "Math::Round" do
      url "https://cpan.metacpan.org/authors/id/N/NE/NEILB/Math-Round-0.08.tar.gz"
      sha256 "7b4d2775ad3b859a5fd61f7f3fc5cfba42b1a10df086d2ed15a0ae712c8fd402"
    end

    resource "namespace::autoclean" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/namespace-autoclean-0.29.tar.gz"
      sha256 "45ebd8e64a54a86f88d8e01ae55212967c8aa8fed57e814085def7608ac65804"
    end

    resource "namespace::clean" do
      url "https://cpan.metacpan.org/authors/id/R/RI/RIBASUSHI/namespace-clean-0.27.tar.gz"
      sha256 "8a10a83c3e183dc78f9e7b7aa4d09b47c11fb4e7d3a33b9a12912fd22e31af9d"
    end

    resource "Eval::Closure" do
      url "https://cpan.metacpan.org/authors/id/D/DO/DOY/Eval-Closure-0.14.tar.gz"
      sha256 "ea0944f2f5ec98d895bef6d503e6e4a376fea6383a6bc64c7670d46ff2218cad"
    end

    resource "Params::Validate" do
      url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Params-Validate-1.31.tar.gz"
      sha256 "1bf2518ef2c4869f91590e219f545c8ef12ed53cf313e0eb5704adf7f1b2961e"
    end

    resource "Params::ValidationCompiler" do
      url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Params-ValidationCompiler-0.31.tar.gz"
      sha256 "7b6497173f1b6adb29f5d51d8cf9ec36d2f1219412b4b2410e9d77a901e84a6d"
    end

    resource "Specio::Exporter" do
      url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Specio-0.48.tar.gz"
      sha256 "0c85793580f1274ef08173079131d101f77b22accea7afa8255202f0811682b2"
    end

    resource "Module::Build" do
      url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4234.tar.gz"
      sha256 "66aeac6127418be5e471ead3744648c766bd01482825c5b66652675f2bc86a8f"
    end

    resource "Module::Implementation" do
      url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Module-Implementation-0.09.tar.gz"
      sha256 "c15f1a12f0c2130c9efff3c2e1afe5887b08ccd033bd132186d1e7d5087fd66d"
    end

    resource "Module::Runtime" do
      url "https://cpan.metacpan.org/authors/id/Z/ZE/ZEFRAM/Module-Runtime-0.016.tar.gz"
      sha256 "68302ec646833547d410be28e09676db75006f4aa58a11f3bdb44ffe99f0f024"
    end
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        if File.exist? "Makefile.PL"
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make"
          system "make", "install"
        else
          system "perl", "Build.PL", "--install_base", libexec
          system "./Build"
          system "./Build", "install"
        end
      end
    end

    inreplace "source_validator", "/usr/lib/obs/service", "#{HOMEBREW_PREFIX}/lib/obs/service"
    inreplace "30-patches-applied", "/usr/lib/obs/service", "#{HOMEBREW_PREFIX}/lib/obs/service"
    inreplace "40-sequence-changes", "/usr/lib/obs/service", "#{HOMEBREW_PREFIX}/lib/obs/service"
    inreplace "45-stale-changes", "/usr/lib/obs/service", "#{HOMEBREW_PREFIX}/lib/obs/service"
    inreplace "50-spec-version", "/usr/lib/obs/service", "#{HOMEBREW_PREFIX}/lib/obs/service"
    inreplace "60-spec-filelist", "/usr/lib/obs/service", "#{HOMEBREW_PREFIX}/lib/obs/service"
    inreplace "70-baselibs", "/usr/lib/obs/service", "#{HOMEBREW_PREFIX}/lib/obs/service"
    inreplace "helpers/check_debian_source_changes", "/usr/lib/obs/service", "#{HOMEBREW_PREFIX}/lib/obs/service"
    inreplace "helpers/fix_changelog", "/usr/lib/obs/service", "#{HOMEBREW_PREFIX}/lib/obs/service"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test obs-service-source_validator`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system bin/"program", "do", "something"`.
    # system "false"
  end
end
