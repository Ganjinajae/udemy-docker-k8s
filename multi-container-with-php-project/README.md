### php 프로젝트 with 멀티 컨테이너


`docker-compose run --rm composer create-project laravel/laravel .`
composer로 laravel 프로젝트 생성
프로젝트가 생성될 폴더로 .을 쓰는데 dockerfile에서 이미 설정해둔 경로가 있기 떄문에 .으로 한다.(실제로는 /var/www/html 경로)

`docker-compose up -d --build server`
Dockerfile이 변경되거나 Dockerfile을 통해 복사된 일부 파일이 변경된다면 이미지 리빌드가 필요하다.
docker-compose의 디폴트 명령으로는 적용되지 않는다.
--build를 추가하여 변경 사항이 있는 경우 이미지를 다시 생성하도록 강제한다.
이미지의 레이어 개념으로 인해 레이어가 캐시되기 때문에 변경 사항이 없는 경우는 리빌드 되지 않는다.

`docker-compose run --rm artisan migrate`
유틸리티 컨테이너 테스트 명령

Dockerfile 대신 docker-compose.yaml에서 대신할 수 있는 명령들이 있다.
entrypoint, working_dir 가 그 예
COPY나 CMD는 불가하여 Dockerfile을 쓰는 것이 권장된다.