# platform-gitops

GitOps-репозиторий платформы: единственный источник правды о том, что запущено в кластере.

- `charts/service/` — общий Helm-чарт сервиса (values проверяются `values.schema.json`).
- `argocd/` — `AppProject` и `ApplicationSet`: для каждого каталога `apps/<имя>` Argo CD создаёт приложение.
- `apps/<имя>/values.yaml` — значения конкретного сервиса. Создаётся действием `platform:gitops:register`
  (`replicaCount: 0`), затем CI сервиса через `scripts/bump-image.sh` записывает `image.tag` и `replicaCount: 1`.
- `scripts/bump-image.sh` — обновление образа в `apps/<имя>/values.yaml` (нужен `yq` v4).

`apps/hello-demo` — фикстура: каталог в GitOps есть, репозитория сервиса нет.

Репозиторий публикуется из монорепо автора скриптом `tools/publish-platform-repos.sh`; каталог `apps/` скрипт
не перезаписывает (им управляют платформа и CI сервисов).
