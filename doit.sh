#!/bin/sh

# Run this from any OS
if [ -z "$HCLOUD_TOKEN" ]; then
	echo "Meh.. no token no server"
	echo "Please set HCLOUD_TOKEN env var"
	echo "You will get one from the Hetzner cloud console"
	exit 1
fi

if [ -z "$(which nix)" ]; then
	echo "Nix is not installed.. installing"
	curl https://nixos.org/nix/install | sh
	source $HOME/.nix-profile/etc/profile.d/nix.sh
fi

nix-env -i python hcloud

BUNDLE=$(nix-build --no-out-link -j4 release.nix -A kexec_bundle)
MYIP=$(ip addr show scope global | grep -Po 'inet \K[\d.]+' | head -1)


# Serve up the kexec_bundle on http://$MYIP:8000/kexec_bundle
ln -sf $BUNDLE kexec_bundle
NAME="nixos-$(date --rfc-3339=seconds | tr ' :+' '---')"

echo "Creating server $NAME"

cat >user-data.yaml <<EOF
#!/bin/bash

echo "$(cat $HOME/.ssh/authorized_keys)" > /ssh_pubkey

curl -o kexec_bundle http://$MYIP:8000/kexec_bundle && chmod 755 ./kexec_bundle
curl http://$MYIP:8000/nothing

./kexec_bundle
EOF

hcloud server create --image ubuntu-16.04 \
	             --name "$NAME" \
		     --type cx11 \
		     --user-data-from-file user-data.yaml

echo "Waiting for cloud-init to download file"
python -m SimpleHTTPServer 8000
