# Docker Run Config Override

Add the following to the Docker Run Config Override section of your Workspace Entry:

```json
{
  "security_opt": [
    "seccomp=unconfined"
  ]
}
```