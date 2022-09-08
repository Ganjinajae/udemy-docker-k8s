### 멀티 컨테이너

컨테이너끼리 network를 생성하여 호출할 수 있다.
network를 형성하지 않으면 IP주소를 입력해서 해야하는데 이렇게 개발하기는 쉽지 않음.
network를 형성했을 때 container name만으로 호출할 수 있다.(docker가 내부적으로 IP주소로 변환)
여기서는 backend와 db가 서로 container로 호출함
frontend는 http request만 하므로 network를 형성할 필요가 없다.

docker create network multi-setup

여기서는 개발용으로 사용할 때 유용한 정도의 flow를 가지고 있다.
프로덕션용은 따로 다룰 예정
매번 긴 명령어를 치면서 build와 run을 반복하면 사용자의 실수로 명령어가 빠질 수도 있고 수고스럽다.
docker compose를 사용!

### volume

volume을 사용함으로써 container의 삭제에도 상관없이 data를 영속화할 수 있다.
또한, 라이브로 소스 코드를 업데이트 할 수 있다.

- 익명 볼륨
- 명명 볼륨
- 바인드 마운트

### db sh

docker pull mongo
docker run 으로 해도 로컬에 이미지 없으면 알아서 받아서 진행
docker run --name mongodb -d --rm --network multi-setup mongo

### backend sh

docker build -t backend .
docker run --name backend-app -d --rm --network multi-setup -p 80:80 -v logs:/app/logs -v [real_full_path]:/app -v /app/node_modules -e MONGO_INITDB_ROOT_USERNAME=mongoadmin \backend

바인드 마운트로 로컬과 컨테이너 연결 후 javascript 수정을 바로 적용하고 싶으면 node를 재시작해야하는데 
nodemon dependency를 이용하여 해결할 수 있음

Dockerfile에서 ENV로 js에서도 이용할 수 있고
도커 실행 시 command에 -e [key=value] 형태로도 이용할 수 있다.
command에 명시하지 않으면 default로 Dockerfile에 명시한 값

### frontend sh

docker build -t frontend .
docker run --name frontend-app -d --rm -p 3000:3000 [real_full_path]:/app/src -it frontend

### 그 외

docker [명령어] --help

docker logs [container name]
docker inspenct [container name]
docker rm [cotainer name | container id]
docker rmi [image name | image id]

.dockerignore의 사용으로 소스가 컨테이너로 카피될 때 필요하지 않은 것들을 제외시킬 수 있다.
ex) node_modules, Dockerfile, .git


