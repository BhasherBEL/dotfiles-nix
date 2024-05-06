{ pkgs, ... }:
{

  environment = {
    systemPackages = with pkgs; [
      google-java-format
      #vimPlugins.nvim-jdtls
      jdt-language-server
      jdk
      # temp
      jetbrains.idea-community
    ];

    sessionVariables = {
      _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
      #JAVA_HOME = "${pkgs.jdk.home}";
    };
  };

  programs.java.enable = true;
}
