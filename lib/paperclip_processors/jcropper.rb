# Jcropper paperclip processor
#
# This processor very slightly changes the default thumbnail processor in order
# to work properly with Jcrop the jQuery cropper plugin.
 
module Paperclip
  # Handles thumbnailing images that are uploaded.
  class Jcropper < Thumbnail
    
		def initialize(file, options = {}, attachment = nil)
			@jcrop = options.delete(:jcrop)
			if options[:geometry].nil?
				options[:geometry] = Geometry.from_file(file).to_s
			end
			super
		end

		def transformation_command
      if @jcrop and (cmd = crop_command)
				cmd + super.join(' ').sub(/ -crop \S+/, '').split(' ')
			else
        super
      end
    end
    
    def crop_command
      target = @attachment.instance
			name = @attachment.name
			crop_x = target.send("#{name}_crop_x")
			crop_y = target.send("#{name}_crop_y")
			crop_w = target.send("#{name}_crop_w")
			crop_h = target.send("#{name}_crop_h")
      if !crop_x.blank? and !crop_y.blank? and !crop_w.blank? and !crop_h.blank?
				rx = @attachment.geometry(:original).width / @attachment.geometry(:medium).width
				ry = @attachment.geometry(:original).height / @attachment.geometry(:medium).height

				["-crop","#{crop_w.to_i*rx}x#{crop_h.to_i*ry}+#{crop_x.to_i*rx}+#{crop_y.to_i*ry}"]
			else
				nil
      end
    end
  
  end

	class Attachment
		def geometry(*style)
			if (path = path(*style))
				Geometry.from_file path
			else
				nil
			end
		end
	end
   
end
