# Google Cloud Deploy Tutorial
## Deploying a Fullstack React App + Express.js + MySQL
### automatically deploy on every event(default is push) to the branch of your choice.



## steps:
1. Create a Google Cloud Project -> use your free trial and make sure the account has billing. 
2. Create a Service Account User :
    - Go to the I AM & ADMIN -> Service Accounts -> Create Service Account
    - Give it a name and Add the following Roles :
        1. Compute Admin
        2. Compute Instance Admin (v1)
        3. Service Account User
        4. Storage Admin
3. Create Key for the service account you've created -> select in JSON format.
    1. change filename to "key.json" and use your terminal cd into the folder where your key was downloaded.
    2. encrypt the file -> 
    - windows: <code>certutil -encode key.json tmp.b64 && findstr /v /c:- tmp.b64 > key.b64</code>
    - linux: <code>	base64 key.json > key.b64</code>
    - macOs: <code>	base64 -i key.json -o key.b64</code>
4. head over to your repository on github, go to Settings -> Secrets and ADD the following secrets :
- DB_HOST -> MySql Host name (of your choice)
- DB_PASS -> MySql Password (of your choice)
- DB_NAME -> MySql Database (of your choice)
- DB_USER -> MySql User (of your choice)
- GOOGLE_APPLICATION_CREDENTIALS -> Paste the contents of your key.b64 file
- PROJECT_ID -> Your project id 
- SERVICE_ACCOUNT -> The full email that represents your service account

<a href="https://console.cloud.google.com/flows/enableapi?apiid=containerregistry.googleapis.com,compute.googleapis.com">Enable Compute Engine API + Container Registry For Your Project</a>

open your project in vscode, in your root directory run ->  
<code> git clone https://github.com/ZBejavu/gcloud-deploy-tutorial.git </code>

## Adaptations :
- Copy -> into your project root folder :
    - .github folder with its contents
    - Dockerfile, docker-compose, Makefile, .dockerignore
- Create a script in your Server Package.json file as described in the Dockerfile.
- Configure Your Sequelize Config as Shown in the examples/config folder
- MAKE SURE your server Serves the Build files as Shows in the examples/server/app.js
- Specify in Docker-Deploy.yml :
    1. The Deploy Branch (deploy will happen when you push to that branch)
    2. Name your Instance (GCE_INSTANCE Variable)
    3. Enter your SERVER_PORT
- Delete the 'gcloud-deploy-tutorial' directory when you've finished setting up.

** the Dockerfile and workflow were both made for client folder named 'client' and server folder named 'server'  
** Change folder names if necessary, update Port number in the Dockerfile, compose file and Workflow file if needed.

## Commit + Push to github, Watch Your Workflow in Actions tab 
*** <b>(push changes to MASTER / the branch you want the deploy to happen at )</b>  
Visit Compue Engine -> VM Instances to view your app when workflow finished succesfully  
visit the external-ip:yourportnumber to view your application

## Resources:

[https://www.youtube.com/watch?v=OXE2a8dqIAI&t=2637s](https://www.youtube.com/watch?v=OXE2a8dqIAI&t=2637s) - Great Video, Understanding the Docker-Deploy.yml file, Makefile

[https://cloud.google.com/sdk/gcloud/reference/compute/instances/create](https://cloud.google.com/sdk/gcloud/reference/compute/instances/create) - Instance create documentation

[https://github.com/google-github-actions/setup-gcloud](https://github.com/google-github-actions/setup-gcloud) - gcloud @action documentation

[https://www.youtube.com/watch?v=0B2raYYH2fE&t=232s](https://www.youtube.com/watch?v=0B2raYYH2fE&t=232s) - Quick docker-compose explanation