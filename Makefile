build-image:
	docker build -t demo:latest ./app

run-local:
	python ./app/main.py

test:
	pytest -q ./app/tests
