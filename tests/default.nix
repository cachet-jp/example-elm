{
  pkgs,
  package,
}: {
  name = "integration test";
  nodes = {
    server = {
      systemd.services.server = {
        wantedBy = ["multi-user.target"];
        script = "${package}/bin/example-elm";
      };
      networking.firewall.enable = false;
    };
    client = {
      environment.systemPackages = [
        pkgs.curl
      ];
    };
  };

  testScript = ''
    start_all()

    with subtest('connect to server'):
      client.wait_for_unit('default.target');
      server.wait_for_unit('server.service');
      assert '<title>Elm Example</title>' in client.succeed('curl --location --insecure http://server:8000/')
  '';
}
