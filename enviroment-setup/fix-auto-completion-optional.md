---
icon: screwdriver-wrench
---

# Fix Auto Completion (optional)

If autocompletion for `kubectl` or the `k` alias doesn’t work, or if you’ve opened a new terminal or restarted the terminal, run this command to fix the issue:

```bash
source <(kubectl completion bash)
alias k=kubectl
complete -o default -F __start_kubectl k
source ~/.bashrc
```



Now test the `k` alias with autocompletion:

```bash
k get <PRESS-TAB>
```

You should be able to use tab completion for kubectl commands through the `k` alias.

