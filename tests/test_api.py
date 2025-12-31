from fastapi.testclient import TestClient

from portfolio_api.app import app

client = TestClient(app)


def test_health() -> None:
    resp = client.get("/health")
    assert resp.status_code == 200
    assert resp.json() == {"status": "ok"}


def test_greet() -> None:
    resp = client.post("/greet", json={"name": "Angelo"})
    assert resp.status_code == 200
    assert resp.json() == {"message": "Hello, Angelo!"}
