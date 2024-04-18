{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nodejs_21
    #nodePackages.rollup
    tailwindcss-language-server
    nodePackages.svelte-language-server
    # Not working
    prettierd
    # As long as prettierd is not working
    nodePackages.prettier
    nodePackages.typescript-language-server
  ];
}
