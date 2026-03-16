# DR-plan (Lab 1)

## Mål

Denna DR-plan beskriver hur VM-tjänsten kan återställas vid incident i GCP för `lab1-terraform`.

## RPO och RTO

- **RPO (Recovery Point Objective): 24 timmar**
  - Motivering: snapshot-policy tar daglig backup (`03:00`) med 7 dagars retention.
- **RTO (Recovery Time Objective): 30-60 minuter**
  - Motivering: återställning sker genom Terraform + snapshot i samma region.

## Backup-strategi

- Daglig snapshot policy via `google_compute_resource_policy.daily_backup`
- Attachment till VM-disk via `google_compute_disk_resource_policy_attachment.backup_attachment`
- Retention: 7 dagar

## Återställningsflöde (runbook)

1. Identifiera senaste fungerande snapshot i `europe-north1`.
2. Skapa ny disk från snapshot (samma zon som VM).
3. Skapa ny VM eller attacha disk till ersättnings-VM.
4. Verifiera SSH-access och grundfunktion.
5. Kör `terraform plan` och `terraform apply` för att återgå till deklarerat läge.
6. Dokumentera incident och validera att snapshot-policy fortsatt är aktiv.

## Roller och ansvar

- **Utvecklare/student:** startar återställning enligt runbook.
- **Lärare/administratör:** stöd vid IAM/quota-problem.

## Testfrekvens

- Rekommenderat: verifiera restore-flöde minst 1 gång per labb/sprint.
