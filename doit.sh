#!/bin/sh

# Run this from any OS
if [[ -z $HETZNER_API_TOKEN ]]; then
	echo "Meh.. no token no server"
	echo "Please set HETZNER_API_TOKEN env var"
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
MYIP=$(ip addr show scope global | grep -Po 'inet \K[\d.]+')


# Serve up the kexec_bundle on http://$MYIP:8000/kexec_bundle
ln -s $BUNDLE kexec_bundle
python -m SimpleHTTPServer 8000

cat >user-data.yaml <<EOF
rundme:
   - curl http://$MYIP:8000/kexec_bundle && chmod 755 ./kexec_bundle && ./kexec_bundle"
write_files:
   - path: /ssh_pubkey
   - content: |
$(sed -e 's/^/        /' $HOME/.ssh/authorized_keys)
EOF

exit 0

hcloud server create --image ubuntu-16.04 \
	             --name nixos-$RANDOM \
		     --type cx11 \
		     --user-data-from-file user-data.yaml
