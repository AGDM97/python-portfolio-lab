from portfolio_lab.main import hello


def test_hello_default() -> None:
    assert hello() == "Hello, world!"
