FROM ubuntu:focal-20210119

RUN apt-get update && apt-get install -y build-essential python3.9-dev python3.9-venv python3-venv etcd
COPY requirements-pypa.txt .
COPY requirements-pifpaf311.txt .
COPY requirements-pifpaf314.txt .
COPY requirements-pifpaf-fix.txt .
RUN python3.9 -m venv ~/.virtualenvs/pifpaf311 \
 && ~/.virtualenvs/pifpaf311/bin/python -m pip install --no-deps --require-hashes -r requirements-pypa.txt \
 && ~/.virtualenvs/pifpaf311/bin/python -m pip install --no-deps --require-hashes -r requirements-pifpaf311.txt \
 && rm requirements-pifpaf311.txt \
 && python3.9 -m venv ~/.virtualenvs/pifpaf314 \
 && ~/.virtualenvs/pifpaf314/bin/python -m pip install --no-deps --require-hashes -r requirements-pypa.txt \
 && ~/.virtualenvs/pifpaf314/bin/python -m pip install --no-deps --require-hashes -r requirements-pifpaf314.txt \
 && rm requirements-pifpaf314.txt \
 && python3.9 -m venv ~/.virtualenvs/pifpaf-fix \
 && ~/.virtualenvs/pifpaf-fix/bin/python -m pip install --no-deps --require-hashes -r requirements-pypa.txt \
 && ~/.virtualenvs/pifpaf-fix/bin/python -m pip install --no-deps --require-hashes -r requirements-pifpaf-fix.txt \
 && rm requirements-pifpaf-fix.txt \
 && rm requirements-pypa.txt
COPY demo.py .
RUN ~/.virtualenvs/pifpaf311/bin/python -m demo
RUN ~/.virtualenvs/pifpaf-fix/bin/python -m demo
RUN ~/.virtualenvs/pifpaf314/bin/python -m demo
