FROM node:12

WORKDIR /client/build

ADD /client/build .

WORKDIR /server

COPY /server/package.json /server/package-lock.json ./

RUN npm install --production

# if you encounter bcrypt errors -> replace it with 'bcrypt.js',
# just npm install it, remove bcrypt and update instances to "require('bcrypt.js')""

# RUN git clone https://github.com/vishnubob/wait-for-it.git

#Change to your Port

EXPOSE 8080 

COPY /server .

# CMD ["./wait-for-it/wait-for-it.sh", "mysql:3306", "--", "npm", "run", "spinup"]

CMD ["npm", "run", "spinup"]

# in your package.json add a script that migrates your database and then start your server
# example -> 
# "seed": "npx sequelize db:seed:all"
# "undoseed": "npx sequelize db:seed:undo:all"
# "migrate": "npx sequelize db:migrate"
# "dev": "how you start your server"
# "spinup": "npm run migrate && npm run dev"
# "spinupseed": "npm run migrate && npm run undoseed && npm run seed && npm run dev" // for continuesly seeding data



