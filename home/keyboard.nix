_: {
  # Caps Lock and Right Command become system-wide F13 keys for Herdr's prefix.
  # hidutil clears mappings on reboot, so launchd reapplies them at login.
  launchd.agents.capslock-to-f13 = {
    enable = true;
    config = {
      ProgramArguments = [
        "/usr/bin/hidutil"
        "property"
        "--set"
        ''{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x700000068},{"HIDKeyboardModifierMappingSrc":0x7000000E7,"HIDKeyboardModifierMappingDst":0x700000068}]}''
      ];
      RunAtLoad = true;
      ProcessType = "Interactive";
    };
  };
}
