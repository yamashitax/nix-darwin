{
  inputs,
  ...
}: {
  modifications = final: prev: {
    helix = prev.helix.overrideAtttrs(finalAttrs: {
      patches = [
        (pkgs.fetchpatch {
          url = "https://patch-diff.githubusercontent.com/raw/helix-editor/helix/pull/6865.patch";
          hash = "sha256-qI+seNGaW/p8iiV1HVVcm/acJ8IRWVslEkQPJAHNsxo=";
        })
      ];
    });
  };
}
