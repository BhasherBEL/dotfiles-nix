{ pkgs, ... }:
{

  environment = {
    systemPackages = with pkgs; [
      google-java-format
      #vimPlugins.nvim-jdtls
      jdt-language-server
      jdk
    ];

    sessionVariables = {
      _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
      JAVA_HOME = "${pkgs.jdk.home}/lib/openjdk";
    };
  };
}
