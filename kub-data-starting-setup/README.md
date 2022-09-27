### kubernetes로 데이터 & 볼륨 관리하기

`State` is data created by your application which must not be lost
docker container가 volume을 가지도록 kubernetes 설정을 해야함
따로 docker run -v나 docker-compose를 이용한 작업을 하지는 않음

### volue type

`emptyDir`: Pod가 시작될 때마다 비어 있는 새 디렉토리 생성. Pod가 살아있는 한 이 디렉토리를 활성 상태로 유지하고 데이터를 채운다.