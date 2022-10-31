### Settings

* mongodb 가입하고 db 만들고 url 설정
* api image build 후 푸시
  * api 설정 값 자기 것으로 바꾸기
* AWS EKS 클러스터 생성
  * EKS는 `EC2` 배경에서 돌아가는 상품
  * `EC2`가 직접 관리를 하는 반면 EKS는 관리를 쉽게 해준다.
  * EKS가 대신하여 리소스를 생성하도록 허용하려면 권한을 등록해줘야 한다.(Cluster Service Role)
  * 이렇게 권한을 관리할 수 있는 AWS의 서비스가 있다. -> `IAM(Identity and Access Management)`
  * `IAM` 서비스로 들어가서 역할을 생성한다.
    * AWS 엔티티 유형 선택
    * `EKS Cluster` 사용 사례 선택
    -> 이렇게 하면 EKS에 필요한 모든 권한을 EKS에 부여하도록 사전 정의된 역할 제공
    다른 값은 기본 값으로 설정
  * `VPC` 생성
    * `CloudFormation`(템플릿으로 다른 서비스와 사물을 쉽게 생성할 수 있는 서비스) 서비스 생성 (스택 생성)
      * 다른 값은 기본 값으로 설정
      * 특정 url을 붙여야 함
        * https://docs.aws.amazon.com/eks/latest/userguide/creating-a-vpc.html#create-vpc 을 참고하여 IPv4 s3 url을 붙인다.
        * 여기에 생성하려는 네트워크에 대한 템플릿이 포함되어 있다.
    * 생성한 VPC 네트워크를 지정한다.
    * 다른 설정은 기본 값 사용
    * 클러스터 엔드포인트 액세스를 퍼블릭 및 프라이빗 사용 -> 외부에서 들어오는 요청을 처리할 수 있을 뿐 아니라 클러스터 내부의 트래픽을 보호할 수 있는 클러스터를 만들 수 있다.
      * 즉, 노드 간 또는 Pod간 트래픽은 클러스터 내부에 있어야 하며 그와 동시에 외부에서 접근할 수 있는 엔드포인트를 갖게 한다.
  * EKS 생성 -> EKS 도움으로 쿠버네티스 클러스터 생성
* 쿠버네티스 소프트웨어가 설치된 리모트 머신 추가

* `kubectl apply` minikube 클러스터로 명령어가 갔는데 이제는 AWS EKS로 명령어를 보내야한다.
Windows, Mac 두 운영체제의 사용자 폴더에서 `.kube`폴더를 찾을 수 있다.(숨긴파일 보기 해야함)
  * 이 파일은 `kubectl` 명령에 의해 사용될 구성 파일이다. 
  * 이를 재정의하기 가장 쉬운 방법은 `AWS Command Line Interface`를 사용하는 것이다.
  * AWS 계정에 대한 로컬 머신의 명령줄 내부에서 명령을 실행할 수 있게 하는 도구
  * pip를 이용해서 `aws cli` 다운받기
    https://docs.aws.amazon.com/ko_kr/cli/latest/userguide/getting-started-install.html
  * `aws cli`를 사용하는 경우 IAM에서 `Access key`를 추가한다. -> 명령을 실행하기 위해 필요하다. 
  * `aws configure` command 창에 입력
    * access key, secret key 입력
    * region 입력 (클러스터 설정 시 오른쪽 상단에 보면 확인할 수 있음)
  * `aws eks --region us-east-1 update-kubeconfig --name kub-demo` -> 이것은 kubectl이 minikube 대신 aws 클러스터와 통신할 수 있도록 kube config file을 업데이트한다.
    * `NoneType' object is not iterable` 에러가 난다면
    https://stackoverflow.com/questions/72176710/eks-update-config-with-awscli-command-aws-eks-update-kubeconfig-fails-with-err
    이를 참고하고 내용은 `/.kube/config` 파일을 지우라는 것이다. 이미 사용중인 것이 있어 병합을 못 시킨다고 한다.
  * `kubectl get pods`로 접속이 되는지 확인해본다.
* 노드그룹 생성
  * 컴퓨팅 탭에서 노드그룹 생성할 수 있음
  * 노드에도 IAM 역할이 필요하다.
    * 최종 `EC2` 인스턴스에 있는 노드, 즉 워커 노드에도 특정 권한이 필요하다.
      ex) 로그 파일 작성, 특정 서비스 연결 등
      이 노드 그룹에서 구동될 리모트 머신인 EC2 인스턴스에 연결해야한다.
    * `EC2` 선택하고 role에는 `EKS Worker Node Policy`, `CNI`, `EC2 컨테이너 레지스트리 읽기 전용 정책` 추가
    * IAM 역할 생성
    * 다른 값은 기본 값으로 하여 IAM 역할 선택하고 다음
    * 다음은 어떤 종류의 EC2 인스턴스를 구동되게 하고 관리될 것인지를 제어한다.
    * 인스턴스는 `t3.micro`로 저렴한 것 선택 -> pod 스케줄링 하려면 최소 `small`이어야 하는데 `micro`로 선택하여 pending 상태가 되게 한 후 다시 변경한다.
    * 나머지는 기본 값으로 생성
    * 몇 개의 EC2 인스턴스를 가동하여, 그들을 이 클러스터에 추가한다.
      인스턴스 뿐만 아니라 EKS는 `kubelet` 및 `kube-proxy`에 필요한 모든 쿠버네티스 소프트웨어도 설치한다.
      EKS가 아니라면 다 일일히 구성해야하는 것들.
* `users.yaml`과 `auth.yaml` 적용시켜서 `deployment`, `service` 객체 생성
  결과중 하나로 `kubectl get services`로 `users-service`의 `EXTERNAL-IP`가 aws의 IP로 되어있음을 확인할 수 있다.
  AWS에 의해 자동적으로 생성된 `LoadBalancer`를 가지고 있다.
  EKS 와 같은 관리형 서비스와 함께 사용할 때의 장점이다.
  