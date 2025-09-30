{ pkgs, userSettings, ... }:

{
  security.sudo = {
    enable = true;
    execWheelOnly = false;
    wheelNeedsPassword = false;
    security.sudo.extraRules = [
      {
        groups = ["wheel"];
        host = "ALL";
        runAs = "ALL:ALL";
        commands = [
          {
            command = "ALL";
            options = [ "NOPASSWWD" ];
          }
        ];
      }
    ];
  };
}
