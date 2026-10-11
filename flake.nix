{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    nur.url = "github:nix-community/NUR";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    easy-action = {
      url = "github:Weissle/easy-action";
      flake = false;
    };
    tree-sitter-manager = {
      url = "github:romus204/tree-sitter-manager.nvim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      vars = builtins.fromJSON (builtins.readFile ./variables.json);
      hostname = vars.hostname;
      username = vars.username;
    in
    {
      nixosConfigurations.${hostname} = lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs username; };
      modules = [
        ./hardware-configuration.nix
        inputs.nixvim.nixosModules.nixvim
        inputs.sops-nix.nixosModules.sops
        ./flakes/rclone.nix
        ./flakes/aerc.nix
        ./flakes/waydroid.nix
        ./flakes/fcitx.nix
        ./flakes/tailscale.nix
        ./flakes/zsh.nix
        ./flakes/mounts.nix
        ./flakes/amdgpu.nix
        ./flakes/kdeconnect.nix
        ./flakes/packages.nix
        ./flakes/neovim.nix

        ({ config, lib, pkgs, ... }: {
          networking.hostName = hostname;

          fileSystems."/".options = [ "noatime" ];

          boot = {
            kernel.sysctl = {
              "vm.dirty_background_bytes" = 67108864;
              "vm.dirty_bytes" = 268435456;
              "vm.max_map_count" = 2147483642;
              "vm.swappiness" = 100;
              "vm.vfs_cache_pressure" = 50;
            };
            kernelPackages = pkgs.linuxPackages_zen;
            loader = {
              efi.canTouchEfiVariables = true;
              systemd-boot = {
                enable = true;
                configurationLimit = 5;
              };
            };
          };

          console = {
            font = "Lat2-Terminus16";
            keyMap = "jp106";
          };

          networking = {
            networkmanager.enable = true;
            firewall = {
              trustedInterfaces = [ "tailscale0" ];
              checkReversePath = "loose";
            };
          };

          time.timeZone = "Asia/Tokyo";

          security = {
            audit.enable = false;
            rtkit.enable = true;
            polkit.enable = true;
          };

          xdg.portal = {
            enable = true;
            wlr.enable = true;
            extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
          };

          fonts.packages = with pkgs; [
            nerd-fonts.iosevka-term
            iosevka
            font-awesome
          ];

          hardware = {
            graphics = {
              enable = true;
              enable32Bit = true;
            };
            bluetooth = {
              enable = true;
              settings = {
                General = {
                  Experimental = true;
                  FastConnectable = true;
                };
                Policy.AutoEnable = true;
              };
            };
            steam-hardware.enable = true;
          };
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = [ inputs.nur.overlays.default ];

          i18n = {
            defaultLocale = "en_US.UTF-8";
          };

          systemd = {
            coredump.enable = false;
            oomd.enable = false;
            services = {
              NetworkManager-wait-online.enable = false;
              systemd-udev-settle.enable = false;
            };
          };

          programs = {
            sway.enable = true;
            gamemode.enable = true;

            gamescope = {
              enable = true;
              capSysNice = true;
            };

            steam = {
              enable = true;
              remotePlay.openFirewall = true;
              gamescopeSession.enable = true;
            };
          };

          services = {
            pipewire = {
              enable = true;
              alsa.enable = true;
              alsa.support32Bit = true;
              pulse.enable = true;
            };
            xserver.desktopManager.runXdgAutostartIfNone = true;
            displayManager.ly = {
              enable = true;
              settings = {
                animate = true;
                animation = "matrix";
              };
            };
            openssh = {
              enable = true;
              settings.PermitRootLogin = "no";
            };
            blueman.enable = true;

            scx = {
              enable = true;
              scheduler = "scx_lavd";
            };
          };

          users = {
            defaultUserShell = pkgs.zsh;
            users.${username} = {
              isNormalUser = true;
              extraGroups = [ "wheel" "networkmanager" ];
            };
          };

          zramSwap = {
            enable = true;
            algorithm = "zstd";
            memoryPercent = 200;
            priority = 100;
          };

          boot.tmp.useZram = true;

          system.stateVersion = "26.05";
        })

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.${username} = { pkgs, inputs, ... }: {
          imports = [
            ./home/sway.nix
            ./home/waybar.nix
            ./home/wofi.nix
            ./home/kitty.nix
            ./home/mako.nix
            ./home/zen-browser.nix
            ./home/packages.nix
          ];

          home.stateVersion = "26.05";
          };
        }
      ];
    };
  };
}
