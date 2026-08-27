_: {
  # Caps Lock becomes a system-wide F13 key that any application can bind.
  # hidutil clears mappings on reboot, so launchd reapplies it at login.
  launchd.agents.capslock-to-f13 = {
    enable = true;
    config = {
      ProgramArguments = [
        "/usr/bin/hidutil"
        "property"
        "--set"
        ''{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x700000068}]}''
      ];
      RunAtLoad = true;
      ProcessType = "Interactive";
    };
  };
}
