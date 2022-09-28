node('master') {
    wrap([$class: 'BuildUser']) {
        user_email = env.BUILD_USER_EMAIL
    }
    stage('Prepare') {
        echo "1.Prepare Stage"
        checkout scm
        sh "git checkout ${params.Branch}"
        BRANCH_NAME = params.Branch
         if (BRANCH_NAME ==~ /origin.*/) {
             BRANCH_NAME = BRANCH_NAME.replace('origin/', '').replace('/', '-')
             SHORT_COMMIT = sh(returnStdout: true,script: 'git rev-parse --short HEAD').trim()
             APP_TAG = "${BRANCH_NAME}-${SHORT_COMMIT}"
         } else {
             APP_TAG = BRANCH_NAME
         }
         echo "APP_TAG:"+ APP_TAG

        echo "user email: ${user_email}"
        AutoDeploy=params.AutoDeploy
        Ns=params.Namespace
        MIX_ENV=params.MIX_ENV
        Cluster=params.Cluster
        NAMESPACE="platform"
        Mesh="no-mesh"
        if (Ns ==~ /.*mesh/ ){
            Mesh="mesh"
        }
        IMAGE_BASE="lilith-registry-vpc.cn-shanghai.cr.aliyuncs.com"
        CHART_BASE="acr://lilith-chart-vpc.cn-shanghai.cr.aliyuncs.com"
        APP_NAME=env.JOB_BASE_NAME
        script{
        withCredentials([string(credentialsId: 'ops-access-token', variable: 'SECRET')]) {
            HELM_VERSION=sh(returnStdout: true,script: "curl -H 'Authorization: Token ${SECRET}' http://10.137.61.140/api/fetch_chart_version/${APP_NAME}")
        }
        IMAGE_NAME="${IMAGE_BASE}/${NAMESPACE}/${APP_NAME}"
        echo "IMAGE_NAME: ${IMAGE_NAME}"
        CHART_REPO="${CHART_BASE}/${NAMESPACE}/${APP_NAME}"
        echo "CHART_REPO: ${CHART_REPO}"
        }
     }
    stage('Build') {
        echo "3.Build Docker Image Stage"
        sh "docker build -t ${IMAGE_NAME}:${APP_TAG} --build-arg MIX_ENV=${MIX_ENV} --build-arg APP_VSN=${APP_TAG} . -f Dockerfile"
    }

    stage('Push') {
        echo "4.Push Docker Image Stage"
        withCredentials([usernamePassword(credentialsId: 'dockerHub2', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
           sh "docker login ${IMAGE_BASE} -u ${dockerHubUser} -p ${dockerHubPassword}"
           sh "docker push ${IMAGE_NAME}:${APP_TAG}"
        }
    }

    stage('helm-push') {
        echo "5. Helm Push"
        withCredentials([string(credentialsId: 'ops-access-token', variable: 'SECRET')]) {
            try {
                if (params.AutoDeploy) {
                    CURL_RESULT=sh(
                        script: "curl -H 'Authorization: Token ${SECRET}' -s -w %{http_code} -F projectName=${APP_NAME} -F branchName=${APP_TAG} -F image=${IMAGE_NAME} -F tag=${APP_TAG} -F repo=${CHART_REPO} -F chartVersion=${HELM_VERSION} -F cluster=${Cluster} -F namespace=${Ns} -F email=${user_email}  -F mesh=${Mesh} http://10.137.61.140/api/build/",
                        returnStdout: true
                    )
                    sh "echo ${CURL_RESULT} |grep 201"
                } else {
                    CURL_RESULT=sh(
                        script: "curl -H 'Authorization: Token ${SECRET}' -s -w %{http_code} -F projectName=${APP_NAME} -F branchName=${APP_TAG} -F image=${IMAGE_NAME} -F tag=${APP_TAG} -F repo=${CHART_REPO} -F chartVersion=${HELM_VERSION} -F email=${user_email} -F mesh=${Mesh} http://10.137.61.140/api/build/",
                        returnStdout: true
                        )
                    sh "echo ${CURL_RESULT} |grep 201"
                }
            } catch (exc) {
                echo "build_aborted"
                    sh(
                    script: "curl -H 'Authorization: Token ${SECRET}' -s -w %{http_code} -F projectName=${APP_NAME} -F chartVersion=${HELM_VERSION} -F cluster=${Cluster} -F namespace=${Ns} -F email=${user_email}  http://10.137.61.140/api/build_aborted/",
                    returnStdout: true
                    )
                sh "exit 1"
            }
        }
    }
}
