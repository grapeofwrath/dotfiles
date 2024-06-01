{pkgs,...}:
let
  tm = "${pkgs.tmux}";
  # dir = "/home/${config.users.users.grape.name}/minecraft-servers/fabric/savagecraft";
  # dir = config.home.homeDirectory;
in
pkgs.writeShellScriptBin "savagecraft" ''
  case $1 in
    start)
      ${tm} new-session -s minecraft -d
      sleep 1
      ${tm} send -t minecraft "java -Xmx10G -Xms10G -jar ./server.jar --nogui" ENTER
      ;;
    stop)
      ${tm} send -t minecraft /saveall ENTER
      ${tm} send -t minecraft /stop ENTER
      echo "Shutting down minecraft session"
      ${tm} kill-session -t minecraft
      ;;
    *)
      echo "I have no memory of this command..."
      ;;
  esac
''
