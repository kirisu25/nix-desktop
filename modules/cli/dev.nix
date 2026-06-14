{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nix-ld
    # Rust
    # (fenix.combine [
    #   fenix.stable.toolchain
    # ])

    # Go
    # go

    # JS/TS
    # nodejs-slim
    # deno
  ];
}
