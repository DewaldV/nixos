{ ... }:

{
  profiles.machines.vm = {
    enable = true;
    address = "10.50.0.2";
    gateway = "10.50.0.1";
  };

  system.stateVersion = "25.11";
}
