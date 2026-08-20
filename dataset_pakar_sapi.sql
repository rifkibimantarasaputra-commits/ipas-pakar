-- 0. BUAT TABEL (SCHEMA) UNTUK MYSQL/MARIADB
-- Karena Anda melakukan import langsung di phpMyAdmin sebelum migrasi Django

CREATE TABLE IF NOT EXISTS `diagnosa_penyakit` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `kode` varchar(10) NOT NULL,
  `nama` varchar(200) NOT NULL,
  `deskripsi` longtext DEFAULT NULL,
  `solusi` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `kode` (`kode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `diagnosa_gejala` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `kode` varchar(10) NOT NULL,
  `nama` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `kode` (`kode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `diagnosa_aturan` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `mb` double NOT NULL,
  `md` double NOT NULL,
  `cf_pakar` double NOT NULL,
  `gejala_id` bigint(20) NOT NULL,
  `penyakit_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `diagnosa_aturan_gejala_id_fk` (`gejala_id`),
  KEY `diagnosa_aturan_penyakit_id_fk` (`penyakit_id`),
  CONSTRAINT `diagnosa_aturan_gejala_id_fk` FOREIGN KEY (`gejala_id`) REFERENCES `diagnosa_gejala` (`id`) ON DELETE CASCADE,
  CONSTRAINT `diagnosa_aturan_penyakit_id_fk` FOREIGN KEY (`penyakit_id`) REFERENCES `diagnosa_penyakit` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 1. DATA PENYAKIT PENCERNAAN SAPI
INSERT INTO `diagnosa_penyakit` (`id`, `kode`, `nama`, `deskripsi`, `solusi`) VALUES
(1, 'P01', 'Timpani (Kembung Perut / Bloat)', 'Penumpukan gas berlebih di dalam rumen (lambung sapi) akibat fermentasi pakan yang tidak normal. Sangat mematikan jika tidak segera ditangani.', 'Berikan obat anti-kembung (Tympanol), urut perut sebelah kiri, ajak sapi berjalan, atau dalam kondisi kritis panggil dokter hewan untuk tindakan Trocar (menusuk rumen).'),
(2, 'P02', 'Asidosis Laktat (Asidosis Rumen)', 'Keracunan akibat sapi terlalu banyak makan karbohidrat yang mudah difermentasi (seperti konsentrat/biji-bijian), menyebabkan rumen menjadi sangat asam.', 'Hentikan pemberian pakan konsentrat, berikan obat antasida (Sodium Bikarbonat / Soda kue) dicampur air, berikan pakan hijauan berserat tinggi, dan injeksi vitamin B kompleks.'),
(3, 'P03', 'Helminthiasis (Cacingan Saluran Cerna)', 'Infeksi cacing parasit (seperti cacing hati atau cacing gilig) di dalam usus dan lambung sapi, menyerap nutrisi dan merusak jaringan perut.', 'Berikan obat cacing spektrum luas (Anthelmintik) seperti Albendazole atau Ivermectin. Jaga sanitasi kandang agar kotoran tidak mengkontaminasi pakan.'),
(4, 'P04', 'Bovine Viral Diarrhea (BVD)', 'Penyakit infeksi virus ganas yang menyerang saluran pencernaan dan pernapasan. Sangat menular dan menyebabkan penurunan kekebalan tubuh.', 'Karantina sapi yang sakit, berikan terapi cairan (infus elektrolit) untuk mencegah dehidrasi parah, berikan antibiotik (untuk infeksi sekunder), dan vaksinasi sapi yang sehat.');

-- 2. DATA GEJALA
INSERT INTO `diagnosa_gejala` (`id`, `kode`, `nama`) VALUES
(1, 'G01', 'Perut sebelah kiri membesar, tegang, dan jika ditepuk berbunyi seperti drum'),
(2, 'G02', 'Sapi terlihat gelisah, sering menoleh/melihat ke arah perut'),
(3, 'G03', 'Kesulitan bernapas (napas pendek dan cepat)'),
(4, 'G04', 'Sering menghentakkan kaki ke tanah atau menendang perutnya sendiri'),
(5, 'G05', 'Penurunan nafsu makan secara drastis (Anoreksia)'),
(6, 'G06', 'Diare dengan feses encer, berwarna terang, dan berbau asam menyengat'),
(7, 'G07', 'Denyut jantung meningkat tajam (Takikardia)'),
(8, 'G08', 'Kondisi tubuh lesu, lemah, mata cekung (dehidrasi)'),
(9, 'G09', 'Sapi kesulitan berdiri atau bahkan lumpuh (Ambruk)'),
(10, 'G10', 'Penurunan berat badan drastis meskipun nafsu makan normal'),
(11, 'G11', 'Bulu terlihat kusam, kasar, dan sering berdiri (tidak mengkilap)'),
(12, 'G12', 'Diare kronis atau mencret yang terjadi terus-menerus dalam waktu lama'),
(13, 'G13', 'Selaput lendir pada mata dan gusi terlihat sangat pucat (Anemia)'),
(14, 'G14', 'Diare cair parah, sering disertai lendir atau darah'),
(15, 'G15', 'Demam tinggi (Suhu tubuh lebih dari 40 derajat Celcius)'),
(16, 'G16', 'Terdapat luka lepuh / sariawan pada rongga mulut, bibir, dan moncong'),
(17, 'G17', 'Keluar leleran berlebih dari hidung dan mata (Mata berair)');

-- 3. DATA ATURAN / BASIS PENGETAHUAN (RULES)
INSERT INTO `diagnosa_aturan` (`penyakit_id`, `gejala_id`, `mb`, `md`, `cf_pakar`) VALUES
(1, 1, 0.90, 0.10, 0.80), 
(1, 2, 0.70, 0.20, 0.50), 
(1, 3, 0.80, 0.10, 0.70), 
(1, 4, 0.60, 0.20, 0.40), 

(2, 5, 0.80, 0.20, 0.60), 
(2, 6, 0.90, 0.10, 0.80), 
(2, 7, 0.70, 0.30, 0.40), 
(2, 8, 0.80, 0.20, 0.60), 
(2, 9, 0.60, 0.20, 0.40), 

(3, 10, 0.90, 0.10, 0.80), 
(3, 11, 0.80, 0.20, 0.60), 
(3, 12, 0.70, 0.20, 0.50), 
(3, 13, 0.85, 0.15, 0.70), 

(4, 14, 0.90, 0.10, 0.80), 
(4, 15, 0.80, 0.20, 0.60), 
(4, 16, 0.85, 0.05, 0.80), 
(4, 17, 0.70, 0.30, 0.40), 
(4, 5, 0.70, 0.20, 0.50);
