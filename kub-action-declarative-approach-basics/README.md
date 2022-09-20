### 선언적 접근방식

`kubectl apply -f=deployment.yaml` 연결된 클러스터에 구성파일을 적용한다.
`kubectl apply -f service.yaml` 

`docker run`과 `docker-compose` 관계와 마찬가지로
쿠버네티스 구성하는 것도 config file을 만들어서 구성하는
선언적 접근방식이 더 선호된다.

명령을 어떻게 실행해야 되는지 물어보지 않아도 되고
매번 명령어를 칠 필요도 없다.