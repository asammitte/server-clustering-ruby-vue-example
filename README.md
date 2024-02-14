# Server clustering

## Back
1. install dependencies `bundle install`
2. establish connection with Elasticsearch
3. establich connection to your MySQL or Postgres relational DB
4. Specify crags index name in `app/models/crag`

run backend:
```
cd api
rails server -p 8040
```

## Front
1. In `app` directory create `.env` file
2. Put next config variables

```
API_URL="http://localhost:8040/"
NUXT_PUBLIC_MAPBOX_ACCESS_TOKEN=
```

3. add access token to `NUXT_PUBLIC_MAPBOX_ACCESS_TOKEN` from mapbox
4. install dependencies `yarn install`

run ui:
```
cd app
yarn dev
```
