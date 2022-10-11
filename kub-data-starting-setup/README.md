### kubernetes로 데이터 & 볼륨 관리하기

`State` is data created by your application which must not be lost
docker container가 volume을 가지도록 kubernetes 설정을 해야함
따로 docker run -v나 docker-compose를 이용한 작업을 하지는 않음
- 사용자 생성 데이터, 사용자 계정, 상점의 제품들 등과 같은 데이터
- 중간 결과와 임시 데이터
두 경우 모두 볼륨은 훌륭한 솔루션이다.
중간 임시 결과의 경우, pod 특정 볼륨으로 충분하다.
사용자 생성 데이터 등의 데이터는 PV가 매우 적합하다.
### volue type

`emptyDir`: pod가 시작될 때마다 비어 있는 새 디렉토리 생성. pod가 살아있는 한 이 디렉토리를 활성 상태로 유지하고 데이터를 채운다.
문제점으로 replicas 2 일 때(실행하려는 pod의 2개의 인스턴스를 가질 때) /error 요청을 한다면 하나의 pods는 죽고 다시 시작할 것이고 나머지 하나의 pod가 트래픽을 이어받는다.
하지만 해당 pod에는 volume에 저장되어 있는 데이터가 없기 때문에 app.js에서 지정한 에러가 난다.

`hostPath`: 여러 pod가 호스트 머신에서 하나의 동일한 경로를 공유
단점으로
hostPath는 노드에 특정적. 여러 pod, 다른 노드에서 실행되는 여러 복제복은 동일한 데이터에 액세스할 수 없다. 동일 node의 pod만 액세스 가능

`CSI(Container Storage Interface)`: 전 세계 모든 스토리지 솔루션 연결 가능. Cloud Provider(Amazone EFS 등). 쿠버네티스 볼륨의 스토리지 솔루션으로 추가하는 것이 쉽다.
로컬 개발에서 필요하진 않음

### 영구 볼륨(Persistent Volume, PV)

pod와 노드에 떨어져 독립적으로 존재
한 번만 정의해놓으면 다른 pod에서 사용할 수 있음

`PV Claim(Persistent Volume Claim)`: PV에 액세스를 요청할 수 있음. 서로 다른 노드에서 서로 다른 PV에 접근 가능.
PV를 사용하려는 pod에서 만들어야한다.
클레임을 구성하고 PV를 사용하고자 하는 모든 pod에서 사용해야한다.
`kubectl get pv`: 모든 영구 볼륨 조회
`kubectl get pvc`: 모든 클레임 조회

`Storage Class`: 쿠버네티스 관리자에게 스토리지 관리 방법과 볼륨 구성 방법을 세적으로 제어할 수 있게 해주는 개념. 보통 디폴트 스토리지 클래스를 사용하는 것 같음.
설정한. PV 구성에 중요한 정보를 제공한다.
`kubectl get sc`: 스토리지 클래스 정보 가져오기
순서: pv 구성 -> pvc 구성 -> deployment 구성

### 볼륨 vs 영구 볼륨

볼륨
- 컨테이너와는 독립적이지만, pod와 생명주기를 같이 한다. 즉, pod가 삭제되면 pod에 연결된 볼륨의 데이터도 지워질 수 있다. (emptyDir, hostPath 등)
- hostPath 같은 경우는 단일 pod만 사용한다면 괜찮지만 여러 pod를 사용했을 때 각 pod에 volume 설정을 해줘야한다.

영구 볼륨
- pod와 함께 정의되지 않는다. 
- 스탠드얼론 리소스(특정 pod에 연결되지 않는다.). 
- 구성이 하나의 파일에 있으므로 재사용하기 쉽다. 
- 템픒릿에 볼륨별 각각 구성 로직을 작성할 필요가 없다.
- 글로벌 수준에서 모든 볼륨을 관리하기 쉬워진다.