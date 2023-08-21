

# FOR LINUX
```
cat <<\EOF >> ~/.bashrc

alias devops='docker run --rm -it -v ~/.bash_history:/home/devops/.bash_history -v ~/.azure:/home/devops/.azure -v ~/.kube:/home/devops/.kube -v ~/.ansible/vault:/home/devops/.ansible/vault -v $(pwd):/DEVOPS -v $(readlink -f $SSH_AUTH_SOCK):/run/host-services/ssh-auth.sock -e SSH_AUTH_SOCK=/run/host-services/ssh-auth.sock --network host -e DEVOPS_UID=$(id -u) -e DEVOPS_GID=$(id -g) kukam/devops:main "$@"'
EOF
```

# MACOS (Docker Desktop)
```
cat <<\EOF >> ~/.zprofile

alias devops='d() { docker run --rm -it -v ~/.zsh_history:/home/devops/.zsh_history -v ~/.azure:/home/devops/.azure -v ~/.kube:/home/devops/.kube -v ~/.ansible/vault:/home/devops/.ansible/vault -v $(pwd):/DEVOPS -v /run/host-services/ssh-auth.sock:/run/host-services/ssh-auth.sock -e SSH_AUTH_SOCK=/run/host-services/ssh-auth.sock -e DEVOPS_UID=$(id -u) -e DEVOPS_GID=$(id -g) --network host kukam/devops:main "$@" };d'
EOF
```

# WINDOWS (Docker Desktop)
```
cat <<\EOF >> ~/.bashrc

alias devops='docker run --rm -it -v ~/.bash_history:/home/devops/.bash_history -v ~/.azure:/home/devops/.azure -v ~/.kube:/home/devops/.kube -v ~/.ansible/vault:/home/devops/.ansible/vault -v $(pwd):/DEVOPS -v ${SSH_AUTH_SOCK}:/run/host-services/ssh-auth.sock -e SSH_AUTH_SOCK=/run/host-services/ssh-auth.sock -e DEVOPS_UID=$(id -u) -e DEVOPS_GID=$(id -g) --network host kukam/devops:main "$@"'
EOF
```

# BUILD AND PUSH IMAGE
```
# docker run --rm multiarch/qemu-user-static --reset -p yes
docker buildx create --use
docker buildx build --push \
  -t "kukam/devops:$(git branch --show-current)" \
  -t "kukam/devops:latest" \
  --cache-from "kukam/devops:$(git branch --show-current)" \
  --build-arg BUILDKIT_INLINE_CACHE=1 \
  --platform "linux/amd64,linux/arm64/v8" \
  --no-cache .
```

# BUILD LOCAL
```
docker buildx build --load \
  -t "devops:$(git branch --show-current)" \
  --build-arg BUILDKIT_INLINE_CACHE=1 \
  --no-cache .
```
