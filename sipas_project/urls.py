from django.contrib import admin
from django.urls import path
from diagnosa import views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', views.home, name='home'),
    path('diagnosa/', views.form_diagnosa, name='form_diagnosa'),
    path('hasil', views.hasil_diagnosa, name='hasil_diagnosa'),
]
