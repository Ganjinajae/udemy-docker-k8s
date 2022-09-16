## kubernetes 연결
	
- 쿠버네티스는 클러스터랑 노드를 만들지는 않는다. 다만 그런 것들을 운용하는 것. 컨테이너화된 애플리케이션에 대한 배포를 설정할 수 잇는 프레임워크, 개념, 도구
- kublets, api 서버, 스케줄러, 노드에 대한 필요한 것들
- 어떤 머신이나 가상 인스턴스를 생성하지 않음, 소프트웨어도 설치 x
- 포드와 컨테이너를 모니터링하는 관리에만 관심을 가진다.
- 애플리케이션에 필요한 리소스를 생성하려면 AWS EKS나 kubermatic 과 같은 관리형 서비스를 사용하거나 직접 만든다.
- kubectl kube control 도구 -> 새 deployment 생성, deployment 삭제, 실행중인 deployment 변경과 같은 명령을 클러스터에 보내는데 사용하는 도구 
- minikube 설치하고 자동으로 kubectl까지 설치되는 듯?
- `minikube start`로 kubernetes 클러스터 생성하고 클러스터는 마스터노드를 생성하고 마스터노드에 필요한 소프트웨어들 자동으로 설치. 워커노드 소프트웨어도 설치함. driver는 docker로 함. virtualbox같은 hypervisor이용할 수도 있음d
- kubernets 객체 중 deployment가 pod를 관리한다. 직접 수동으로 생성하지 않고 관리하지 않는다.

### deployment 객체

- `kubectl create deployment [name] --image=(image tag)`으로 deployment 객체를 생성하면 (deployment 객체를 기반으로 pod를 생성) 자동으로 쿠버네티스 클러스터에 있는 마스터 노드 즉, 컨트롤 플레인으로 전송한다.
- 마스터노드는 클러스터에 필요한 모든 것을 생성. 예를 들어, 워커노드에 pod를 배포하는 일을 담당
- 스케줄러가 현재 실행 중인 pod를 분석하여 새로 생성된 pod에 가장 적합한 Node(워커노드)를 찾는다.(예를 들어, 현재 가장 적은 양의 작업을 수행하고 있는 노드)
- 워커노드에서 kublet 서비스가 있는데 pod를 관리하고 pod에서 컨테이너를 시작하고, pod를 모니터링하며 상태를 확인
- pod 안에 있는 container는 --image로 지정한 이미지를 기반으로 컨테이너를 만든다.

### service 객체

- pod와 pod서 실행되는 컨테이너에 접근하려면 service 객체가 필요하다.
- 클러스터나 외부에 pod를 노출한다.
- pod에는 디폴트로 내부 IP 주소가 있다.
- 두 가지 문제가 있다. -> pod와 통신하는데 훌륭한 도구가 아니다.
  1. 외부에서 해당 IP 주소로 pod에 접근할 수 없다.
  2. pod가 교체될 때마다 IP 주소가 변한다.
- service는 pod를 그룹화하고 공유 주소, 공유 IP 주소를 제공한다. -> 변경 없음
- pod를 service로 옮겨서 클러스터 또는 외부에서 접근 가능하도록 한다.
- 디폴트는 내부 전용

### 필요한 것

homebrew로 설치
- minikube(참고로 1.25.2 version에서 service 관련 버그가 있다고 한다. 당시 최신 버전인 1.27.0 버전으로 진행)
- kubectl(kube control)

### 명령어

`minikube status` 작동확인
`minikube start` 클러스터 생성 및 마스터노드
`minikube dashboard` 클러스터의 웹 대시보드
`kubectl create deployment first-app --image=username/kub-first-app` deployment 객체(object)를 생성, 자동으로 쿠버네티스 클러스터로 전송 됨. --image는 deployment에서 생성된 pod의 컨테이너에 사용할 이미지를 지정할 때 사용(내부적으로 dockerhub에서 Pull을 받아서 사용)

`kubectl get deployments` 클러스터에 deployment가 얼마나 있는지 확인
`kubectl get pods` deployment에서 생성된 모든 것을 확인
`kubectl delete deployment first-app` deployment 제거

`kubectl create service ...` 이렇게 해서 service를 만들 수 있다. 자료 참고
`kubctl expose deployment first-app --type=LoadBalancer --port=8080` 미리 deployment로 pod를 생성한 경우 이 명령어를 통해서 service를 생성하고, deployment로 생성한 pod를 노출한다.
--port: 컨테이너 앱이 수신하는 port를 설정한다.
--type: 다양한 내장 유형이 있다.
  1. ClusterIP: 디폴트 유형. 클러스터 내부에서만 연결할 수 있다. 최소한 변경되지 않는 주소를 얻을 수 있다.
  2. NodePart: deployment가 실행 중인 워커 노드의 IP 주소를 통해 노출 됨을 뜻한다. 실제로 외부에서 액세스할 수 있다.
  3. LoadBalancer: 클러스터가 실행되는 인프라에 존재해야하는 LoadBalancer를 활용한다. service에 대한 고유한 주소를 생성할 뿐만 아니라 들어오는 트래픽을 이 service의 일부인 모든 pod에 고르게 분산한다.
  클러스터와 클러스터가 실행되는 인프라가 지원하는 경우에만 사용할 수 있다. AWS, minikube 수행 가능
  해당 명령어로 클라우드 프로바이더에 배포되면 실제 외부 IP를 볼 수 있으나 minikube에서는 항상 보류(pending) 상태로 유지된다.(로컬 가상 머신이기 때문에)
  하지만, minikube에는 service에 액세스할 수 있게 하는 명령을 가지고 있다.(로컬 머신에서 실행 중인 가상 머신을 식별함으로써)
  `minikube service first-app` 실제 클라우드 프로바이더에서는 이 명령을 쓸 일이 없다. 외부 IP가 노출되기 때문에. minikube 전용
`kubctl get services` service 목록 확인. 디폴트로 kubernetes가 ClusterIP type으로 생성되어 있다.