### IP 주소 및 환경 변수를 사용한 pod간 통신

pod내 통신할 때 ip 주소가 고정적으로 필요한데 이는 service 객체를 통해서 만들 수 있다.
service 객체가 없으면 pod가 삭제, 생성 시에 ip가 변경 됨.
service 객체가 생성되고 고정된 IP로 pod간 통신을 할 수도 있지만 (`kubectl get services` 조회했을 때 나오는 IP)
k8s에서 자동으로 service name을 가지고 환경 변수를 만들어준다.
여기서는 `AUTH_SERVICE_SERVICE_HOST`와 같은 환경 변수가 만들어졌다. (node.js 뿐만 아니라 모든 프로그래밍 언어에서 이러한 환경 변수 제공)
service name은 `auth-service`

docker-compose에서 그대로 사용 시에는 환경 변수 작업 추가가 필요하다.

### pod간 통신에 DNS 사용하기

최신 쿠버네티스는 `CoreDNS`라는 기본 내재된 서비스와 함께 제공한다.
말 그대로 도메인 이름을 만드는데 도움이 되는 도메인 네임 서비스이다.
당연히 글로벌 도메인 네임 서비스에 등록되지 않아서 브라우저로 접근은 안 되고
클러스터 내부에 알려진 도메인 네임이다.

`서비스 이름 + "." + 네임스페이스`가 자동으로 생성되는 도메인 네임이 된다.
다른 네임스페이스에 할당하지 않으면 `default`가 네임스페이가 된다.

`kubectl get namespaces`: namespace를 조회한다.
