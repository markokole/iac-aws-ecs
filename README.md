# iac-aws-ecs
 AWS Ecs as service with Terraform

Pull terraform environment

```bash
docker pull markokole/terraformer
```

```bash
docker run -itd --name terraformer --env-file "aws/credentials" --volume C:\marko\GitHub\iac-aws-ecs\terraform:/local-git markokole/terraformer
```

```bash
docker exec -it terraformer /bin/sh
```

## In docker

cd /local-git/provision-ecs

```bash
terraform init
```

```bash
terraform plan
```

```bash
terraform apply -auto-approve
```

Destroy provisioned infrastructure

```bash
terraform destroy -auto-approve
```

```bash

```

```bash

```
