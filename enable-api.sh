PROJECT_ID="gcp-learning-401106"

for api in compute.googleapis.com \
           storage-api.googleapis.com \
           bigquery.googleapis.com \
           appengine.googleapis.com \
           cloudfunctions.googleapis.com \
           container.googleapis.com \
           pubsub.googleapis.com \
           cloudbuild.googleapis.com \
           vision.googleapis.com \
           speech.googleapis.com  \
           dns.googleapis.com
do
  gcloud services enable "$api" --project="$PROJECT_ID"
done
