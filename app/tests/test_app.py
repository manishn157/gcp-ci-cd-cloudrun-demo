import pytest
from main import app

@pytest.fixture
def client():
    app.testing = True
    return app.test_client()

def test_health(client):
    r = client.get('/health')
    assert r.status_code == 200
    assert r.get_json() == {'status': 'ok'}

