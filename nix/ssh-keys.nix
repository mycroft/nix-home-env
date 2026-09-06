# Public keys of the hosts this configuration runs on.
#
# Shared by modules/ssh (authorized_keys) and modules/git (allowed_signers):
# every host must know every other host's key, otherwise commits signed
# elsewhere show up as unverified locally.
[
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMek8Cn3KNlEeHP2f9vZCbx/hzNc3xzJI9+2FM7Mbx5y mycroft@nee.mkz.me"
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIASLd/ou8xDr81AKt37sMTad2jKNyRqF614kdJG829zp mycroft@glitter.mkz.me"
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAPskz9xwVWyXUThFepyY4FZ+E5yXm8S2/vWpjrMxYLh mycroft@saisei.mkz.me"
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBrxhZWTz6HibWjvQrGxTLhBrcwnCh6QquTlIgmaM4qr mycroft@mugen-mirai"
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMe61/AweJnRt1334tUGa/UtSlMSqZjkjFqU+4aqOMp8 mycroft@relax"
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILJ03nZ3GAXaeZwklJYcTuA3ra/DyYgtWv9zmA2e27bV mycroft@quantum.lan.mkz.me"
]
