# frozen_string_literal: true

json.status response.status
json.data do
  json.presigned_aws_url @url
end
