BUCKET_NAME=yourbucketnamehere

# create a bucket
aws s3 mb s3://$BUCKET_NAME

# Generate a 100 MB file
dd if=/dev/zero of=100MB.txt bs=1MB count=100

# Split it into 3 parts of 35 MB
split -b 35m 100MB.txt 100MB_part_

# Initiate the multi-part upload
aws s3api create-multipart-upload --bucket $BUCKET_NAME --key 100MB.txt

# get back the upload_id and insert it below
UPLOAD_ID=LO99SQpq7LSDaMiArIV0SWCUlc3fyCBXflTX8yfae8Ux62y2nkceBXProyeV54kN4SIajjOZvE7x8btrohRLXpJKcu0vQd7oomr2ATVu8iTC.lFc4nPDLvwZVpFMoqL9AXiXuQPYANbIw8jT.7q42A--

# list existing multi part uploads
aws s3api list-multipart-uploads --bucket $BUCKET_NAME

# Upload the parts
aws s3api upload-part --bucket $BUCKET_NAME --key 100MB.txt --part-number 1 --body 100MB_part_aa --upload-id $UPLOAD_ID

aws s3api upload-part --bucket $BUCKET_NAME --key 100MB.txt --part-number 2 --body 100MB_part_ab --upload-id $UPLOAD_ID

aws s3api upload-part --bucket $BUCKET_NAME --key 100MB.txt --part-number 3 --body 100MB_part_ac --upload-id $UPLOAD_ID

# list the parts
aws s3api list-parts --upload-id $UPLOAD_ID --bucket $BUCKET_NAME --key 100MB.txt

# Complete multi-part upload
aws s3api complete-multipart-upload --bucket $BUCKET_NAME --key 100MB.txt --upload-id $UPLOAD_ID --multipart-upload "{\"Parts\":[{\"ETag\":\"etag1\",\"PartNumber\":1},{\"ETag\":\"etag2\",\"PartNumber\":2},{\"ETag\":\"etag3\",\"PartNumber\":3}]}"
