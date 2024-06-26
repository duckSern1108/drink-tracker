import groovy.util.*

// Powered by Infostretch
pipeline {
    agent any

    parameters {
        // the default choice for commit-triggered builds is the first item in the choices list
        choice(name: 'buildVariant', choices: ['Debug_Scan_Only', 'Debug_TestFlight', 'Release_AppStore_TestFlight'], description: 'The variants to build')
        booleanParam(name: 'Push_To_Remote', defaultValue: false, description: 'Toggle to push changes back to remote(check for repo permission on this)')
    }
    environment {

        // Fastlane Environment Variables, in order to make fastlane in PATH with rvm
        PATH =  "$HOME/.fastlane/bin:" +
                "$HOME/.rvm/gems/ruby-2.6.3/bin:" +
                "$HOME/.rvm/gems/ruby-2.6.3@global/bin:" +
                "$HOME/.rvm/rubies/ruby-2.6.3/bin:" +
                "/usr/local/bin:" +
                "$PATH"
       
        LC_ALL = 'en_US.UTF-8'
        LANG = 'en_US.UTF-8'
        LANGUAGE = 'en_US.UTF-8'

        APP_NAME = 'Drink Tracker'
        BUILD_NAME = 'Drink Tracker'
        
        APP_TARGET = 'Drink Tracker'
        APP_SCHEME = 'Drink Tracker'
        APP_PROJECT = 'Drink Tracker.xcodeproj'
        APP_WORKSPACE = 'Drink Tracker.xcworkspace'
        APP_TEST_SCHEME = 'Drink Tracker'

    APP_BUILD_CONFIG = 'Debug'
    APP_EXPORT_METHOD = 'app-store'
    APP_COMPILE_BITCODE = false
    GROUPS = 'Distribution group name'
    APP_DISTRIBUTION = 'testflight'
    APP_PROVISIONING_PROFILE = 'Test Flight test Profile'
    APP_CODESIGN_CERTIFICATE = 'iPhone Distribution: Multibranch Sample XV86347CF'
        
        APP_STATIC_CODE_ANALYZER_REPORT = true
        APP_COVERAGE_REPORT = true

        BRANCH_NAME = 'Release/multibranchpipeline_ios'
        APP_CLEAN_BUILD = false
        PUBLISH_TO_CHANNEL = 'teams'
        
        FASTLANE = 'bundle exec fastlane'
    }

    options {
        skipDefaultCheckout(true)
    }

    stages {
        
        //<< Git SCM Checkout >>
        stage('Git Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Update Env with Build Variant') {
            steps {
                script {
                    env.BUILD_VARIANT = params.buildVariant
                    // Conditionally define a build variant 'impact'
                    if (BUILD_VARIANT == 'Debug_TestFlight') {
                        echo "Debug_TestFlight"
                    } else if (BUILD_VARIANT == 'Release_AppStore_TestFlight') {
                        echo "Release_AppStore_TestFlight"
                    } else {
                       echo "Else block!!"
                    }
                }
            }
        }

        stage('Dot Files Check') {
            steps {
                script {
                    sh "if [ -e .gitignore ]; then echo '.gitignore found'; else echo 'no .gitignore found' && exit 1; fi"
                }
            }
        }

        stage('Git - Fetch Version/Commits') {
            steps {
                script {
                    env.GIT_COMMIT_MSG = sh(returnStdout: true, script: '''
                    git log -1 --pretty=%B ${GIT_COMMIT}
                    ''').trim()

                    env.BUILD_NUMBER_XCODE = sh(returnStdout: true, script: '''
                    echo $(xcodebuild -target "${APP_TARGET}" -configuration "${APP_BUILD_CONFIG}" -showBuildSettings  | grep -i 'CURRENT_PROJECT_VERSION' | sed 's/[ ]*CURRENT_PROJECT_VERSION = //')
                    ''').trim()

                    env.BUNDLE_SHORT_VERSION = sh(returnStdout: true, script: '''
                    echo $(xcodebuild -target "${APP_TARGET}" -configuration "${APP_BUILD_CONFIG}" -showBuildSettings  | grep -i 'MARKETING_VERSION' | sed 's/[ ]*MARKETING_VERSION = //')
                    ''').trim()

                    env.APP_BUNDLE_IDENTIFIER = sh(returnStdout: true, script: '''
                    echo $(xcodebuild -target "${APP_TARGET}" -configuration "${APP_BUILD_CONFIG}" -showBuildSettings  | grep -i 'PRODUCT_BUNDLE_IDENTIFIER' | sed 's/[ ]*PRODUCT_BUNDLE_IDENTIFIER = //')
                    ''').trim()

                    def DATE_TIME = sh(returnStdout: true, script: '''
                    date +%Y.%m.%d-%H:%M:%S
                    ''').trim()

                    env.APP_BUILD_NAME = "${env.APP_NAME}-${env.BUILD_NUMBER}-Ver-${env.BUNDLE_SHORT_VERSION}-B-${env.BUILD_NUMBER_XCODE}-${DATE_TIME}"
                    echo "Build Name: ${env.APP_BUILD_NAME}"

                    env.GIT_BRANCH = sh(returnStdout: true, script: '''
                    git name-rev --name-only HEAD
                    ''').trim()
                    echo "Branch name: ${env.BRANCH_NAME}"
                    echo "Current Branch: ${env.GIT_BRANCH}"
                }
            }
        }
        
        stage('Pod install') {
            steps {
                script {
                    try {
                        sh """
                        #!/bin/bash
                        echo "Pod install..."
                        pod install
                        """
                    } catch(exc) {
                        currentBuild.result = "UNSTABLE"
                        error('There are failed tests.')
                    }
                }
            }
        
        }

        stage('Unit Test cases') {
                    steps {
                        script {
                                try {
                                    sh """
                                    #!/bin/bash
                                    echo "Executing Fastlane test lane..."
                                    bundle exec fastlane tests
                                    """
                                } catch(exc) {
                                    currentBuild.result = "UNSTABLE"
                                    error('There are failed tests.')
                                }
                            }
                        }
                    post {
                            always {
                                junit(testResults: '**/reports/report.junit', allowEmptyResults: true)
                            }
                        }
        }

        stage('Building') {
            // Shell build step
            steps {
                script {
                    if (env.BUILD_VARIANT == 'Debug_Scan_Only') {
                        stage ('Scan - Build Only') {
                            sh "xcodebuild -workspace '${env.APP_WORKSPACE}' -scheme '${env.APP_SCHEME}' -sdk iphoneos -configuration \"${env.APP_BUILD_CONFIG}\" CODE_SIGN_IDENTITY=\"\" CODE_SIGNING_REQUIRED=NO CODE_SIGN_ENTITLEMENTS=\"\" CODE_SIGNING_ALLOWED=\"NO\" build"
                        }
                    } else {
                        stage ('Distribute - Build & Archive') {
                            sh """
                            #!/bin/bash
                            echo "Executing Fastlane build lane to build..."
                            ${ env.FASTLANE } build app_build_name:${env.APP_BUILD_NAME}
                            """
                        }
                    }
                }
            }
        }

    }

    post {

        always {
            echo "Build completed with status: ${currentBuild.result}"
        }
    }
}
