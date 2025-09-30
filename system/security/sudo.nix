{
  pkgs,
  userSettings,
  ...
}: {
  security.sudo = {
    enable = true;
    execWheelOnly = false;
    wheelNeedsPassword = false;
    extraRules = [
      {
        groups = ["wheel"];
        host = "ALL";
        runAs = "ALL:ALL";
        commands = [
          {
            command = "ALL";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };
}
