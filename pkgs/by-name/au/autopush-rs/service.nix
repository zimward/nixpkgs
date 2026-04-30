# Non-module dependencies (`importApply`)
{ }:

# Service module
{
  lib,
  config,
  ...
}:
let
  cfg = config.autopush-rs;
in
{
  _class = "service";
  options = {
    package = lib.mkOption {
      description = "Package to use for autopush-rs.";
      defaultText = "The autopush-rs package that provided this module.";
      type = lib.types.package;
    };
    redisEndpoint = lib.mkOption {
      description = "Endpoint of the Redis server. If unset local redis will be configured.";
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };
  config = {
    services.redis = lib.mkIf (cfg.redisEndpoint == null) {
      servers.autopush-rs = {
        enable = true;
      };
    };
  };
}
