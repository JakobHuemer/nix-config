{ inputs, config, pkgs, vars, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    ./configuration.nix
  ];

}
