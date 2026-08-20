import os
import sys

# Dapatkan path dari direktori saat ini
sys.path.insert(0, os.path.dirname(__file__))

# Atur environment variable untuk Django settings
os.environ['DJANGO_SETTINGS_MODULE'] = 'sipas_project.settings'

# Import application dari Django wsgi
from sipas_project.wsgi import application
