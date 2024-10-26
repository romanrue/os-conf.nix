{ config, inputs, pkgs, ... }:

{
  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  imports =
    [
      ./hardware-configuration.nix
      ../common/sops.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "test-vm"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  sops.secrets.user-roman-hashedpwd = {
    sopsFile = ../common/secrets.yaml;
    neededForUsers = true;
  };

  users.users.roman = {
    isNormalUser = true;
    description = "Roman Ruttimann";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      neovim
    ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCraoG7KlM11T0SEtcdqqvpE7VXdaXzjjTL36Wo3ATr8jj5jh+shL6iR08RXc1ZxxVeq7iV3CRXAV5HanCFb2nR6cnqX32D5EWKG7qi7dWhu7bkD8od1YPCHLlYoXkFvAGfFq8VMSNR7frYb+58hstOixUz0N/Ze4cBbFtIvHzI6DUUxEmch7PO95VM4GPTQh1QKVCkq7EAZ0noRLx7FBzvNIhqJ5B6KeykPd8y+8H6NFb4jakeH0YrmeNlY6KpqoOgQMjVklhZp4gVZbraV1W1HkIdVnD7OZOUao7szcV3CavNCo5HYDa4gXj/3yHgnozaS8IOpt+Yv5yiNGSbDN4HsUTtVE7Qhf1z7Su80qXcKj0gT7M0m0Vdx4LQgnoFRPScaesz1+MGklyDVwAzQdoE+M/qAj+l7X3z2Of4+/F+p/QQYqSQiq4r6iqIXgCfqPUYQ8h2ZlqsxQtub8BQAWRdCK751FCzOJiZ8NfxCXRNTG7m2cDlLBw6OM3Qq9hlwZCcvnPCtWFE/EFsfgW7i8Lg1s1K8sP2RPBNdGIPDifjfdmSXpfhriUEDSdi+FIiNR0gdDoDYu4MkRK06ML7cIEgx+f6unHgXipWxNKhW9zFp+0qpazglroATlIzbfLua0okAWrG3loyA6ZPTTjC7V6ag81zKZQftWJm7KEOlKfbdw== openpgp:0x314776CD" ];
    hashedPasswordFile = config.sops.secrets.user-roman-hashedpwd.path;
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    curl
    fzf
    git
    gnupg
    pinentry
    python3
    ripgrep
    sops
    wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.ssh.startAgent = false;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
    hostKeys = [
      { path = "/etc/ssh/ssh_host_ed25519_key"; type = "ed25519"; }
    ];
  };

  system.stateVersion = "24.05"; # Did you read the comment?
}
