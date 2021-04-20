## CICD
- 参考
    - https://www.jenkins.io/doc/pipeline/tour/post/  构建结束后操作
    - https://www.jenkins.io/zh/doc/book/pipeline/syntax/

### 流程
- 方式一
    1. 下载代码（credentialsId登入git仓库）
    2. build dockerfile
    3. aws 登入（）
    4. 推送镜像进入aws

    5. 登入k8s集群（）
    6. 更新yaml并且apply


### template
```groovy
// clone code
def git_url = 'ssh://git@IP:PORT/PROJECT.git'
def git_redentials_id = ''

// build
def agent_label = 'test'
Date now = new Date()
def cur_time = now.format("yyyyMMdd_HHmmss", TimeZone.getTimeZone('UTC'))

def docker_image_url = 'IP'
def dockerfile_path = './Dockerfile'
def docker_build_arg = '--build-arg ENV=pre'
def docker_image_tag = 'pre' // it is prefix

// k8s
def k8s_deploy_cluster = 'export KUBECONFIG=~/.kube/config'
def k8s_yaml_path = 'devops//manifests/pre/PROJECT-pre.yaml'
def k8s_controller = 'PROJECT-pre'

// permision
def super_user = ['gary']
// // 定义可选参数
// def ppl_parameters = [
//         'refspec'         :
//                 string(
//                         defaultValue: 'develop',
//                         description: 'branch like: origin/develop\n\nor commit id like: 0aa66bb99',
//                         name: 'refspec'),
//         'qa_approver'     :
//                 string(
//                         defaultValue: '',
//                         description: 'QA 负责人；多个人时使用英文输入法的半角逗号分隔；不要带空格，空格不会被忽略',
//                         name: 'qa_approver'),
//         'git_project_name'     :
//                 choice(
//                         choices: 'PROJECT',
//                         description: 'git project name',
//                         name: 'git_project_name'),
//         'jenkins_job_name':
//                 choice(
//                         choices: 'PROJECT-pre.deploy',
//                         description: 'job name for deploy',
//                         name: 'jenkins job name'),
// ]
// 保存选择的参数结果，供后面使用
def ppl_params = [:]

pipeline {
     
    options {
        timestamps()
        disableConcurrentBuilds()
        ansiColor('vga')
        buildDiscarder(logRotator(daysToKeepStr: '30', numToKeepStr: '100'))
    }
    parameters {
        string(name: 'refspec',
            defaultValue: 'develop',
            description: 'branch like: origin/develop\n\nor commit id like: 0aa66bb99'
        )
        string(name: 'qa_approver',
            defaultValue: '',
            description: 'QA 负责人；多个人时使用英文输入法的半角逗号分隔；不要带空格，空格不会被忽略'
        )
        choice(name: 'git_project_name',
            choices: 'PROJECT',
            description: 'git project name'
        )
        choice(name: 'jenkins_job_name',
            choices: 'PROJECT-pre.deploy',
            description: 'jenkins job name'
        )
    }
    stages {
        // agent any
        agent {
            label "${agent_label}"
        }
    //     stage('Init Parameters') {
    //         steps {
    //             timeout(time: 300, unit: 'SECONDS') {
    //                 script {
    //                     def ppp = []
    //                     for (element in ppl_parameters) {
    //                         ppp.add(element.value)
    //                     }
    //                     def userInput = input(id: 'userInputs', message: '请确认填写正确的构建参数！', parameters: ppp)
    //                     echo("refspec: " + userInput['refspec'])
    //                     echo("qa_approver:" + userInput['qa_approver'])

    //                     for (ele in userInput) {
    //                         ppl_params[ele.key] = ele.value
    //                     }
    //                 }

    //             }
    //         }
    //     }
        stage('Check Parameters') {
            agent {
                label "${agent_label}"
            }
            steps {
                timeout(time: 60, unit: 'SECONDS') {
                    script {
                        ppl_params['refspec'] = refspec
                        ppl_params['qa_approver'] = qa_approver
                        ppl_params['git_project_name'] = git_project_name
                        ppl_params['jenkins_job_name'] = jenkins_job_name
                        try {
                            def GET_BUILD_USER_ID
                            def GET_BUILD_USER
                            wrap([$class: 'BuildUser']) {
                                GET_BUILD_USER_ID = sh(script: 'echo "${BUILD_USER_ID}"', returnStdout: true).trim()
                                GET_BUILD_USER = sh(script: 'echo "${BUILD_USER}"', returnStdout: true).trim()
                                echo "build user: ${GET_BUILD_USER_ID}(${GET_BUILD_USER})"
                            }
                            def psize = ppl_params.size()
                            if (psize > 0) {
                                for (entry in ppl_params) {
                                    echo entry.key + "=" + entry.value
                                    if (entry.value == '') {
                                        echo entry.key + "为空"
                                        sh "exit 1"
                                        break
                                        // throw new Exception(entry.key + "为空，请补全")
                                    }
                                }
                            }
                        } catch (Exception e) {
                            echo "throw exception and exit, message: ${e.message}"
                            sh 'exit 1'
                        }
                    }
                }
            }
        }
        stage('QA') {
            agent {
                label "${agent_label}"
            }
            // when {
            //     expression {
            //         return !(ppl_params.jenkins_job_name ==~ /.*-test/)
            //     }
            // }
            steps {
                timeout(time: 30, unit: 'MINUTES') {
                    script {
                        // 通知负责人来确认，提供链接直接点进来
                        notifyQA(ppl_params)

                        def GET_BUILD_USER
                        wrap([$class: 'BuildUser']) {
                            GET_BUILD_USER = sh(script: 'echo "${BUILD_USER_ID}"', returnStdout: true).trim()
                        }

                        echo "QA 指定负责人是: " + ppl_params.qa_approver
                        def tr = input(message: "确认可以发Preview环境？", ok: "确认可以发Preview环境！", submitter: ppl_params.qa_approver + ",gary", submitterParameter: 'qa_approver_do')
                        echo "QA 负责人是: $tr"
                        if ("" == ppl_params.qa_approver) {
                            echo "QA 负责人不能为空."
                            sh "exit 1"
                        }
                        if ("$GET_BUILD_USER" == "$tr" && !super_user.contains(tr)) {
                            echo "QA 负责人不能是自己."
                            sh "exit 1"
                        }
                        if ("$tr" == ppl_params.qa_approver) {
                            echo "QA passed."
                        } else {
                            echo "QA 负责人不匹配. $tr != " + ppl_params.qa_approver
                            sh "exit 1"
                        }
                    }
                }
            }
        }
        stage('docker login') {
            agent {
                label "${agent_label}"
            }
            options {
                skipDefaultCheckout true
            }
            steps {
                script {
                    docker_login = sh(returnStdout: true, script: 'aws ecr get-login --no-include-email --region us-east-1')
                    sh "${docker_login}"
                    sh "echo \"refspec=${refspec}\";"
                }   
            }
        }
        stage('Building image') {
            agent {
                label "${agent_label}"
            }
            options {
                skipDefaultCheckout true
            }
            steps {
                script {
                    checkout([ $class: 'GitSCM',
                            branches: [[name: "$refspec"]],
                            userRemoteConfigs: [[url: "${git_url}", credentialsId: "${git_redentials_id}",]]])
                    // 免除每次都需下载依赖
                    // if (PhpInstall == "true" || !fileExists("./node_modules")) {
                    //     sh """docker run -u 0 --rm -v \$(pwd):代码根目录 --name node-build-container node:12.19.0-alpine3.10 sh -c 'cd 代码根目录;rm -rf node_modules package-lock.json;npm install'"""
                    // }
                    // sh "docker run --rm -v \$(pwd):代码根目录 --name node-build-container node:12.19.0-alpine3.10 sh -c 'cd 代码根目录;npm run build'; \
                    //     sudo chown -R ec2-user.ec2-user \$(pwd); \
                    //     git rev-parse --short HEAD > build/version; \
                    // "

                    git_ver = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    docker_image_tag = docker_image_tag + '_' + git_ver + '_' + cur_time
                    sh "cp someconfigfrommachine ./; \
                        docker build ${docker_build_arg} --no-cache --network=host -f ${dockerfile_path} -t ${docker_image_url}:${docker_image_tag} .; \
                        docker push ${docker_image_url}:${docker_image_tag}; \
                        docker rmi ${docker_image_url}:${docker_image_tag}; \
                    "
                }
            }
        }
        stage('restart pod') {
            agent {
                label "${agent_label}"
            }
            options {
                skipDefaultCheckout true
            }
            steps {
                script {
                    sh """${k8s_deploy_cluster}; \
                            sed -i \"s#image: images_tag#image: ${docker_image_url}:${docker_image_tag}#g\"  ${k8s_yaml_path}; \
                            kubectl apply -f ${k8s_yaml_path};
                    """
                }
            }
        }
        stage('check deployment') {
            agent {
                label "${agent_label}"
            }
            options {
                skipDefaultCheckout true
            }
            steps {
                script {
                    sh """
                    ${k8s_deploy_cluster}; \
                    for((i=1; i<=40; i++));do sleep 10; \
                        if [[ \$(kubectl rollout status --watch=false deployment ${k8s_controller}) == *"successfully rolled out"* ]]; then break; fi; \
                        if [ \$i -eq 39 ]; then exit 1; fi; \
                        echo "check sequence fro \$i"; \
                    done; \
                    echo '-------------'; \
                    kubectl get deployment | grep "${k8s_controller}\\|NAME"; \
                    kubectl get po | grep "${k8s_controller}\\|NAME"; \
                    kubectl get svc | grep "${k8s_controller}\\|NAME"; \
                    """
                }
            }
        }
    }
    post {
        cleanup {
            /* clean up our workspace */
            deleteDir()
            /* clean up tmp directory */
            dir("${workspace}@2") {
                deleteDir()
            }
            dir("${workspace}@tmp") {
                deleteDir()
            }
            dir("${workspace}@2@tmp") {
                deleteDir()
            }
            /* clean up script directory */
            dir("${workspace}@script") {
                deleteDir()
            }
        }
    }
}
def notifyQA(ppl_params) {
    script {
        def GET_BUILD_USER_ID
        def GET_BUILD_USER
        wrap([$class: 'BuildUser']) {
            GET_BUILD_USER_ID = sh(script: 'echo "${BUILD_USER_ID}"', returnStdout: true).trim()
            GET_BUILD_USER = sh(script: 'echo "${BUILD_USER}"', returnStdout: true).trim()
        }
        def git_project_name = ppl_params.git_project_name
        def jenkins_job_name = ppl_params.jenkins_job_name
        def refspec = ppl_params.refspec
        def qa_approver = ppl_params.qa_approver
        sh """
            curl -k -sS 'https://oapi.dingtalk.com/robot/send?access_token=aaaaaaaaaaaaaaaaaaaaaaaaaaaa' \\
                -H 'Content-Type: application/json' \\
                -d '{
                        "msgtype": "markdown",
                        "markdown": {
                            "title": "${git_project_name} - ${JOB_BASE_NAME} 发布，待 ${qa_approver} 确认 QA 结果！",
                            "text": "#### ${git_project_name} - ${JOB_BASE_NAME} 发布，待 ${qa_approver} 确认 QA 结果！\n
  > BuildUser: ${GET_BUILD_USER_ID}(${GET_BUILD_USER})\n
  > Branch: ${refspec}\n
  > StageName: ${jenkins_job_name}\n
  > BUILD_URL: [${BUILD_URL}](${BUILD_URL})\n
  > JOB_DISPLAY_URL: [${JOB_DISPLAY_URL}](${JOB_DISPLAY_URL})\n
  > RUN_DISPLAY_URL: [${RUN_DISPLAY_URL}](${RUN_DISPLAY_URL})
"
                        }
                    }'
        """
    }
}
```