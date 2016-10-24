class Image < ActiveRecord::Base
  # Add paperclip for S3
  has_attached_file :attachment, {
                      styles: {
                        thumb: '100x100>',
                        square: '311x222#',
                        medium: '300x300>',
                        large: '500x500>'
                      },
                      :convert_options => {
                        :all => "-quality 85 -interlace Plane"
                      }
                    }

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/
end
