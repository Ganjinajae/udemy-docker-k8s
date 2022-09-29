### kubernetes로 데이터 & 볼륨 관리하기

`State` is data created by your application which must not be lost
docker container가 volume을 가지도록 kubernetes 설정을 해야함
따로 docker run -v나 docker-compose를 이용한 작업을 하지는 않음

### volue type

`emptyDir`: pod가 시작될 때마다 비어 있는 새 디렉토리 생성. pod가 살아있는 한 이 디렉토리를 활성 상태로 유지하고 데이터를 채운다.
문제점으로 replicas 2 일 때(실행하려는 pod의 2개의 인스턴스를 가질 때) /error 요청을 한다면 하나의 pods는 죽고 다시 시작할 것이고 나머지 하나의 pod가 트래픽을 이어받는다.
하지만 해당 pod에는 volume에 저장되어 있는 데이터가 없기 때문에 app.js에서 지정한 에러가 난다.

`hostPath`: 여러 pod가 호스트 머신에서 하나의 동일한 경로를 공유
단점으로
hostPath는 노드에 특정적. 여러 pod, 다른 노드에서 실행되는 여러 복제복은 동일한 데이터에 액세스할 수 없다. 동일 node의 pod만 액세스 가능

`CSI(Container Storage Interface)`: 전 세계 모든 스토리지 솔루션 연결 가능Cloud Provider(Amazone EFS 등.쿠버네티스 볼륨의 스토리지 솔루션으로 추가하는 것이 쉽다.
로컬 개발에서 필요하진 않음

### 영구 볼륨(Persistent Volume, PV)

pod와 노드에 떨어져 독립적으로 존재
한 번만 정의해놓으면 다른 pod에서 사용할 수 있음

`PV Claim(Persistent Volume Claim)`: PV에 액세스를 요청할 수 있음. 서로 다른 노드에서 서로 다른 PV에 접근 가능.
