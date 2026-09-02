# TODO: drop once https://www.opencode.net/trialuser/qt6ct/-/merge_requests/11 is merged and released
final: prev: {
  qt6Packages = prev.qt6Packages.overrideScope (_: qtPrev: {
    qt6ct = qtPrev.qt6ct.overrideAttrs (old: {
      patches = (old.patches or []) ++ [./qt6ct-proxystyle-recursion.patch];
    });
  });
}
