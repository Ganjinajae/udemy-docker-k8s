### 선언적 접근방식

`kubectl apply -f=deployment.yaml` 연결된 클러스터에 구성파일을 적용한다.
`kubectl apply -f service.yaml` 

`docker run`과 `docker-compose` 관계와 마찬가지로
쿠버네티스 구성하는 것도 config file을 만들어서 구성하는
선언적 접근방식이 더 선호된다.

명령을 어떻게 실행해야 되는지 물어보지 않아도 되고 (공유)
매번 명령어를 칠 필요도 없다.
수정이 생기면 config 파일만 수정해서 똑같이 apply 명령어만 수행하면 된다.
파일 수정이기 때문에 git에 히스토리로도 남길 수 있다.

### 삭제
구성파일을 삭제하는 것이 아닌 구성파일로 설정된 것들을 삭제한다.
`kubectl delete deployment ...`
==
`kubectl delete -f=deployment.yaml,service.yaml`
or
`kubectl delete -f=deployment.yaml -f=service.yaml`