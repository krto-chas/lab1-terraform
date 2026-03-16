# lab1-terraform

DevSecOps Lab 1 med Terraform och Google Cloud Platform (GCP).

## Syfte

Målet med labben är att provisionera en säker grund-VM i GCP med Terraform samt lägga till automatisk backup av boot-disken.

## Filer som skapats/använts

- `main.tf` – provider, VM-resurs, backup policy och policy-attachment till disk.
- `variables.tf` – in-variabler för projekt, region och student-id.
- `terraform.tfvars` – värden för variabler (projekt/region/student).
- `startup.sh` – härdning vid uppstart (UFW, fail2ban, unattended-upgrades).
- `outputs.tf` – outputs för VM-namn, extern IP och zon.
- `.gitignore` – ignorerar state-filer, `.terraform/` och tfvars-filer.
- `.terraform.lock.hcl` – provider-låsfil skapad av `terraform init`.

## Det som är implementerat

1. Konfigurerat Google-provider (`hashicorp/google`, `~> 5.0`).
2. Skapat VM (`e2-micro`) i `europe-north1-a` med Ubuntu 22.04 LTS.
3. Lagt till startup-script för grundläggande serverhårdning.
4. Märkt resurser med labels/tags för kurs, labb och student.
5. Skapat daglig snapshot-policy (`03:00`) med 7 dagars retention.
6. Kopplat backup-policy till VM:ens disk.

## Testat/verifierat

- `terraform init` körd framgångsrikt.
- `terraform validate` körd med resultat: konfigurationen är giltig.
- `terraform plan` körd med resultat: 3 resurser planeras att skapas.

## Planerade resurser (enligt senaste plan)

- `google_compute_instance.vm`
- `google_compute_resource_policy.daily_backup`
- `google_compute_disk_resource_policy_attachment.backup_attachment`

## Körning

```bash
terraform init
terraform plan
terraform apply
```

## Notering

`.terraform.lock.hcl` ska normalt checkas in i Git för reproducerbara provider-versioner.
