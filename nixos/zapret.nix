{ inputs, config, pkgs, ... }:

{
  services.zapret-discord-youtube = {
    enable = true;
    strategy = "general_alt12.bat";

    fakeFiles = {
      "tls_clienthello_www_onetrust_com.bin" = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/ewgen198409/zapret-openwrt/24.10/zapret/files/fake/tls_clienthello_www_onetrust_com.bin";
        sha256 = "4ee0870abe0a0128600b0095189987ba1d210dae8bf963bc725aff49cf922624";
      };
      "stun2.bin" = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/ewgen198409/zapret-openwrt/24.10/zapret/files/fake/stun2.bin";
        sha256 = "b7c2497496039c541f7337ac8536813f0a1cf52363ab2faa5213b7816d458813";
      };
      "tls_clienthello_5ka_ru.bin" = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/ewgen198409/zapret-openwrt/24.10/zapret/files/fake/tls_clienthello_5ka_ru.bin";
        sha256 = "066h13n6h6cg5qb8b3pm3k5zxhcpymm1d9iqglkml72rfbi7320y";
      };
    };

    hostlists.extra = {
      "zapret-hosts-google.txt" = {
        source = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/ewgen198409/zapret-openwrt/24.10/zapret/ipset/zapret-hosts-google.txt";
          sha256 = "f7c531f964a59bcad6b00d6dd3676a0e32d337016010227eb7efa5b30df8f4a0";
        };
      };
      "zapret-hosts-user-exclude.txt" = {
        source = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/ewgen198409/zapret-openwrt/24.10/zapret/ipset/zapret-hosts-user-exclude.txt";
          sha256 = "a55a5780c31f91fae51602e548cdfb6b4e0badfe40365a708a5a0ff82a1fc69d";
        };
      };
    };

    extraCustomStrategies."general_alt11_onetrust.bat" = ''
      --wf-tcp=80,443 --wf-udp=443
      --filter-tcp=443 --hostlist="%LISTS%zapret-hosts-google.txt" --ip-id=zero --dpi-desync=fake,multisplit --dpi-desync-split-seqovl=681 --dpi-desync-split-pos=1 --dpi-desync-fooling=ts --dpi-desync-repeats=8 --dpi-desync-split-seqovl-pattern="%BIN%tls_clienthello_www_google_com.bin" --dpi-desync-fake-tls="%BIN%tls_clienthello_www_google_com.bin" --new
      --filter-tcp=80,443 --hostlist-exclude="%LISTS%zapret-hosts-user-exclude.txt" --dpi-desync=fake,multisplit --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-fooling=ts --dpi-desync-repeats=12 --dpi-desync-split-seqovl-pattern="%BIN%tls_clienthello_5ka_ru.bin" --dpi-desync-fake-tls="%BIN%stun2.bin" --dpi-desync-fake-tls="%BIN%tls_clienthello_5ka_ru.bin" --dpi-desync-fake-http="%BIN%tls_clienthello_5ka_ru.bin" --new
    '';
  };
}
