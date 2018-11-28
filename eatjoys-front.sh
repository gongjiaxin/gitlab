#!/bin/sh


#env

if [[ $? == 0 ]]; then
	if [[ $CI_BUILD_REF_SLUG == 'master' ]]; then

		hostlist=""
		if [[ $CI_JOB_STAGE == 'test' ]]; then

				hostlist="47.99.89.247"
		fi
		if [[ $CI_JOB_STAGE == 'deploy' ]]; then
				hostlist="47.99.145.156 47.99.145.156"
				if [[ $1 == 1 ]]; then
					hostlist="47.99.145.156 47.99.145.156"
				fi

				if [[ $1 == 2 ]]; then
					hostlist="47.99.89.247 47.99.89.247"
				fi
				
		fi
		
		projectdir="/work/front/${CI_PROJECT_NAME}"
		yarn  

		if [ $? = 0 ]; then
			npm run build
			
			for i in $hostlist
			do
				echo
				echo 
				echo "-----------------------------------------------------------------------"
				echo "发布 主机: $i  项目: $CI_PROJECT_NAME "
				cd $CI_PROJECT_DIR
				echo scp -r $CI_PROJECT_DIR/dist/\* root@${i}:${projectdir}/
				rsync -avztH --delete $CI_PROJECT_DIR/dist/ root@${i}:${projectdir}/
				if [ $? = 0 ]; then
					echo "node 成功...."
					else   
					echo "node 构建失败...."
					exit 100
				fi
				echo
				echo
			done
		else
				echo "node 构建失败...."
				exit 100
		fi


	elif [[ $CI_BUILD_REF_SLUG == 'release' ]]; then
		#发布到开发创建和测试环境
		hostlist="47.99.89.247"
		projectdir="/work/front/${CI_PROJECT_NAME}"

		for i in $hostlist
		do
			                        echo
                        echo 
                        echo "-----------------------------------------------------------------------"
                        echo "发布 主机: $i  项目: $CI_PROJECT_NAME "
			cd $CI_PROJECT_DIR
			yarn 
			if [ $? = 0 ];then
			                  npm run build
                              echo scp -r $CI_PROJECT_DIR/dist/\* root@${i}:${projectdir}/
                              rsync -avztH --delete $CI_PROJECT_DIR/dist/ root@${i}:${projectdir}/
                         if [ $? = 0 ]; then
			                echo "node 构建成功...."
			             else   
			                echo "node 构建失败...."
			                exit 100
			             fi
			else
                               echo "node 构建失败...."
                               exit 100
                        fi
                        echo
                        echo
		done

        elif [[ $CI_BUILD_REF_SLUG == 'develop' ]]; then
                #发布到开发创建和测试环境
                hostlist="47.99.89.247"
                projectdir="/work/front/${CI_PROJECT_NAME}"

                for i in $hostlist
                do
                                                echo
                        echo
                        echo "-----------------------------------------------------------------------"
                        echo "发布 主机: $i  项目: $CI_PROJECT_NAME "
			cd $CI_PROJECT_DIR
			yarn 
			if [ $? = 0 ]; then
			                  npm run build
                               echo scp -r $CI_PROJECT_DIR/dist/\* root@${i}:${projectdir}/
                      	       rsync -avztH --delete $CI_PROJECT_DIR/dist/ root@${i}:${projectdir}/
                         if [ $? = 0 ]; then
			                echo "node 构建成功...."
			             else   
			                echo "node 构建失败...."
			                exit 100
			             fi
			else
	                       echo "node 构建失败...."
		       	       exit 100
			fi
                        echo
                        echo
                done

	fi
fi
