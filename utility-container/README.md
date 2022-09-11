### Utility Container

**Utility Container**: 공식적인 용어는 아님. 애플리케이션을 포함하지 않고 특정 명령을 실행하는데 사용할 수 있는 환경만 존재
사용 이유: 로컬에 모든 도구를 설치하지 않고도 특정한 것을 설정할 수 있다.

node alpine - 기존 node 이미지보다 더 슬림하고 최적화된 이미지

docker build node-util .
docker run -it -v [realPath]:/app node-util npm init 
-> 뒤에 있는 명령어가 디폴트로 실행 됨. Dockerfile에 있는 지정된 명령어를 덮어씀(CMD)

ENTRYPOINT는 덮어쓰는게 아니라 append
ex) ENTRYPOINT ["npm"] 한 상태에서 docker run -it -v [realPath]:/app node-util init 으로 npm을 생략할 수 있다.

docker-compose exec 이미 실행중인 컨테이너에 명령을 실행하기 위한 명령어
docker-compose run yaml에 여러 서비스가 있는 경우에 서비스 이름으로 단일 서비스를 지정해서 명령을 실행시킬 수 있다.
ex) docker-compose run npm init

docker-compose run은 up, down 개념이 없고 명령이 끝나면 알아서 종료 됨
docker-compose run으로 시작하면 자동으로 컨테이너 삭제가 안 됨
따라서, docker-compose run --rm node init 이런식으로 해야함
