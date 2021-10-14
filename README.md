
## Jami Qt Client is in beta:
```sh
flatpak remote-add --user flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
flatpak install --user flathub-beta net.jami.Jami
```


## Bugs (Gnome Client):

### crashes when activating the webcam
open `~/.var/app/net.jami.Jami/config/jami/dring.yml` and change the two following lines:
```yml
decodingAccelerated: true
encodingAccelerated: true
```
https://git.jami.net/savoirfairelinux/jami-daemon/-/issues/614

### missing or wrong tray icon
no idea, please make a pull request


## Bugs (Qt Client):

### no native file picker
please submit your ideas
