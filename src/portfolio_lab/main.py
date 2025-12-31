import argparse


def hello(name: str = "world") -> str:
    return f"Hello, {name}!"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(prog="portfolio-lab")
    parser.add_argument("--name", default="world", help="Name to greet")
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    print(hello(args.name))


if __name__ == "__main__":
    main()
