from django.shortcuts import render
from .models import Gejala, Penyakit, Aturan

def home(request):
    return render(request, 'diagnosa/home.html')

def form_diagnosa(request):
    gejala_list = Gejala.objects.all().order_by('kode')
    
    # CF User options
    cf_user_options = [
        (1.0, 'Sangat Yakin'),
        (0.8, 'Yakin'),
        (0.6, 'Cukup Yakin'),
        (0.4, 'Kurang Yakin'),
        (0.2, 'Tidak Tahu'),
        (0.0, 'Tidak')
    ]
    
    context = {
        'gejala_list': gejala_list,
        'cf_user_options': cf_user_options
    }
    return render(request, 'diagnosa/form_diagnosa.html', context)

def hasil_diagnosa(request):
    if request.method == 'POST':
        # Menampung input gejala dari user (gejala_id -> cf_user)
        gejala_input = {}
        for key, value in request.POST.items():
            if key.startswith('gejala_') and float(value) > 0:
                gejala_id = int(key.split('_')[1])
                gejala_input[gejala_id] = float(value)
        
        if not gejala_input:
            return render(request, 'diagnosa/error.html', {'message': 'Harap pilih minimal satu gejala.'})
        
        # Proses Perhitungan Certainty Factor
        hasil_penyakit = {}
        
        # Ambil semua penyakit
        penyakit_list = Penyakit.objects.all()
        
        for penyakit in penyakit_list:
            cf_kombinasi = 0
            is_first = True
            
            # Ambil aturan untuk penyakit ini
            aturan_penyakit = Aturan.objects.filter(penyakit=penyakit)
            
            for aturan in aturan_penyakit:
                # Jika gejala ada di input user
                if aturan.gejala.id in gejala_input:
                    cf_user = gejala_input[aturan.gejala.id]
                    cf_pakar = aturan.cf_pakar
                    
                    # Hitung CF(H, E) = CF Pakar * CF User
                    cf_he = cf_pakar * cf_user
                    
                    # Kombinasi CF
                    if is_first:
                        cf_kombinasi = cf_he
                        is_first = False
                    else:
                        cf_kombinasi = cf_kombinasi + cf_he * (1 - cf_kombinasi)
            
            if cf_kombinasi > 0:
                hasil_penyakit[penyakit] = cf_kombinasi
        
        # Urutkan berdasarkan nilai CF tertinggi
        hasil_urut = sorted(hasil_penyakit.items(), key=lambda x: x[1], reverse=True)
        
        if hasil_urut:
            penyakit_tertinggi = hasil_urut[0][0]
            nilai_cf_tertinggi = hasil_urut[0][1]
            persentase = round(nilai_cf_tertinggi * 100, 2)
            
            context = {
                'penyakit_utama': penyakit_tertinggi,
                'persentase': persentase,
                'hasil_lengkap': hasil_urut,
                'gejala_dipilih': Gejala.objects.filter(id__in=gejala_input.keys())
            }
            return render(request, 'diagnosa/hasil.html', context)
        else:
            return render(request, 'diagnosa/error.html', {'message': 'Tidak ada penyakit yang teridentifikasi dari gejala tersebut.'})
            
    return render(request, 'diagnosa/error.html', {'message': 'Metode tidak valid.'})
