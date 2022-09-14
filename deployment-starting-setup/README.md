### aws ec2에 배포

aws에서 ec2 인스턴스 생성
private key 생성하여 다운로드
key 파일 `chmod 400` 으로 권한 조절 (조절 안 하면 bad permission:ignore key 에러 발생)
ssh 접속
`ex) ssh -i "example.pem" 접속정보`

접속 후 `sudo yum update -y`
도커 설치 `sudo amazon-linux-extras install docker`


### Deploy Source Code vs Image

* Deploy Source: 소스코드를 배포해서 거기서 build and run -> 이점이 없다.

* Deploy Built Image: 로컬 머신에서 이미지를 만든 후 이미지를 배포

### Docker hub

docker hub에 이미지 push하고 리모트 머신에서 pull받아서 사용하는 방식으로 사용
기존의 node-dep-example 이미지를 public repository의 tag name(여기서는 username/example)으로 새로 생성
 `docker tag node-dep-example username/example`
dockerhub에 push
`docker push username/example`

### 인스턴스에서 docker 실행

`sudo docker run -d --rm -p 80:80 username/example`

### ec2 보안그룹

http로 접근하는 보안그룹 inbound 규칙을 설정해줘야 public ip로 접근이 가능하다.
기존에는 ssh로만 설정이 되어있다.

### 소스코드 최신 반영

로컬 머신에서 소스코드 변경이 일어났을 때
이미지를 rebuild하고
dockerhub에 push하고
리모트 서버에서 실행중인 container 종료하고
`docker pull imagename`하고
최신 이미지로 다시 띄운다.

### AWS EC2 단점

자신만의 리모트 머신을 가지고 작업을 한다는 것은 좋으나
관리를 지속적으로 해줘야한다.
예를 들어, 인스턴스를 만들고 최신 상태로 유지하기 위해 업데이트하고 모니터링하고 때로는 트래픽에 따라 확장해야할 수 있다.
보안과 관련된 문제가 있을 때도 그렇고 지속적인 관리가 필요하다.
그에 대한 지식이 있고 경험이 풍부한 관리자면 괜찮으나 그 수준에 있지 않은 이상 쉽지 않다.
-> `AWS ECS`를 고려해보자.
전체 생성고나리, 업데이트, 모니터링, 스케일링이 단순화된다.
단순히 애플리케이션이나, 컨테이너를 배포하는 경우라면 이러한 관리형 서비스를 사용하는 것이 좋다. 세부 설정 작업데 해새 걱정할 필요가 없기 떄문에
대신 자유도는 작아지고 ECS에서 해야하는 데로 사용해야된다는 단점이 있다. (paas 개념으로 파악된다.)

---
inbound, outbound 개념 정리 - https://m.blog.naver.com/PostView.naver?isHttpsRedirect=true&blogId=thislover&logNo=220909157076