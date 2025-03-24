class AwsApi < Api

  BUCKET = 'sa-portal'

  def get_id_link(request:)
    return unless request.notes
    s3 = Aws::S3::Resource.new
    bucket = s3.bucket(BUCKET)
    obj = bucket.object(request.notes)
    obj.presigned_url(:get, expires_in: 300, response_content_disposition: 'inline', response_content_type: nil)
  end 


end 