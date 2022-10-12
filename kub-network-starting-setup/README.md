### IP 주소 및 환경 변수를 사용한 pod간 통신

pod내 통신할 때 ip 주소가 고정적으로 필요한데 이는 service 객체를 통해서 만들 수 있다.
service 객체가 없으면 pod가 삭제, 생성 시에 ip가 변경 됨.
service 객체가 생성되고 고정된 IP로 pod간 통신을 할 수도 있지만 (`kubectl get services` 조회했을 때 나오는 IP)
k8s에서 자동으로 service name을 가지고 환경 변수를 만들어준다.
여기서는 `AUTH_SERVICE_SERVICE_HOST`와 같은 환경 변수가 만들어졌다.
service name은 `auth-service`

docker-compose에서 그대로 사용 시에는 환경 변수 작업 추가가 필요하다.