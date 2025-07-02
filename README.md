Alynx Zhou's Homebrew Tap for Open Build Service Tools
======================================================

This is still working in progress so it may or may not work.

# What I did in this tap?

I modified the `osc` formula in homebrew-core to make it load OBS service from `${HOMEBREW_PREFIX}/lib/obs/service` instead of hard-coded `/usr/lib/obs/service`. Then I created formulae for OBS service to install them into that path.

While those formulae can be installed, OBS service typically depends on `obs-build` for some scripts, however because macOS by default use case-insensitive file system, it cannot be extracted and installed (<https://github.com/openSUSE/obs-build/issues/1082>), so `obs-build` is not listed as a dependencies in formulae and they may not run. I don't suggest you to reformat your macOS file system to make it case-sensitive, it will break some (Adobe) apps.

Tests are not implemented in those formulae because they require extra dependencies, and I don't have time to gather all dependencies. I'll be very grateful if you can help.

Don't install those formulae on Linux with Homebrew! You should use your Linux distro's package manager, I won't try to make them work with Homebrew on Linux.

# How do I install these formulae?

`brew install alynxzhou/openbuildservice/<formula>`

Or `brew tap alynxzhou/openbuildservice` and then `brew install <formula>`.

Or, in a `brew bundle` `Brewfile`:

```ruby
tap "alynxzhou/openbuildservice"
brew "<formula>"
```

# Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
