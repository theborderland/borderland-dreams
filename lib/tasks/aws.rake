namespace :aws do
  task :migrate => :environment do
    Image.pluck(:id).each do |iid|
      i = Image.find(iid)

      if i.image
        sio = StringIO.new(i.image)
        sio.class.class_eval { attr_accessor :original_filename, :content_type }

        sio.content_type = "image/jpeg"
        sio.original_filename = "image" + i.id.to_s + ".jpeg"

        i.attachment = sio
        i.save

        sio.truncate(0)
      end
    end
  end
end
