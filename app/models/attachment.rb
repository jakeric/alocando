class Attachment < ApplicationRecord
  mount_uploader :photo, PhotoUploader
  # belongs_to :city
  # JULIO: I commented line 3 because I just followed the lecture
  # lecture: https://kitt.lewagon.com/knowledge/lectures/05-Rails%2F05-Rails-MC-with-images#source
end
