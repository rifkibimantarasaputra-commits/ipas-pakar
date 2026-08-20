from django.db import models

class Penyakit(models.Model):
    kode = models.CharField(max_length=10, unique=True, help_text="Contoh: P01")
    nama = models.CharField(max_length=200)
    deskripsi = models.TextField(blank=True, null=True)
    solusi = models.TextField(blank=True, null=True)

    def __str__(self):
        return f"{self.kode} - {self.nama}"

class Gejala(models.Model):
    kode = models.CharField(max_length=10, unique=True, help_text="Contoh: G01")
    nama = models.CharField(max_length=255)

    def __str__(self):
        return f"{self.kode} - {self.nama}"

class Aturan(models.Model):
    penyakit = models.ForeignKey(Penyakit, on_delete=models.CASCADE, related_name='aturan')
    gejala = models.ForeignKey(Gejala, on_delete=models.CASCADE, related_name='aturan')
    mb = models.FloatField(help_text="Measure of Belief (0.0 - 1.0)", default=0.0)
    md = models.FloatField(help_text="Measure of Disbelief (0.0 - 1.0)", default=0.0)
    cf_pakar = models.FloatField(help_text="Certainty Factor Pakar (MB - MD)", editable=False)

    class Meta:
        unique_together = ('penyakit', 'gejala')

    def save(self, *args, **kwargs):
        # Otomatis menghitung CF Pakar sebelum disimpan
        self.cf_pakar = self.mb - self.md
        super().save(*args, **kwargs)

    def __str__(self):
        return f"Jika {self.gejala.nama} maka {self.penyakit.nama} (CF: {self.cf_pakar})"
