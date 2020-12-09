ZONE=${GCE_INSTANCE_ZONE}
LOCAL_TAG=${GCE_INSTANCE}-image:$(GITHUB_SHA)
REMOTE_TAG=gcr.io/${PROJECT_ID}/$(LOCAL_TAG)
CONTAINER_NAME=app-container
NETWORK_NAME=my-net

ssh-cmd:
	@gcloud --quiet compute ssh \
		--zone $(ZONE) ${GCE_INSTANCE} --command "$(CMD)"

build:
	docker build -t $(LOCAL_TAG) .

push:
	docker tag $(LOCAL_TAG) $(REMOTE_TAG)
	docker push $(REMOTE_TAG)

create:
	@gcloud compute instances create ${GCE_INSTANCE} \
		--image-project cos-cloud \
		--image cos-stable-85-13310-1041-28 \
		--zone $(ZONE) \
		--service-account ${SERVICE_ACCOUNT} \
		--tags http-server \
		--machine-type e2-medium

create-firewall-rule:
	@gcloud compute firewall-rules create default-allow-http-${SERVER_PORT} \
		--allow tcp:${SERVER_PORT} \
		--source-ranges 0.0.0.0/0 \
		--target-tags http-server \
		--description "Allow port ${SERVER_PORT} access to http-server"

remove-env:
	$(MAKE) ssh-cmd CMD='rm .env'

network-init:
	$(MAKE) ssh-cmd CMD='docker network create $(NETWORK_NAME)'

volume-create:
	$(MAKE) ssh-cmd CMD='docker volume create db-data'

remove-images:
	@$(MAKE) ssh-cmd CMD='docker image prune -a -f'

sql-init:
	$(MAKE) ssh-cmd CMD=' \
		docker run --name=${DB_HOST} \
			--restart=unless-stopped \
			-v db-data:/var/lib/mysql \
			-e MYSQL_ROOT_PASSWORD=${DB_PASS} \
			-e MYSQL_DATABASE=${DB_NAME} \
			-e MYSQL_USER=${DB_USER} \
			-e MYSQL_PASSWORD=${DB_PASS} \
			--network=$(NETWORK_NAME) \
			-d mysql:8 \
			'

start-app:
	@$(MAKE) ssh-cmd CMD='\
		docker run -d --name=$(CONTAINER_NAME) \
			--restart=unless-stopped \
			--network=$(NETWORK_NAME) \
			-e MYSQL_HOST=${DB_HOST} \
			-e MYSQL_DATABASE=${DB_NAME} \
			-e MYSQL_USER=${DB_USER} \
			-e MYSQL_PASSWORD=${DB_PASS} \
			--env-file=.env \
			-p ${SERVER_PORT}:${SERVER_PORT} \
			$(REMOTE_TAG) \
			'
# ADD the followoing line bellow MYSQL_PASSWORD If you added the ENV_FILE Secret :
# --env-file=.env \ 

initialize:
	@echo "configuring vm to use docker commands"
	$(MAKE) ssh-cmd CMD='docker-credential-gcr configure-docker'
	@echo "creating network..."
	$(MAKE) network-init
	@echo "creating volume for database..."
	$(MAKE) volume-create
	@echo "initializing sql ..."
	$(MAKE) sql-init

deploy: 
	@echo "pulling image..."
	$(MAKE) ssh-cmd CMD='docker pull $(REMOTE_TAG)'
	@echo "stopping old container..."
	-$(MAKE) ssh-cmd CMD='docker container stop $(CONTAINER_NAME)'
	@echo "removing old container..."
	-$(MAKE) ssh-cmd CMD='docker container rm $(CONTAINER_NAME)'
	@echo "starting new container..."
	@$(MAKE) start-app
	@echo "Good Job Deploy Succeded !"
	$(MAKE) remove-images
	@echo "Good Job Deploy Succeded !"