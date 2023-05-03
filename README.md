

# FOR LINUX
```
echo 'alias devops="docker run --rm -it --privileged -v ~/.bash_history:/home/devops/.bash_history -v ~/.azure:/home/devops/.azure -v ~/.kube:/home/devops/.kube -v ~/.ansible:/home/devops/.ansible -v ${PWD}:/DEVOPS -v $(readlink -f $SSH_AUTH_SOCK):/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent --network host -e DEVOPS_UID=$(id -u) -e DEVOPS_GID=$(id -g) kukam/devops:main $@"' >> ~/.bashrc
```

# MACOS (Docker Desktop)
```
echo 'alias devops="docker run --rm -it --privileged -v ~/.zcache:/home/devops/.zcache/ -v ~/.zsh_sessions:/home/devops/.zsh_sessions -v ~/.zshrc:/home/devops/.zshrc -v ~/.zsh_history:/home/devops/.zsh_history -v ~/.azure:/home/devops/.azure -v ~/.kube:/home/devops/.kube -v ~/.ansible:/home/devops/.ansible -v ${PWD}:/DEVOPS -v /run/host-services/ssh-auth.sock:/run/host-services/ssh-auth.sock -e SSH_AUTH_SOCK=/run/host-services/ssh-auth.sock -e DEVOPS_UID=$(id -u) -e DEVOPS_GID=$(id -g) --network host kukam/devops:main $@"' >> ~/.zprofile
```

# WINDOWS (Docker Desktop)
```
echo 'alias devops="docker run --rm -it --privileged -v ~/.bash_history:/home/devops/.bash_history -v ~/.azure:/home/devops/.azure -v ~/.kube:/home/devops/.kube -v ~/.ansible:/home/devops/.ansible -v ${PWD}:/DEVOPS -v "${SSH_AUTH_SOCK}":/run/host-services/ssh-auth.sock -e SSH_AUTH_SOCK=/run/host-services/ssh-auth.sock -e DEVOPS_UID=$(id -u) -e DEVOPS_GID=$(id -g) --network host kukam/devops:main $@"' >> ~/.bashrc
```

# BUILD AND PUSH IMAGE
```
# docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker buildx create --use
docker buildx build --push \
  -t "kukam/devops:$(git branch --show-current)" \
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
