import os

SQLALCHEMY_DATABASE_URI = os.environ.get("SQLALCHEMY_DATABASE_URI")
SECRET_KEY = os.environ.get("SUPERSET_SECRET_KEY", "thisISaSECRET_key")  # Replace in production

FEATURE_FLAGS = {
    "ENABLE_TEMPLATE_PROCESSING": True,
}

# Optional: Disable caching to avoid needing Redis
CACHE_CONFIG = {
    "CACHE_TYPE": "null"
}
DATA_CACHE_CONFIG = CACHE_CONFIG
